#!/bin/bash

# wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/pggb/hprc-v1.0-pggb.gfa.gz
# gunzip hprc-v1.0-pggb.gfa.gz
XDG_RUNTIME_DIR=$TMPDIR
/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img BandageNG layout hprc-v1.0-pggb.gfa hprc-v1.0-pggb.gfa.layout 2> hprc-v1.0.bandage-ng.layout.time
# /usr/bin/time --verbose srun -p qbic --mem=500000 -J bandage-ng -c 64 -t 10080 /usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img Bandage image hprc-v1.0-pggb.gfa hprc-v1.0-pggb.gfa.image.png 2> hprc-v1.0.bandage-ng.image.time
