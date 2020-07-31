# Metapopulation-dynamics

This is the pipeline for the study of metapopulation dynamics.

1. Simulation code

compile command: 
gcc -g FluRaMeta3a.c -o fluraMeta3a_ -lm

2. Run simulation

(1) run.sh
Shell script to run simulation is /run.sh 

(2) write_pinp.py
The shell script first write input file by running "write_pinp.py".
In neutral model, nNonsy is fixed to 0.
In positive selection and metapopulation model, nNonsy is the same as the number of epitope.

(3) command to run simulation
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

























