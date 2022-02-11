#!/bin/bash
echo "deleting old files"
rm *b*.csv

STAGE=1
perl extract_MM_csv.pl energy_stage$STAGE.csv
cat pbcom$STAGE.csv >> pbcom_all.csv
cat pbrec$STAGE.csv >> pbrec_all.csv
cat pblig$STAGE.csv >> pblig_all.csv
cat pbdel$STAGE.csv >> pbdel_all.csv
cat gbcom$STAGE.csv >> gbcom_all.csv
cat gbrec$STAGE.csv >> gbrec_all.csv
cat gblig$STAGE.csv >> gblig_all.csv
cat gbdel$STAGE.csv >> gbdel_all.csv

for STAGE in {2..40}
do
	perl extract_MM_csv.pl energy_stage$STAGE.csv
	tail -n +2 pbcom$STAGE.csv >> pbcom_all.csv
	tail -n +2 pbrec$STAGE.csv >> pbrec_all.csv
	tail -n +2 pblig$STAGE.csv >> pblig_all.csv
	tail -n +2 pbdel$STAGE.csv >> pbdel_all.csv
	tail -n +2 gbcom$STAGE.csv >> gbcom_all.csv
	tail -n +2 gbrec$STAGE.csv >> gbrec_all.csv
	tail -n +2 gblig$STAGE.csv >> gblig_all.csv
	tail -n +2 gbdel$STAGE.csv >> gbdel_all.csv

done
