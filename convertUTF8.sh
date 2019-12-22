#!/bin/sh
#convert any file to UTF-8
########### INI VARS ########################
REC_CONVERT=0
CONVERT_PATH="."
SILENT=0
##### ARGS TREATMENT ########################

if [[  $# > 3 ]]; then
echo "Illegal number of parameters !"
exit -1
elif [[ $@ > 0 ]]; then
CONVERT_PATH=${@: -1}
fi
echo $CONVERT_PATH

for var in "$@"
do
if [[ $var == "-r" ]]; then
REC_CONVERT=1
fi

if [[ $var == "-s" ]]; then
SILENT=1
fi

done

########## MAIN ALGO ########################
if [[ $SILENT != 1 ]]; then
clear
read -p "WARNING THIS WILL CONVERT ANY FILES IN THE DIRECTORY TO UTF-8 ! PATH = $CONVERT_PATH"
fi
for file in $CONVERT_PATH/*
do
if [[ $0 =~ $file ]]; then
:
elif [[ -d $file ]]; then
  if [[ $REC_CONVERT == 1 ]]; then
	echo "DIRECTORY"
    	./convertUTF8.sh -r -s $file > /dev/stdout
  fi
else
echo $file
convertType=`file -i "$file" | grep -Po "(?<=charset=)[^\s]+"`
if [[ $convertType != "binary" ]];then
iconv -f "$convertType" -t "UTF-8" "$file" > "$file.new"
sed -i '1s/^\xEF\xBB\xBF//' "$file.new"
mv -f "$file.new" "$file"
fi
fi
done

echo "Files successfully converted"
