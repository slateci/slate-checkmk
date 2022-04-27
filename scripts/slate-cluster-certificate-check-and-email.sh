#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks whether the certificate of a cluster is about to expire"
    echo
    echo "      $0 KUBECONF CLUSTERNAME"
    echo
    echo "Example:  $0 ~/.kube/conf mycluster"
    exit -1
fi


kubectlconfig=$1
clustername=$2

IP=$(cat $kubectlconfig 2>/dev/null | grep server | awk '{print $2}' | cut -d'/' -f3)
ENDDATE=$(timeout 5 openssl s_client -showcerts -connect "$IP" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d'=' -f2)
if [ -n "$ENDDATE" ]; then
  if [ $(date -d "$ENDDATE" +%s) -gt $(date -d "now + 60 days" +%s) ]; then
    echo 0 SLATE-cluster-$clustername-certificate - Certificate is valid and will expire in more than 60 days: $IP \($ENDDATE\)
  else
    if [ $(date -d "$ENDDATE" +%s) -gt $(date -d "now + 15 days" +%s) ]; then
      echo 1 SLATE-cluster-$clustername-certificate - Certificate is valid and will expire in less than 60 days: $IP \($ENDDATE\)
    else
      echo 2 SLATE-cluster-$clustername-certificate - Certificate is invalid or needs to be renewed: $IP \($ENDDATE\)
      EMAIL=`./get_cluster_email.sh $clustername`
      GROUPEMAIL=`../slate group list-allowed-clusters atlas-squid | grep "$clustername " > /dev/null && echo -n ", " && ./get_group_email.sh atlas-squid`
      ./mailgun.sh no-reply@slateci.io "$EMAIL$GROUPEMAIL, slateci-ops@googlegroups.com" "SLATE: Certificate expiration TEST - IGNORE" "The certificate for cluster $clustername IP $IP needs to be renewed (expiration date $ENDDATE). For help on how to renew a Kubernetes certificate, see <a href=\"https://slateci.io/docs/resources/k8s-certificates.html\">https://slateci.io/docs/resources/k8s-certificates.html</a>"
    fi
  fi
else
  echo 1 SLATE-cluster-$clustername-certificate - Endpoint/certificate was not found: IP \($ENDDATE\)
fi

