#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks the status of metallb on a kubernetes cluster"
    echo
    echo "      $0 KUBECONF CLUSTERNAME"
    echo
    echo "Example:  $0 ~/.kube/conf mycluster"
    exit -1
fi


kubectlconfig=$1
clustername=$2

daemonset=`kubectl --kubeconfig $kubectlconfig get ds --namespace metallb-system | grep speaker`
if [ -z "$daemonset" ]; then
    echo 2 SLATE-metallb-$clustername-speaker - Speaker daemonset not found
else
    if [[ $daemonset =~ [^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+ ]]; then
        if [[ ${BASH_REMATCH[1]} == ${BASH_REMATCH[2]} && ${BASH_REMATCH[1]} == ${BASH_REMATCH[3]} && ${BASH_REMATCH[1]} == ${BASH_REMATCH[4]} && ${BASH_REMATCH[1]} == ${BASH_REMATCH[5]} ]]; then
            echo "0 SLATE-metallb-$clustername-speaker - All speakers up ($daemonset)"
        else
            echo "2 SLATE-metallb-$clustername-speaker - Not all speakers up ($daemonset)"
        fi
    else
        echo "2 SLATE-metallb-$clustername-speaker - Speaker daemonset response does not match expected output ($daemonset)"
    fi
fi

controller=`kubectl --kubeconfig $kubectlconfig get pods --namespace metallb-system | grep controller`
if [ -z "$daemonset" ]; then
    echo 2 SLATE-metallb-$clustername-controller - Controller pod not found
else
    if [[ $controller =~ .+Running.+ ]]; then
        echo "0 SLATE-metallb-$clustername-controller - Controller pod running ($controller)"
    else
        echo "2 SLATE-metallb-$clustername-controller - Controller pod not running ($controller)"
    fi
fi
