#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --ntasks=6
#SBATCH --job-name=PhoCl_mini_barrel
#SBATCH --output=PhoCl_mini_barrel.out
#SBATCH --mem-per-cpu=5000M
#SBATCH --time=0-06:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL


#module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a

#module load nixpkgs/16.09  gcc/7.3.0  cuda/9.2.148  openmpi/3.1.2 amber/18.10-18.11 scipy-stack/2019a

module load nixpkgs/16.09  gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a

srun pmemd.MPI -O -i mdin/min_rest.in -p model.parm7 -c model.rst7 -ref model.rst7 -r restrt/min_rest.rst7 -o mdout/min_rest.mdout -x traj/min_rest_crd.nc
srun pmemd.MPI -O -i mdin/min_all.in -p model.parm7 -c restrt/min_rest.rst7 -ref restrt/min_rest.rst7 -r restrt/min_all.rst7 -o mdout/min_all.mdout -x traj/min_all_crd.nc

