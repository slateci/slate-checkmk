#!/bin/bash
cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
./for-all.sh conf ./slate-nrp-check.sh
