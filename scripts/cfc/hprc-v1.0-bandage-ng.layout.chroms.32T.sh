#!/bin/bash

# wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/hprc-v1.0-pggb.gfa.gz
# gunzip hprc-v1.0-pggb.gfa.gz
XDG_RUNTIME_DIR=$TMPDIR
#/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img BandageNG layout /sfs/9/ws/afaaj01-sorting-paper/graphs/chr"$1".hprc-v1.0-pggb.gfa /sfs/9/ws/afaaj01-sorting-paper/layouts/chr"$1".hprc-v1.0-pggb.gfa.bng.32T.layout 2> /sfs/9/ws/afaaj01-sorting-paper/times/bng_layout_"$1".time
/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img BandageNG layout /sfs/9/ws/afaaj01-sorting-paper/graphs/chr"$1".hprc-v1.0-pggb.gfa /sfs/9/ws/afaaj01-sorting-paper/layouts/chr"$1".hprc-v1.0-pggb.gfa.bng.32T.layout 2> /sfs/9/ws/afaaj01-sorting-paper/times/bng_layout_32T_"$1".time
# /usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi layout -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr"$1".hprc-v1.0-pggb.gfa -o /sfs/9/ws/afaaj01-sorting-paper/layouts/chr"$1".hprc-v1.0-pggb.gfa.lay -t 64 -C "$TMPDIR" 2> /sfs/9/ws/afaaj01-sorting-paper/times/odgi_layout_"$1".time
# /usr/bin/time --verbose srun -p qbic --mem=500000 -J bandage-ng -c 64 -t 10080 /usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img Bandage image hprc-v1.0-pggb.gfa hprc-v1.0-pggb.gfa.image.png 2> hprc-v1.0.bandage-ng.image.time
