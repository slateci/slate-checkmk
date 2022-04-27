#!/bin/bash
cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
./for-all.sh ../kconf_extraction/configs ./slate-cluster-certificate-check-and-email.sh
