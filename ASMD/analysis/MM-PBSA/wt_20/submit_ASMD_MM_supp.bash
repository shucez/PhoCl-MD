#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-02:00:00
#SBATCH --array=14
#SBATCH --job-name=MMPBSA_wt20
#SBATCH --output=MMPBSA_wt20.out.%a
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

# on Compute Canada
module load gcc/7.3.0  cuda/9.2.148  openmpi/3.1.2 amber/18.10-18.11 scipy-stack/2019a

# on campbell.ccis.ualberta.ca
# source /home/shuce/software/Amber/amber18/amber.sh


# Only for testing
# SLURM_ARRAY_TASK_ID=$1


echo "stage is $SLURM_ARRAY_TASK_ID"


mkdir stage$SLURM_ARRAY_TASK_ID
cd stage$SLURM_ARRAY_TASK_ID

srun MMPBSA.py.MPI -O -i ../gbpb_entr_$SLURM_ARRAY_TASK_ID.in -sp ../model.parm7 -cp ../complex_wt.parm7 -rp ../barrel_wt.parm7 -lp ../peptide_wt.parm7 -y ../ASMD_prod_aligned.dcd -eo ../energy_stage$SLURM_ARRAY_TASK_ID.csv

# for testing
# MMPBSA.py -O -i ../gbpb_entr_$SLURM_ARRAY_TASK_ID.in -sp ../model.parm7 -cp ../complex_wt.parm7 -rp ../barrel_wt.parm7 -lp ../peptide_wt.parm7 -y ../ASMD_prod_aligned.dcd -eo ../energy_stage$SLURM_ARRAY_TASK_ID.csv
