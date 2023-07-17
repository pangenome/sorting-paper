#!/bin/bash

/usr/bin/time --verbose singularity exec /nfsmounts/container/pg-sgd.img odgi layout -i /sfs/9/ws/afaaj01-sorting-paper/graphs/chr"$1".hprc-v1.0-pggb.gfa -o /sfs/9/ws/afaaj01-sorting-paper/layouts/chr"$1".hprc-v1.0-pggb.gfa.lay -t 64 -C "$TMPDIR" 2> /sfs/9/ws/afaaj01-sorting-paper/times/odgi_layout_"$1".time
