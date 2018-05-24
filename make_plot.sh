#!/bin/bash

NL=`wc -l < ./reports/all_4_plot.txt`

for ii in $( eval echo {1..$NL} )
do
    if [ $((ii%3)) -eq 2 ]
    then
        PLOTNAME=`sed -n "$((ii-1))p" < ./reports/all_4_plot.txt`
        sed -n "${ii}p;$((ii+1))p" < ./reports/all_4_plot.txt | awk '
        {
            for (i=1; i<=NF; i++)  {
                a[NR,i] = $i
            }
        }
        NF>p { p = NF }
        END {
            for(j=1; j<=p; j++) {
                str=a[1,j]
                for(i=2; i<=NR; i++){
                    str=str" "a[i,j];
                }
                print str
            }
        }' | gnuplot -p -e "set terminal pngcairo;
            set output './reports/${PLOTNAME}.png';
            set title '${PLOTNAME}';
            set xlabel 'Num of Threads';
            set ylabel 'Time (s)';
            unset key;
            plot '<cat' with points
            "
    fi
done
