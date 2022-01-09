rivets=$(dirname ${BASH_SOURCE[0]})

if [ ${#} == 0 ]; then
    rivetver=$(ls ${rivets} | tail -1)
else
    rivetver=${rivets}/${1}
fi

source ${rivetver}/rivetenv.sh
