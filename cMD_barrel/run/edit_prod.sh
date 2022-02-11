#!/bin/bash
for ex in {1..20}
do
	pre=$((ex + 1))
	cp submit_prod_0.sh ./scripts/submit_prod_"$pre".sh 
	sed -i "s/\$1/$ex/g" ./scripts/submit_prod_"$pre".sh
	sed -i "s/\$2/$pre/g" ./scripts/submit_prod_"$pre".sh
done

