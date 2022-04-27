#!/bin/bash
cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
output_url="https://jenkins.slateci.io/buildresults/"
job_list=`curl --stderr - $output_url | grep SLATE-checkmk | cut -d '>' -f 2 | cut -d '/' -f 1`
for job in $job_list; do
    ./slate-jenkins-job.sh "$output_url/$job" $job
done

