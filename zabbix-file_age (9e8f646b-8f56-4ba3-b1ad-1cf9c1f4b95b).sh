
#! /bin/bash
# script that counts number of file older then x minutes ( defualt 5 min)
# first argument is full path to directory   - mandatory
#seconf argument -  suffix name can be left empty if third argument is empty. Or excpets "None" to get all the  files.
# third argument  - number of minutes  - if omitted  then it's set to 5 min.
# examples:
#  ./zabbix-file_age.sh /var/tmp/ jpu_temp 5  --> count  all the files in /var/tmp  that end with .jpu_temp and  older than 5 min.
#  ./zabbix-file_age.sh /var/tmp -->  count  all the files in /var/tmp.
#  ./zabbix-file_age.sh /var/tmp None 10 -->   count  all the files in /var/tmp that are older than 10 min.


# on billing server need to be under /usr/local/bin/ with excecutable permissions.



NOW=`date +%s`

dir_name=$1
suffix=$2
default=5


#check if folder exist
if [ ! -d "$dir_name" ]; then
	echo "folder does not exist"
	exit 20
fi


#set time limit
if [ -n "$3" ];then
   limit=$3
else
   limit=$default
fi

#check if suffix is set.
if [ -n "$2" ];then
	suffix=$2
else
	suffix="None"
fi




#get file age in minutes:
function get_age()
{
	file_fname=$1.
#	if [[ $file_fname == *.$suffix ]];then
		OLD=`stat -c %Z $1`
        	(( DIFF = (NOW - OLD)/60 ))
		if [ "$DIFF" -ge "$limit" ]; then

       		        return 1
		else
			return 0
		fi

#	fi
}
#check the file's suffix.
function check_suffix()
{

	suffix=$1
        if [[ $2  == *.$suffix ]]; then
		 true
	else
		 false
	fi

}






count=0
cd $dir_name
for i in `ls`
	do
	if [[ $suffix != "None" ]];then
		type=$(check_suffix $suffix $i;echo $?)
		if [[  $type == 0  ]]; then
			get_age $i; result=$?
			if [ "$result" -eq "1" ]; then
			((count++))
			fi
		fi
	elif  [[ $suffix == "None" ]];then
		        get_age $i; result=$?
            if [ "$result" -eq "1" ]; then
            ((count++))
			fi
	fi
done
echo $count
