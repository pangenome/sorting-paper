#!/bin/bash

singularity exec /nfsmounts/container/pg-sgd.img odgi layout -i /sfs/9/ws/afaaj01-sorting-paper/extracts/$1 -o /sfs/9/ws/afaaj01-sorting-paper/layouts/$1.lay -t 64 -C "$TMPDIR" -P
