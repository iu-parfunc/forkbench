#!/bin/bash

for i in `ls reports/*/*.json`
do 
  echo $i | sed 's/[^0-9]*//g'
#  jq '.[2] | .[0] | .reportName' $i
  echo ${i##*/} | sed 's/\..*//'
  jq '.[2] | .[0] | .reportAnalysis | .anRegress | .[0] | .regCoeffs | .iters | .estPoint' $i
done > ./reports/all.txt

for i in `ls reports/01_thread/*.json` 
do
  echo ${i##*/} | sed 's/\..*//'
  grep -B 1 `echo ${i##*/} | sed 's/\..*//'` ./reports/all.txt | awk 'NR%3==1' | awk -vRS="\n" -vORS="\t" '1'
  printf "\n"
  grep -A 1 `echo ${i##*/} | sed 's/\..*//'` ./reports/all.txt | awk 'NR%3==2' | awk -vRS="\n" -vORS="\t" '1'
  printf "\n"
done > ./reports/all_4_plot.txt
