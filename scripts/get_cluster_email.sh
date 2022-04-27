#!/bin/bash

CLUSTER_NAME=$1
GROUP_NAME=`../slate cluster info $CLUSTER_NAME | grep $CLUSTER_NAME | cut -d ' ' -f 2`
if [ -z "$GROUP_NAME" ];
then
   exit 1
fi

EMAIL=`../slate group info $GROUP_NAME | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b"`

echo $EMAIL
