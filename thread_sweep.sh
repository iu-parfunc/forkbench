#!/bin/bash

JOB=$1

MAX=$(cat /proc/cpuinfo | grep name | wc -l)

for i in $(seq -f "%02g" 1 $MAX);
do
    echo
    echo Running with THREADS=$i;
    echo ============================================================
    time make $JOB THREADS=$i
done
