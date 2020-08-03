#!/bin/bash

one=1
two=2
three=3
four=4
five=5
six=6
u=_
progname=fluraMeta3a_

stepi=1
stepj=100
stepk=100

i=20 #i is numepi
while [ $i -le 20 ];
do
j=250 #j is Kmax

while [ $j -le 250 ];
do
k=0 #k is RA

while [ $k -le 0 ];
do
echo $j
echo $k
python write_pinp.py $progname $i $j $k
./$progname $progname$j$u$k.inp $progname$j$u$k$u$one.out 133234 > $progname$j$u$k$u$one.txt
./$progname $progname$j$u$k.inp $progname$j$u$k$u$two.out 2323234 > $progname$j$u$k$u$two.txt
./$progname $progname$j$u$k.inp $progname$j$u$k$u$three.out 307506 > $progname$j$u$k$u$three.txt
./$progname $progname$j$u$k.inp $progname$j$u$k$u$four.out 425410 > $progname$j$u$k$u$four.txt
./$progname $progname$j$u$k.inp $progname$j$u$k$u$five.out 554241 > $progname$j$u$k$u$five.txt
./$progname $progname$j$u$k.inp $progname$j$u$k$u$six.out 628043 > $progname$j$u$k$u$six.txt


k=`expr $k + $stepk`
done
j=`expr $j + $stepj`
done
i=`expr $i + $stepi`
done
exit
