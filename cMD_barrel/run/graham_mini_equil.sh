#!/bin/bash
#SBATCH --account=def-recfp2
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=PhoCl_mini_barrel
#SBATCH --output=PhoCl_mini_barrel.out
#SBATCH --mem=16000M
#SBATCH --time=0-03:00:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL


#module load gcc/5.4.0  cuda/9.0.176  openmpi/2.1.1 amber/18 scipy-stack/2019a

module load nixpkgs/16.09  gcc/7.3.0  cuda/9.2.148  openmpi/3.1.2 amber/18.10-18.11 scipy-stack/2019a
pmemd.cuda -O -i mdin/min_rest.in -p model.parm7 -c model.rst7 -ref model.rst7 -r restrt/min_rest.rst7 -o mdout/min_rest.mdout -x traj/min_rest_crd.nc
pmemd.cuda -O -i mdin/min_all.in -p model.parm7 -c restrt/min_rest.rst7 -ref restrt/min_rest.rst7 -r restrt/min_all.rst7 -o mdout/min_all.mdout -x traj/min_all_crd.nc

pmemd.cuda -O -i mdin/equil_1.mdin -p model.parm7 -c restrt/min_all.rst7 -ref restrt/min_all.rst7 -r restrt/equil_1.rst7 -o mdout/equil_1.mdout -x traj/equil_1_crd.nc
for ex in {1..5}
do
	pre=$((ex + 1))
	pmemd.cuda -O -i mdin/equil_"$pre".mdin -p model.parm7 -c restrt/equil_"$ex".rst7 -ref restrt/equil_"$ex".rst7 -r restrt/equil_"$pre".rst7 -o mdout/equil_"$pre".mdout -x traj/equil_"$pre"_crd.nc
done



# you may proceed to another run if the previous run is not sufficient

#pmemd.cuda.MPI -O -i production.in -p model.parm7 -c production_1.rst7 -ref production_1.rst7 -r production_2.rst7 -o production_2.mdout -x production_crd_2.nc

