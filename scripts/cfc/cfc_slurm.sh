# Allocate a workspace folder for 30 days
# ws_allocate sorting-paper 30

#mkdir -p /sfs/9/ws/afaaj01-sorting-paper/graphs
cp cfc_sing* /sfs/9/ws/afaaj01-sorting-paper/
cd /sfs/9/ws/afaaj01-sorting-paper/graphs
#(seq 1 22; echo X; echo Y; echo M) | while read i; do echo $i; wget -c https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/chroms/chr${i}.hprc-v1.0-pggb.gfa.gz; gunzip chr${i}.hprc-v1.0-pggb.gfa.gz; done

cd ../
#mkdir -p layouts
#mkdir -p times
#mkdir -p stats
#(seq 1 22; echo X; echo Y; echo M) | while read i; do echo $i; sbatch -p qbic --mem=100000 -J pg-sgd -c 32 -t 600 --wrap "/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi stats -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.gfa -S -t 32 > /sfs/9/ws/afaaj01-sorting-paper/stats/odgi_stats_${i}.tsv"; done;
#(seq 1 22; echo X; echo Y; echo M) | while read i; do echo $i; sbatch -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 --wrap "./cfc_sing.sh $i"; done;

#(seq 1 22; echo X; echo Y; echo M) | while read i; do echo $i; sbatch -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 --wrap "/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi build -g /sfs/9/ws/afaaj01-sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.gfa -o /sfs/9/ws/afaaj01-sorting-paper/graphs/chr${i}.hprc-v1.0-pggb.og -t 64"; done;
mkdir -p extracts
#echo MHC
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr6.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.MHC.og -r grch38#chr6:29000000-34000000
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.MHC.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.MHC.O.og -O
# TODO
#echo RCCE
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr6.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.RCCE.og -r grch38#chr6:31976719-32117146
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.RCCE.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.RCCE.O.og -O
#echo LPA
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr6.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.LPA.og -r grch38#chr6:160529904-160666180
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.LPA.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr6.hprc-v1.0-pggb.LPA.O.og -O
#echo AMY
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr1.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr1.hprc-v1.0-pggb.AMY.og -r grch38#chr1:103542345-103798299
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr1.hprc-v1.0-pggb.AMY.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr1.hprc-v1.0-pggb.AMY.O.og -O
#echo IGH
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr14.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr14.hprc-v1.0-pggb.IGH.og -r grch38#chr14:106205008-106874830
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr14.hprc-v1.0-pggb.IGH.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr14.hprc-v1.0-pggb.IGH.O.og -O
#echo ABO
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr9.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr9.hprc-v1.0-pggb.ABO.og -r grch38#chr9:133163441-133361030
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr9.hprc-v1.0-pggb.ABO.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr9.hprc-v1.0-pggb.ABO.O.og -O
#echo TSPY1
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chrY.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chrY.hprc-v1.0-pggb.TSPY1.og -r grch38#chrY:9294496-9591276
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chrY.hprc-v1.0-pggb.TSPY1.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chrY.hprc-v1.0-pggb.TSPY1.O.og -O
#echo 15q15
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr15.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr15.hprc-v1.0-pggb.15q15.og -r grch38#chr15:9294496-9591276
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr15.hprc-v1.0-pggb.15q15.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr15.hprc-v1.0-pggb.15q15.O.og -O
echo 16p21
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi extract -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr16.hprc-v1.0-pggb.og -t 64 -P -d 1000000 -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr16.hprc-v1.0-pggb.16p21.og -r grch38#chr16:9294496-9591276
#srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 singularity exec /nfsmounts/container/pg-sgd.img odgi sort -i /sfs/9/ws/afaaj01-sorting-paper/extracts/chr16.hprc-v1.0-pggb.16p21.og -o /sfs/9/ws/afaaj01-sorting-paper/extracts/chr16.hprc-v1.0-pggb.16p21.O.og -O

ls extracts/*.O.og | while read i; do f=$(basename $i); echo stats $f; sbatch -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 --wrap "/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi stats -i /sfs/9/ws/afaaj01-sorting-paper/extracts/$f -m -t 64 > /sfs/9/ws/afaaj01-sorting-paper/stats/$f.stats.yaml"; done;
# ls extracts/*.O.og | while read i; do f=$(basename $i); echo layout $f; srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 ./cfc_sing_extracts_lay.sh $f; done;
for i in extracts/*.O.og; do f=$(basename $i); echo layout $f; srun -p qbic --mem=100000 -J pg-sgd -c 64 -t 600 ./cfc_sing_extracts_lay.sh $f; done;
mkdir -p draw
ls extracts/*.O.og | while read i; do f=$(basename $i); echo draw $f; sbatch -p qbic --mem=10000 -J pg-sgd -c 1 -t 600 --wrap "/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi draw -i /sfs/9/ws/afaaj01-sorting-paper/extracts/$f -c /sfs/9/ws/afaaj01-sorting-paper/layouts/$f.lay -p /sfs/9/ws/afaaj01-sorting-paper/draw/$f.2D.R5.png -R 5"; done;
ls extracts/*.O.og | while read i; do f=$(basename $i); echo draw -C $f; sbatch -p qbic --mem=10000 -J pg-sgd -c 1 -t 600 --wrap "/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi draw -i /sfs/9/ws/afaaj01-sorting-paper/extracts/$f -c /sfs/9/ws/afaaj01-sorting-paper/layouts/$f.lay -p /sfs/9/ws/afaaj01-sorting-paper/draw/$f.2D.R5.C.w20.png -R 5 -C -w 29"; done;
