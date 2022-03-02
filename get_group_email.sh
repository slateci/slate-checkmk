#!/bin/bash

GROUP_NAME=$1

EMAIL=`../slate group info $GROUP_NAME | grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b"`

echo $EMAIL
