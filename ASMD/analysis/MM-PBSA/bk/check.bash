#!/bin/bash

RECORD=""

for STAGE in {1..40}
do
	if [ ! -f "energy_stage$STAGE.csv" ]; then
		echo "$STAGE doesn't exist"
		RECORD+="${STAGE},"
	fi
done

echo "$RECORD"
