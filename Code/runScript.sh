startRepl=1
endRepl=7
option1=1
option2=2
option3=3


filehead=fluraMeta3a_0_0
filehead1=seg1_fluraMeta3a_0_0
filehead2=seg2_fluraMeta3a_0_0

# 1. Sequence files
python trans_io.py $filehead $startRepl $endRepl
python pick_6mon_30_io.py $filehead $startRepl $endRepl
python separate_io.py $filehead $startRepl $endRepl

rm *fasta


# 2. Calculate metrics
R CMD BATCH Calculate_Fst.R
R CMD BATCH TCMD.R


rm *fas
rm *fasta

