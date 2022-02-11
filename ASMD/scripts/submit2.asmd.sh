#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10000M
#SBATCH --time=0-01:00:00
#SBATCH --array=1-100
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a

STAGE=$1
echo "stage is $STAGE"
EX=`expr $STAGE - 1`
echo "EX is $EX"
JA=`perl scripts/JA.pl $EX scripts/submit.asmd.sh`
echo "JA is $JA"

pmemd.cuda -O -i mdin/asmd.mdin."$STAGE"."$SLURM_ARRAY_TASK_ID" -p model.parm7 -c rst/asmd.rst7."$EX"."$JA" -r rst/asmd.rst7."$STAGE"."$SLURM_ARRAY_TASK_ID" -o mdout/ASMD.mdout."$STAGE"."$SLURM_ARRAY_TASK_ID" -x traj/ASMD_crd.nc."$STAGE"."$SLURM_ARRAY_TASK_ID"
