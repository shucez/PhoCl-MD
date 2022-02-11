#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=ASMD_stage1
#SBATCH --output=ASMD_stage1.out
#SBATCH --mem=10000M
#SBATCH --time=0-01:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a

pmemd.cuda -O -i mdin/asmd.mdin.1.1 -p model.parm7 -c rst/prod_21.rst7 -r rst/asmd.rst7.1.1 -o mdout/ASMD.mdout.1.1 -x traj/ASMD_crd.nc.1.1
