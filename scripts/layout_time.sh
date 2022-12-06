#!/bin/bash

# GFA
#GG=DRB1-3123.fa.gz.seqwish.gfa
#GG=/home/heumos/git/pangenome/results_LPA/seqwish/LPA.fa.gz.seqwish.gfa
GG=/home/heumos/git/pangenome/results_yeast/seqwish/cerevisiae.pan.fa.gz.seqwish.gfa
G=$(basename "$GG")

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

## odgi layout && odgi draw

### does the folder already exist?
if [ ! -d odgi ]; then
    mkdir odgi
fi

for i in $(eval echo "{1.."$ITER"}") # https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
do
    echo "odgi layout: $i"
    /usr/bin/time --verbose odgi layout -i "$GG" -o odgi/"$G.lay" --threads "$T" -P 2> odgi/odgi_layout_time_"$i"
    echo "odgi draw: $i"
    /usr/bin/time --verbose odgi draw -i "$GG" -c odgi/"$G.lay" -p odgi/"$G.lay.png" -P 2> odgi/odgi_draw_time_"$i"
done

## BandageNG

if [ ! -d BandageNG ]; then
    mkdir BandageNG
fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "BandageNG: $i"
    /usr/bin/time --verbose BandageNG image "$GG" BandageNG/"$G".BandageNG.png 2> BandageNG/BandageNG_time_"$i"
done

## Bandage

if [ ! -d Bandage ]; then
    mkdir Bandage
fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "Bandage: $i"
    /usr/bin/time --verbose Bandage image "$GG" Bandage/"$G".Bandage.png 2> Bandage/Bandage_time_"$i"
done

## gfaviz

#if [ ! -d gfaviz ]; then
#    mkdir gfaviz
#fi

#for i in $(eval echo "{1.."$ITER"}")
#do
#    echo "gfaviz: $i"
#    /usr/bin/time --verbose gfaviz --no-gui "$GG" --output gfaviz/"$G".gfaviz.png 2> gfaviz/gfaviz_time_"$i"
#done

if [ -f odgi/odgi_layout_time.csv ] ; then
    rm odgi/odgi_layout_time.csv
fi
if [ -f odgi/odgi_draw_time.csv ] ; then
    rm odgi/odgi_draw_time.csv 
fi
if [ -f BandageNG/BandageNG_time.csv ] ; then
    rm BandageNG/BandageNG_time.csv 
fi
if [ -f Bandage/Bandage_time.csv ] ; then
    rm Bandage/Bandage_time.csv 
fi
#if [ -f gfaviz/gfaviz_time.csv ] ; then
#    rm gfaviz/gfaviz_time.csv 
#fi

for i in $(eval echo "{1.."$ITER"}")
do
    echo "$i",$(grep Elapsed odgi/odgi_layout_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" odgi/odgi_layout_time_"$i" | cut -f 6 -d ' ') >> odgi/odgi_layout_time.csv
    echo "$i",$(grep Elapsed odgi/odgi_draw_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" odgi/odgi_draw_time_"$i" | cut -f 6 -d ' ') >> odgi/odgi_draw_time.csv
    echo "$i",$(grep Elapsed BandageNG/BandageNG_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" BandageNG/BandageNG_time_"$i" | cut -f 6 -d ' ') >> BandageNG/BandageNG_time.csv
    echo "$i",$(grep Elapsed Bandage/Bandage_time_"$i" | cut -f 8 -d ' '),$(grep "Maximum" Bandage/Bandage_time_"$i" | cut -f 6 -d ' ') >> Bandage/Bandage_time.csv
#    echo "$i",$(grep Elapsed gfaviz/gfaviz_time_"$i" | cut -f 8 -d ' ' | awk -F: '{ print ($1 * 60) + ($2) + $3 }'),$(grep "Maximum" gfaviz/gfaviz_time_"$i" | cut -f 6 -d ' ') >> gfaviz/gfaviz_time.csv
done

#Rscript ...
Rscript layout.R odgi/odgi_layout_time.csv odgi/odgi_draw_time.csv BandageNG/BandageNG_time.csv Bandage/Bandage_time.csv layout_eval.pdf layout_supp.csv # gfaviz/gfaviz_time.csv layout_eval.pdf layout_supp.csv
