#!/bin/bash

# GFA
# !!!! BECAUSE OF ALIBI'S INTERESTING INVOCATION TACTICS, WE ALSO NEED TO SPECIFY THE FULL PATH !!!!
#GG=/home/heumos/Downloads/hogwild_paper/1D/DRB1-3123.fa.gz.seqwish.gfa
#GG=/home/heumos/git/pangenome/results_LPA/seqwish/LPA.fa.gz.seqwish.gfa
GG=/home/heumos/git/pangenome/results_yeast/seqwish/cerevisiae.pan.fa.gz.seqwish.gfa
G=$(basename "$GG")
GA=$(ls "$GG" | sed 's/.gfa/_sorted.gfa/g')
# path to ALIBI executable
A=/home/heumos/git/ALIBI
P=$(pwd)

echo "ALIBI: "$A""
echo "CURRENT PATH: "$P""

# TODO this is just to test the script, select a larger graph later
if [ ! -f "$GG" ]; then
    wget https://raw.githubusercontent.com/pangenome/odgi/master/test/DRB1-3123.fa.gz.seqwish.gfa
fi

#echo "$GG"
#echo "$G"

# number of iterations
ITER=3
# number of threads
T=16

## odgi_Y
if [ ! -d odgi_Y ]; then
    mkdir odgi_Y
fi

for i in $(eval echo "{1.."$ITER"}") # https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
do
    echo "odgi_Y: $i"
    /usr/bin/time --verbose odgi sort -i "$GG" -o odgi_Y/"$G".Y.og --threads "$T" -P -Y 2> odgi_Y/odgi_Y_time_"$i"
done
### take a look at the last sorted graph
odgi stats -i odgi_Y/"$G".Y.og -m > odgi_Y/"$G".Y.og.stats.yml

## odgi_s
if [ ! -d odgi_s ]; then
    mkdir odgi_s
fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "odgi_s: $i"
    /usr/bin/time --verbose odgi sort -i "$GG" -o odgi_s/"$G".g.og --threads "$T" -P -p s 2> odgi_s/odgi_s_time_"$i"
done
odgi stats -i odgi_s/"$G".g.og -m > odgi_s/"$G".s.og.stats.yml

## odgi_Ygs
if [ ! -d odgi_Ygs ]; then
    mkdir odgi_Ygs
fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "odgi_Ygs: $i"
    /usr/bin/time --verbose odgi sort -i "$GG" -o odgi_Ygs/"$G".Ygs.og --threads "$T" -P -p Ygs 2> odgi_Ygs/odgi_Ygs_time_"$i"
done
odgi stats -i odgi_Ygs/"$G".Ygs.og -m > odgi_Ygs/"$G".Ygs.og.stats.yml

## alibi
if [ ! -d alibi ]; then
    mkdir alibi
fi

cd "$A"

for i in $(eval echo "{1.."$ITER"}")
do
    echo "alibi: $i"
    /usr/bin/time --verbose bash alibi.sh -i "$GG" 2> "$P"/alibi/alibi_sort_time_"$i"
    (/usr/bin/time --verbose grep "^S" "$GA" | cut -f 2 > "$P"/alibi/"$G".alibi.order) 2> "$P"/alibi/alibi_grep_time_"$i"
    /usr/bin/time --verbose odgi sort -i "$GG" -s "$P"/alibi/"$G".alibi.order -P -o "$P"/alibi/"$G".alibi.og 2> "$P"/alibi/alibi_order_time_"$i"
done
cd "$P"
odgi stats -i alibi/"$G".alibi.og -m > alibi/"$G".alibi.og.stats.yml

if [ -f odgi_Y/odgi_Y_time.csv ] ; then
    rm odgi_Y/odgi_Y_time.csv
fi
if [ -f odgi_s/odgi_s_time.csv ] ; then
    rm odgi_s/odgi_s_time.csv
fi
if [ -f odgi_Ygs/odgi_Ygs_time.csv ] ; then
    rm odgi_Ygs/odgi_Ygs_time.csv
fi
if [ -f alibi/alibi_sort_time.csv ] ; then
    rm alibi/alibi_sort_time.csv 
fi
if [ -f alibi/alibi_grep_time.csv ] ; then
    rm alibi/alibi_grep_time.csv 
fi
if [ -f alibi/alibi_order_time.csv ] ; then
    rm alibi/alibi_order_time.csv 
fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "$i",$(grep Elapsed odgi_Y/odgi_Y_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" odgi_Y/odgi_Y_time_"$i" | cut -f 6 -d ' ') >> odgi_Y/odgi_Y_time.csv
    echo "$i",$(grep Elapsed odgi_s/odgi_s_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" odgi_s/odgi_s_time_"$i" | cut -f 6 -d ' ') >> odgi_s/odgi_s_time.csv
    echo "$i",$(grep Elapsed odgi_Ygs/odgi_Ygs_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" odgi_Ygs/odgi_Ygs_time_"$i" | cut -f 6 -d ' ') >> odgi_Ygs/odgi_Ygs_time.csv
    echo "$i",$(grep Elapsed alibi/alibi_sort_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" alibi/alibi_sort_time_"$i" | cut -f 6 -d ' ') >> alibi/alibi_sort_time.csv
    echo "$i",$(grep Elapsed alibi/alibi_grep_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" alibi/alibi_grep_time_"$i" | cut -f 6 -d ' ') >> alibi/alibi_grep_time.csv
    echo "$i",$(grep Elapsed alibi/alibi_order_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" alibi/alibi_order_time_"$i" | cut -f 6 -d ' ') >> alibi/alibi_order_time.csv
done

#Rscript ...
Rscript sort_time.R odgi_Y/odgi_Y_time.csv odgi_s/odgi_s_time.csv odgi_Ygs/odgi_Ygs_time.csv alibi/alibi_sort_time.csv alibi/alibi_grep_time.csv alibi/alibi_order_time.csv sort_time.pdf sort_time_supp.csv
Rscript sort_stats.R odgi_Y/"$G".Y.og.stats.yml odgi_s/"$G".s.og.stats.yml odgi_Ygs/"$G".Ygs.og.stats.yml alibi/"$G".alibi.og.stats.yml stats.pdf stats_supp.csv
