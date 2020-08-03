# Metapopulation dynamics

This is the pipeline for the study of metapopulation dynamics. This program simulate viral sequences that are generated under the evolutionary conditions of seasonal influenza viruses. This model have been developed by Kim and Kim (2016) and allow viral sequences to evolve under genetic drift, migration, and positive selection. 


## 1. Building the simulation code

This program is intended to be built and run in Linux. We used gcc to compile and build the program.

```
gcc -g FluRaMeta3a.c -o fluraMeta3a_ -lm
```

## 2. Running the simulation

The shell script to run simulation is: 
```
./run.sh 
```

### (1) write parameters in run.sh
In this file, you have to specify the number of epitope (i), the maximum carrying capacities (Kmax, j) and the rearrangement rate (k).

### (2) write input file write_pinp.py
The shell script first write input file by running "write_pinp.py" which specify the model and parameters for simulations and write the input file "_.inp".
In neutral model, nNonsy (Number of non-synonymous site) is fixed to 0 and sel_co (coefficient of selection) is also equal 0.
In metapopulation model, nNonsy is the same as the number of epitope and sel_co has to be specify.
In both model, r_mig (rate of migation) has also to be specify.

#### Example of input file

```
nNonsy 10
nSynon 1690
Ndeme 8
Kmax 2500
DinY 80
Tburn 40000
Tsample 80000
r_mut 0.0001
r_mig
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
SamInt 8
Nsamp 5
dWin 10
vdisp 1
Ntry 1
seed 571917
bottleneckSize 0
doRecomb 0
numEpitope 11
sel_co 0.1
reduced_u 3
sel_d 0.0
```

### (3) command to run simulation
Then as written in the shell script, the command to run simulation is:
simulation_program input_file output_file(sequence output) seed > text_file_for_more_information

Running simulation once as above command generates 50 replicates. 
The command is run 6 times to generate 300 replicates.

3. Generate sequence files from simulation output

Using /runScript.sh run below python scripts

trans_io.py
pick_6mon_30_io.py
separate_io.py


4. Calculate metrics

Calulate time -corrected pi and Fst with /Calculate_Fst.R
Draw the Time Corrected Mismatch distribution with /TCMD.R

























