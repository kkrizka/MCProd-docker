#!/bin/bash

if [  ${#} != 1 ]; then
    echo "usage: ${0} model"
    exit 1
fi

model=${1}

modelfile=$(basename ${model})

wget ${model}

for mg5path in /opt/MG5aMC/*
do
    tar -xvf ${modelfile} -C ${mg5path}/models/
    modelpath=$(ls -td ${mg5path}/models/* | tail -1)
    echo "convert model ${modelpath}" | ${mg5path}/bin/mg5_aMC
done

rm ${modelfile}

