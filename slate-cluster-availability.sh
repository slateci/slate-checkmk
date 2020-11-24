#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks the availability of a kubernetes cluster"
    echo
    echo "      $0 KUBECONF CLUSTERNAME"
    echo
    echo "Example:  $0 ~/.kube/conf mycluster"
    exit -1
fi


kubectlconfig=$1
clustername=$2

getnodes=`timeout 5 kubectl --kubeconfig $kubectlconfig get nodes 2>&1`
if [ $? -eq 0 ]; then
    echo "0 SLATE-cluster-$clustername-available - Cluster responding"
else
    echo "2 SLATE-cluster-$clustername-available - Cluster not responding ($getnodes)"    
fi
