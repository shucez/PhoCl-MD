#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=Barrel_prod_1
#SBATCH --output=Barrel_prod_1.out
#SBATCH --mem=16000M
#SBATCH --time=0-06:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

#module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a
module load nixpkgs/16.09  gcc/7.3.0  cuda/9.2.148  openmpi/3.1.2 amber/18.10-18.11 scipy-stack/2019a
pmemd.cuda -O -i mdin/prod.mdin -p model.parm7 -c restrt/equil_6.rst7 -ref restrt/equil_6.rst7 -r restrt/prod_1.rst7 -o mdout/prod_1.mdout -x traj/prod_1_crd.nc

