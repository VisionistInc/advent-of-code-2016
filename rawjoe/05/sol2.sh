#!/bin/bash

INPUT=ojvtpuvg

COUNTER=0
INDEX=0

ARRAY=(0 0 0 0 0 0 0 0)

until [ $COUNTER -eq 8 ]; do
    STR=$(echo -n $INPUT$INDEX | md5sum)
    if [[ $STR == 00000* ]]; then
        let i=${STR:5:1}
        if [[ $i -lt ${#ARRAY[@]} ]]; then
            if [[ ${ARRAY[$i]} == 0 ]]; then
                echo $INDEX gives $STR
                ARRAY[$i]=${STR:6:1}
                let COUNTER+=1
                echo ${ARRAY[@]}
            fi
        fi
    fi
    let INDEX+=1
done
