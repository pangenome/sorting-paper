wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/chroms/chr6.hprc-v1.0-pggb.gfa.gz
gunzip chr6.hprc-v1.0-pggb.gfa.gz
odgi build -g chr6.hprc-v1.0-pggb.gfa -o chr6.hprc-v1.0-pggb.og -P -t 28
odgi paths -i chr6.hprc-v1.0-pggb.og -f > chr6.hprc-v1.0-pggb.fasta
samtools faidx chr6.hprc-v1.0-pggb.fasta
grep 'chm13#chr6\|grch38#chr6\|HG01928#2\|HG01071#2\|HG01106#2' chr6.hprc-v1.0-pggb.fasta.fai | cut -f 1 > 13_paths_to_extract.txt
grep 'chm13#chr6\|grch38#chr6\|HG01928#2\|HG01071#2\|HG01106#2' chr6.hprc-v1.0-pggb.fasta.fai | cut -f 1,2 | sed 's/\t/\t0\t/g' > 13_paths_to_extract.bed
odgi extract -i chr6.hprc-v1.0-pggb.og -o chr6.hprc-v1.0-pggb.13paths.og -E -b 13_paths_to_extract.bed -P -p 13_paths_to_extract.txt -t 28
odgi viz -i chr6.hprc-v1.0-pggb.13paths.og -o chr6.hprc-v1.0-pggb.13paths.og.png
bedtools merge -i /mnt/vol1/software/odgi/git/master/test/chr6.HLA_genes.bed -d 10000000 > MHC.bed
echo -e '\tMHC' >> MHC.bed
cat MHC.bed | tr '\n' ' ' | sed 's/ //g' > MHC.final.bed
odgi procbed -i chr6.hprc-v1.0-pggb.13paths.og -b MHC.final.bed > MHC.adj.bed
odgi inject -i chr6.hprc-v1.0-pggb.13paths.og -b MHC.adj.bed -o chr6.hprc-v1.0-pggb.13paths.MHC.og -P -t 28
odgi viz -i chr6.hprc-v1.0-pggb.13paths.MHC.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.png
odgi sort -i chr6.hprc-v1.0-pggb.13paths.MHC.og -r -P -t 28 -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og
odgi viz -i chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.png -u -d
odgi sort -i chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.Y.og -p Y -t 28 -P
odgi viz -i chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.Y.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.Y.og.png -u -d
odgi paths -i chr6.hprc-v1.0-pggb.13paths.MHC.og -L | grep "grch" > chr6.grch38.MHC.name
odgi sort -i chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.HY.og -P -t 28 -H chr6.grch38.MHC.name -Y
odgi viz -i chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.HY.og -o chr6.hprc-v1.0-pggb.13paths.MHC.og.r.og.HY.og.png -d -u
