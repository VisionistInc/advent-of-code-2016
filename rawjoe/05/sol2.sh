#!/bin/bash

if [ $# -eq 1 ]; then
    INPUT=$1
else
    INPUT=ojvtpuvg
    echo Used default input
fi

echo Using $INPUT as input

INDEX=0

ARRAY=(z z z z z z z z)

until ! [[ ${ARRAY[*]} == *"z"* ]]; do
    STR=$(echo -n $INPUT$INDEX | md5sum)
    if [[ $STR == 00000* ]]; then
        i=${STR:5:1}
        if [[ $i < ${#ARRAY[@]} ]]; then
            if [[ ${ARRAY[$i]} == "z" ]]; then
                echo $INDEX gives $STR
                ARRAY[$i]=${STR:6:1}
                echo ${ARRAY[@]}
            fi
        fi
    fi
    let INDEX+=1
done
