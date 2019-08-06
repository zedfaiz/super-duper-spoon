
clear
echo -e "\n"
echo -e "\n"
echo -e "\n"

echo -e "\t--------------------------------------MASKING VALIDATION SCRIPT--------------------------------"

echo -e "\n"
echo -e "\n"
echo -e "\n"



if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "Please provide following two parameter file: \n
                1) Masking_information : table_name,column_name,mask_value \n
                2) Beeline script sql file"
        echo -e "\n"
        echo -e "\n"
        echo -e "\n"
  exit 1
fi


mask_parameter_file=$1
sql_query=$2



while read line
do
mask_tbl_name=`echo $line | awk -F","  '{print $1}'`
mask_col_name=`echo $line | awk -F","  '{print $2}'`
rep_col_name=`echo $line  | awk -F","  '{print $3}'`
echo $mask_tbl_name
sed -i -e "s/\<$mask_col_name\>/$rep_col_name as $mask_col_name/g" $sql_query
done < $mask_parameter_file