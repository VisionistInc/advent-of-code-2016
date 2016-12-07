#!/bin/bash

INPUT=ojvtpuvg

COUNTER=0
INDEX=0

ARRAY=(0 0 0 0 0 0 0 0)

until [ $COUNTER -eq 8 ]; do
    STR=$(echo -n $INPUT$INDEX | md5sum)
    if [[ $STR == 00000* ]]; then
        ARRAY[$COUNTER]=${STR:5:1}
        let COUNTER+=1
    fi
    let INDEX+=1
done

echo ${ARRAY[@]}
