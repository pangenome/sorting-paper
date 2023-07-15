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

# Draw the layouts
cd /lizardfs/guarracino/sorting-paper/layouts
(seq 1 22; echo X; echo Y) | while read i; do echo $i; sbatch -p workers -c 48 --wrap "hostname; cd /scratch; cp /lizardfs/guarracino/sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og chr${i}.hprc-v1.0-pggb.og; cp /lizardfs/guarracino/sorting-paper/layouts/chr${i}.hprc-v1.0-pggb.lay chr${i}.hprc-v1.0-pggb.lay; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.lay -p chr${i}.hprc-v1.0-pggb.draw.png -H 1000; \time -v $ODGI draw -i chr${i}.hprc-v1.0-pggb.og -c chr${i}.hprc-v1.0-pggb.lay -p chr${i}.hprc-v1.0-pggb.draw.C.png -C -w 20 -H 1000; rm chr${i}.hprc-v1.0-pggb.og; rm chr${i}.hprc-v1.0-pggb.lay; mv chr${i}.hprc-v1.0-pggb.draw*png /lizardfs/guarracino/sorting-paper/layouts/"; done

# MHC
odgi extract -i chr6.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr6:29000000-34000000 -o - -t 48 -P | odgi sort -i - -o chr6.hprc-v1.0-pggb.MHC.og -O

# RCCE
odgi extract -i chr6.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr6:31976719-32117146 -o - -t 48 -P | odgi sort -i - -o chr6.hprc-v1.0-pggb.RCCE.og -O

# LPA
odgi extract -i chr6.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr6:160529904-160666180 -o - -t 48 -P | odgi sort -i - -o chr6.hprc-v1.0-pggb.LPA.og -O

# AMY
odgi extract -i chr1.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr1:103542345-103798299 -o - -t 48 -P | odgi sort -i - -o chr1.hprc-v1.0-pggb.AMY.og -O

# IGH
odgi extract -i chr14.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr14:106205008-106874830 -o - -t 48 -P | odgi sort -i - -o chr14.hprc-v1.0-pggb.IGH.og -O

# ABO
odgi extract -i chr9.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr9:133163441-133361030 -o - -t 48 -P | odgi sort -i - -o chr9.hprc-v1.0-pggb.ABO.og -O

# TSPY1
odgi extract -i chrY.hprc-v1.0-pggb.og -d 1000000 -r grch38#chrY:9294496-9591276 -o - -t 48 -P | odgi sort -i - -o chrY.hprc-v1.0-pggb.TSPY1.og -O

# 15q15
odgi extract -i chr15.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr15:9294496-9591276 -o - -t 48 -P | odgi sort -i - -o chr15.hprc-v1.0-pggb.15q15.og -O

# 16p21
odgi extract -i chr16.hprc-v1.0-pggb.og -d 1000000 -r grch38#chr16:9294496-9591276 -o - -t 48 -P | odgi sort -i - -o chr16.hprc-v1.0-pggb.16p21.og -O


#MHC-C2 GRCh38 chr6 32313513 32992088
#RCCE GRCh38 chr6 31976719 32117146 0
#HLA-CB GRRh38 chr6 31143427 31484914 0
#LPA GRRh38 chr6 160529904 160666180 0
#AMY GRRh38 chr1 103542345 103798299 0
#IGH GRRh38 chr14 106205008 106874830 0
#ABO GRRh38 chr9 133163441 133361030 0
#TSPY1 GRRh38 chrY 9294496 9591276 0
#15q15 GRRh38 chr15 43531685 43769928 0
#16p21 GRRh38 chr16 28139916 28830868 0

ls *.hprc-v1.0-pggb.*.og | while read f; do
    echo $f;
    odgi stats -i $f -S;
done

ls *.hprc-v1.0-pggb.*.og | while read f; do
    echo $f;
    odgi layout -i $f -o $f.lay -t 48 -P --temp-dir /scratch
done

ls *.hprc-v1.0-pggb.*.og | while read f; do
    echo $f;
    odgi draw -i $f -c $f.lay -p $f.2D.R5.png -R 5
    odgi draw -i $f -c $f.lay -p $f.2D.R5.C.w20.png -R 5 -C -w 20
done
