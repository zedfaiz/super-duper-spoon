#drop partitions
for i in `cat /home/griddev/EBBS_IN_Tables.txt`
do
table=$i
hive -e "alter table ${table} drop partition (ods = '2017_06_30');"
done


#export
#!/bin/bash
tables=hive -e "use stdfdev;show tables;"
for table in tables
do
partition=hive -e "show partitions $table"

hive -e "export $table PARTITION (reporting_date="2017-05-11") to "hdfs://nnscbhaasdev/tmp/ilrrappdev";"
done


#load data from hdfs
function delete_hdfs(){
	now=$(date +%s)
	hadoop fs -ls /tmp/data/ | while read f; do
	dir_date=`echo $f | awk '{print $6}'`
	echo $f
	difference=$(( ( $now - $(date -d "$dir_date" +%s) ) / ( 60 * 60 ) ))
	if [ $difference -gt 1 ]; then
		hadoop fs -ls `echo $f| awk '{ print $8 }'`;
	fi
done  
}