#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=PhoCl_prod_310_$2
#SBATCH --output=PhoCl_prod_310_$2.out
#SBATCH --mem=16000M
#SBATCH --time=0-06:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a
pmemd.cuda -O -i mdin/prod.mdin -p model.parm7 -c restrt/prod_$1.rst7 -ref restrt/prod_$1.rst7 -r restrt/prod_$2.rst7 -o mdout/prod_$2.mdout -x traj/prod_$2_crd.nc

