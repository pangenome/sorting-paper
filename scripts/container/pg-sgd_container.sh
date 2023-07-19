#!/bin/bash

docker build -t ${USER}/pg-sgd:latest .
docker run -d -p 5000:5000 --name registry registry:2
docker image tag $(docker images | grep pg-sgd | grep latest | grep ${USER} | tr -s ' ' | cut -f 3 -d ' ') localhost:5000/pg-sgd
docker push localhost:5000/pg-sgd
SINGULARITY_NOHTTPS=true singularity build --force pg-sgd.img docker://localhost:5000/pg-sgd
docker container stop registry && docker container rm -v registry
