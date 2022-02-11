#!/bin/bash
jidold=$(sbatch --parsable graham_mini_equil.sh)
#jidold=$(sbatch --parsable scripts/submit_prod_1.sh)
for pre in {1..21}
do
	jidnew=$(sbatch --parsable  --dependency=afterany:$jidold ./scripts/submit_prod_"$pre".sh)
	jidold=$jidnew
done

