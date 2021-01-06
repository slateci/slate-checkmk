#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks the result of a SLATE Jenkins job"
    echo
    echo "      $0 OUTPUT_URL JOB_NAME"
    echo
    echo "Example:  $0 https://jenkins.slateci.io/buildresults/SLATE-checkmk-test SLATE-checkmk-test"
    exit -1
fi

output_url=$1
job_name=$2
output=`curl --stderr - $output_url/latest-log.txt`
status=`echo "$output" | grep "^CHECKMK state" | tail -1 | cut -d ' ' -f 3`
message=`echo "$output" | grep "^CHECKMK output" | tail -1 | cut -d ' ' -f 3-`
echo $status $job_name - $message



#getnodes=`timeout 5 kubectl --kubeconfig $kubectlconfig get nodes 2>&1`
#if [ $? -eq 0 ]; then
#    echo "0 SLATE-cluster-$clustername-available - Cluster responding"
#else
#    echo "2 SLATE-cluster-$clustername-available - Cluster not responding ($getnodes)"    
#fi
