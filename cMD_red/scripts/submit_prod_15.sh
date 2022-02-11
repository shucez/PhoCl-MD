#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=PhoCl_prod_310_15
#SBATCH --output=PhoCl_prod_310_15.out
#SBATCH --mem=16000M
#SBATCH --time=0-06:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a
pmemd.cuda -O -i mdin/prod.mdin -p model.parm7 -c restrt/prod_14.rst7 -ref restrt/prod_14.rst7 -r restrt/prod_15.rst7 -o mdout/prod_15.mdout -x traj/prod_15_crd.nc

