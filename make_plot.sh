#!/bin/bash

NL=`wc -l < ./reports/all_4_plot.txt`

# Plotting individual forkbench result
for (( ii=1; ii<=${NL}; ii++ ))
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
                    str=str" "1/a[i,j];
                }
                print str
            }
        }' | gnuplot -p -e "set terminal pngcairo;
            set output './reports/${PLOTNAME}.png';
            set title '${PLOTNAME}';
            set xlabel 'Num of Threads';
            set ylabel 'Spawn per Second';
            set logscale y;
            unset key;
            plot '<cat' with linespoints
            "
    fi
done

# Plotting all results in one figure
for (( ii=1; ii<=${NL}; ii++ ))
do
    if [ $((ii%3)) -eq 2 ]
    then
        sed -n "${ii}p;$((ii+1))p" < ./reports/all_4_plot.txt
    fi
done | awk ' {
        for (i=1; i<=NF; i++)  {
                a[NR,i] = $i
        }
    }
    NF>p { p = NF }
    END {
        for(j=1; j<=p; j++) {
            str=a[1,j]
            for(i=2; i<=NR; i++) {
                str=str" "a[i,j];
            }
            print str
        }
    }' | awk ' {
        printf "%d",$1;line=""
        for (i=2;i<=NF;i+=2)
            line=line (" " 1/$i)
        print line
    }' > tmp.data

for (( ii=1; ii<=${NL}; ii++ ))
do
    if [ $((ii%3)) -eq 2 ]
    then
        sed -n "$((ii-1))p" < ./reports/all_4_plot.txt
    fi
done > tmp.titles

echo "set terminal pngcairo;
set output './reports/all_plot.png';
set title 'forkbench';
set xlabel 'Num of Threads';
set ylabel 'Spawn per Second';
set logscale y;
set xrange [1:];
set key out vert;
set key reverse center right;" > tmp.plotcommand

PLOTNAME=`sed -n "1p" < tmp.titles`
echo "plot 'tmp.data' using 1:2 title '$PLOTNAME' with linespoints, \\" >> tmp.plotcommand
for (( ii=2; ii<${NL}/3; ii++ ))
do
    PLOTNAME=`sed -n "${ii}p" < tmp.titles`
    echo " 'tmp.data' using 1:$((ii+1)) title '$PLOTNAME' with linespoints, \\" >> tmp.plotcommand
done
PLOTNAME=`sed -n "$((NL/3))p" < tmp.titles`
echo " 'tmp.data' using 1:$((NL/3+1)) title '$PLOTNAME' with linespoints" >> tmp.plotcommand

gnuplot -p tmp.plotcommand

rm tmp.data tmp.plotcommand tmp.titles

