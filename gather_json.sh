#!/bin/bash

for i in `ls reports/*/*.json`
do 
  echo $i | sed 's/[^0-9]*//g'
  jq '.[2] | .[0] | .reportName' $i
  jq '.[2] | .[0] | .reportAnalysis | .anRegress | .[0] | .regCoeffs | .iters | .estPoint' $i 
done
