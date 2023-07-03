#!/bin/bash

# Prepare the tools
cd  ~/tools
git clone --recursive https://github.com/pangenome/odgi.git
cd odgi
git checkout cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9
cmake -H. -Bbuild && cmake --build build -- -j 48
cp bin/odgi bin/odgi-cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9

ODGI=/home/guarracino/tools/odgi/bin/odgi-cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9

# Download and gunzip HPRC graphs
mkdir -p /lizardfs/guarracino/sorting-paper/graphs
cd /lizardfs/guarracino/sorting-paper/graphs
(seq 1 22; echo X; echo Y) | while read i; do echo $i; wget -c https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/chroms/chr${i}.hprc-v1.0-pggb.gfa.gz; gunzip chr${i}.hprc-v1.0-pggb.gfa.gz; done

# GFA format to ODGI format
cd /lizardfs/guarracino/sorting-paper/graphs
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p workers -c 48 --wrap "hostname; \time -v $ODGI build -g /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.gfa -o /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.og -t 48 -P"; done

# Compute the layout (both LAY and TSV formats) with default parameters
mkdir -p /lizardfs/guarracino/sorting-paper/layouts
cd /lizardfs/guarracino/sorting-paper/layouts
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p 386mem -x octopus07,octopus10 -c 48 --wrap "hostname; cd /scratch; cp /lizardfs/guarracino/sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og chr${i}.hprc-v1.0-pggb.og; \time -v $ODGI layout -i chr${i}.hprc-v1.0-pggb.og -o chr${i}.hprc-v1.0-pggb.lay -T chr${i}.hprc-v1.0-pggb.tsv -t 48 --temp-dir /scratch/; rm chr${i}.hprc-v1.0-pggb.og; mv chr${i}.hprc-v1.0-pggb.* /lizardfs/guarracino/sorting-paper/layouts/"; done

# Compute the layout (both LAY and TSV formats) with harder parameters (-x 300 -G 30 -I 50000 -l 5000)
cd /lizardfs/guarracino/sorting-paper/layouts
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p 386mem -x octopus07,octopus10 -c 48 --wrap "hostname; cd /scratch; cp /lizardfs/guarracino/sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og chr${i}.hprc-v1.0-pggb.og; \time -v $ODGI layout -i chr${i}.hprc-v1.0-pggb.og -o chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.lay -T chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.tsv -t 48 --temp-dir /scratch/ -x 300 -G 30 -I 50000 -l 5000; rm chr${i}.hprc-v1.0-pggb.og; mv chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.* /lizardfs/guarracino/sorting-paper/layouts/"; done

# Draw the layouts
cd /lizardfs/guarracino/sorting-paper/layouts
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p workers -c 48 --wrap "hostname; cd /scratch; cp /lizardfs/guarracino/sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og chr${i}.hprc-v1.0-pggb.og; cp /lizardfs/guarracino/sorting-paper/layouts/chr${i}.hprc-v1.0-pggb.lay chr${i}.hprc-v1.0-pggb.lay; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.lay -p chr${i}.hprc-v1.0-pggb.draw.png -H 1000; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.lay -p chr${i}.hprc-v1.0-pggb.draw.C.png -C -w 20 -H 1000; rm chr${i}.hprc-v1.0-pggb.og; rm chr${i}.hprc-v1.0-pggb.lay; mv chr${i}.hprc-v1.0-pggb.draw*png /lizardfs/guarracino/sorting-paper/layouts/"; done
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p workers -c 48 --wrap "hostname; cd /scratch; cp /lizardfs/guarracino/sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og chr${i}.hprc-v1.0-pggb.og; cp /lizardfs/guarracino/sorting-paper/layouts/chr${i}.hprc-v1.0-pggb.lay chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.lay; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.lay -p chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.draw.png -H 1000; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.lay -p chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.draw.C.png -C -w 20 -H 1000; rm chr${i}.hprc-v1.0-pggb.og; rm chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.lay; mv chr${i}.hprc-v1.0-pggb.x300.G30.I50k.l50k.draw*png /lizardfs/guarracino/sorting-paper/layouts/"; done
