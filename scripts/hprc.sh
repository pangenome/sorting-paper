#!/bin/bash

# Prepare the tools
cd  ~/tools
git clone --recursive https://github.com/pangenome/odgi.git
cd odgi
git checkout cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9
cmake -H. -Bbuild && cmake --build build -- -j 48
cp bin/odgi bin/odgi-cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9

# Prepare the folder
mkdir -p /lizardfs/guarracino/sorting-paper
cd /lizardfs/guarracino/sorting-paper

# Download HPRC graphs
(seq 1 22; echo X; echo Y) | while read i; do echo $i; wget -c https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/chroms/chr${i}.hprc-v1.0-pggb.gfa.gz; done

# GFA format to ODGI format
ODGI=/home/guarracino/tools/odgi/bin/odgi-cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p workers -c 48 --wrap "hostname; \time -v $ODGI build -g /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.gfa.gz -o /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.og -t 48 -P"; done

# Compute the layout (both LAY and TSV formats)
ODGI=/home/guarracino/tools/odgi/bin/odgi-cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p 386mem -x octopus07,octopus10 -c 48 --wrap "hostname; cp /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.og /scratch/chr${i}.hprc-v1.0-pggb.og; \time -v $ODGI layout -i /lizardfs/guarracino/sorting-paper/chr${i}.hprc-v1.0-pggb.og -o xxx.lay -T xxx.tsv -t 48 --temp-dir xxx -P; move and clean"; done

# Compute the layout (both LAY and TSV formats) with harder parameters

# Draw the layouts
