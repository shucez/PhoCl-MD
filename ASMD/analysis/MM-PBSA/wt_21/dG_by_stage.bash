#!/bin/bash

# on Compute Canada
module load gcc/7.3.0  cuda/9.2.148  openmpi/3.1.2 amber/18.10-18.11 scipy-stack/2019a

# on campbell.ccis.ualberta.ca
# source /home/shuce/software/Amber/amber18/amber.sh

# generate the topology files
echo "Generating topology files"
ante-MMPBSA.py -s :WAT,Cl*,CIO,Cs+,IB,K*,Li+,MG*,Na+,Rb+,CS,RB,NA,F,CL -p model.parm7 -n :232-240 -c complex_wt.parm7 -r barrel_wt.parm7 -l peptide_wt.parm7 

start_frame=1
end_frame=500
incrememt=500

echo "Generating input files"
for stage in {1..40}
do
	echo $stage
	cp temp_gbpb.in gbpb_entr_$stage.in
	sed -i "s/\$START/$start_frame/g" gbpb_entr_$stage.in
	sed -i "s/\$END/$end_frame/g" gbpb_entr_$stage.in
	let "start_frame += 500"
	let "end_frame += 500"
done


