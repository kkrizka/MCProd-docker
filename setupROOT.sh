roots=$(dirname ${BASH_SOURCE[0]})

if [ ${#} == 0 ]; then
    rootver=$(ls ${roots} | tail -1)
else
    rootver=${roots}/${1}
fi

source ${rootver}/bin/thisroot.sh
