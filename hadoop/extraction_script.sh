
clear

echo -e "\n"
echo -e "\n"

echo -e "\t------------------------------------------------T1 DATA DOWNLOAD SCRIPT----------------------------------------------"

echo -e "\n"
echo -e "\n"


if [ $# -eq 0 ]; then
    echo "Please provide input parameter file in following format:"
    echo -e "\n"
    echo "prd_database_name,table_name,ods"
    echo -e "\n"
    echo -e "\n"
    exit 1
fi

echo -e "\n"
echo -e "\n"


input_file=$1


while read line

do

DB_NAME=`echo $line  | awk -F"," '{print $1}'`
TABLE_NAME=`echo $line | awk -F"," '{print $2}'`
ODS=`echo $line | awk -F"," '{print $3}'`


txt_file=${TABLE_NAME}_${ODS}.txt


echo "Executing the hive query - starts"
hive -hiveconf num=$TABLE_NAME -e 'describe griddev.${hiveconf:num};' >> DDL_$TABLE_NAME
cat  DDL_$TABLE_NAME | awk '{print $1}' | sed '/ods/q' |  tr -s '[\n]' ',' | sed  '1i select  ' | tr -s '[\n]' ' '  | sed 's/.$//'  | sed "s/$/  from ${DB_NAME}.${TABLE_NAME}  where ods = '$ODS' ;/" | sed  '1s|^|beeline -u jdbc:hive2://localhost:10000/ -n <userid> -p <password> --outputformat=dsv --delimiterfordsv=$xxx --incremental=true  -e " | ' | sed "s/$/\" > $txt_file /"  >> out.txt

rm -f DDL_$TABLE_NAME

sed -i -e "s/xxx/\'\\\001\'/g" out.txt

echo -e " "  >> out.txt

done < $input_file