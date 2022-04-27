#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks the status of the NRP controller on a kubernetes cluster"
    echo
    echo "      $0 KUBECONF CLUSTERNAME"
    echo
    echo "Example:  $0 ~/.kube/conf mycluster"
    exit -1
fi


kubectlconfig=$1
clustername=$2

pod=`kubectl --kubeconfig $kubectlconfig get pods --namespace kube-system | grep nrp-controller`
if [ -z "$pod" ]; then
    echo 2 SLATE-nrp-$clustername - NRP controller not found
else
    if [[ $pod =~ [^0-9]+([0-9]+)/([0-9]+)[^0-9]+ ]]; then
        if [[ ${BASH_REMATCH[1]} == ${BASH_REMATCH[2]} ]]; then
            echo "0 SLATE-nrp-$clustername - NRP controller up ($pod)"
        else
            echo "2 SLATE-nrp-$clustername - NRP controller down ($pod)"
        fi
    else
        echo "2 SLATE-nrp-$clustername - NRP controller response does not match expected output ($pod)"
    fi
fi
