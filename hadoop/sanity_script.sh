
rm -f *.hql
rm -f *.out

clear
if [ $# -eq 0 ]; then
    echo "Please provide input parameter file in following format:"
    echo -e "\n"
    echo -e "\n"
    echo "table_name,ods"
    echo -e "\n"
    echo -e "\n"
    exit 1
fi
 echo -e "\n"
 echo -e "\n"
tablelist=$1
echo -e "-----------------------------------------------------------T1 SANITY COUNT---------------------------------------"
echo -e "\n"
read -p "Please Enter the DB Name to Perfrom Sanity Count: "  dbname
echo -e "\n"
read -p "Please Enter the SOURCE Name to Perfrom Sanity Count: " source
echo -e "\n"
while read line
do
table_name=`echo $line | awk  -F"," '{print $1}'`
ods=`echo $line | awk   -F","  '{print $2}'`

echo "set hive.execution.engine=mr;
set hivevar:tbn=$table_name;
set hivevar:dash=-------------------------------------------------------------------------------------;
select \"\${tbn}\";
select  '$table_name' as table_name ,'$ods' as ods ,  count(ods) from $dbname.$table_name where ods ='$ods' group by ods ;
select \"\${dash}\"; "  >> $source"_"$ods"."hql
done < $tablelist

echo -e "\n"
echo -e "\n"
read -p "HIVE SCRIPT IS READY, ENTER YOUR ODS: " ods
read -p "HIVE SCRIPT IS READY, PRESS Y/y For RUN HIVE SCRIPT: "  chk

case "$chk" in
    [yY][eE][sS]|[yY])
        hive -f $source"_"$ods"."hql  >> $source"_"$ods"."sanity_output.txt

        echo -e "\n" Script completed
        ;;
    *)
        echo -e "\n" Exit
        ;;
esac