lhapdfs=$(dirname ${BASH_SOURCE[0]})

if [ ${#} == 0 ]; then
    lhapdfver=$(ls ${lhapdfs} | tail -1)
else
    lhapdfver=${lhapdfs}/${1}
fi

export PATH=${lhapdfver}/bin:${PATH}
export LD_LIBRARY_PATH=${lhapdfver}/lib:${LD_LIBRARY_PATH}
export PYTHONPATH=${lhapdfver}/lib64/python3.8/site-packages:${PYTHONPATH}
