#!/bin/bash
perl scripts/edit_RST.pl 12.7623 40 rests/dist.RST
perl scripts/edit_mdin.pl 100 40 mdin/asmd.mdin

jidold=$(sbatch --parsable ./scripts/submit.asmd.sh.1)
for pre in {2..40}
do
	        jidnew=$(sbatch --parsable  --dependency=afterany:$jidold ./scripts/submit2.asmd.sh "$pre")
		jidold=$jidnew
done

