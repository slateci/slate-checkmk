#!/bin/bash
source /etc/slate/slate.conf
export mailgunKey
./mailgun.py "$@"
