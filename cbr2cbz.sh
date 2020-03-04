#!/bin/bash

echo $'CBR to CBZ converter \n'

# dep : p7zip p7zip-rar

# temp files will be created in memory
temp_dir="/tmp"
temp_files="$temp_dir/tmp_files"

usage="Usage: $(basename $0) [source] [target] 

	script to convert .cbr comic book files to .cbz

where:
    source:	path to directory of CBR files to convert
		Default is current working directory

    target: 	path to directory to save converted CBZ files
		Default is ./cbr-files
    "

check_dir()
{
	if [ $1 -ne 0 ]; then
		echo "$2 directory does not exist."
		exit;
	fi
}

# if custom path to cbr files is given
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "$usage"
	exit;
fi

if [ -z $1 ]; then
	source_dir=$(pwd)
	output_dir="$source_dir/cbr-files"
	mkdir $output_dir

else
	source_dir=$(readlink -e "$1") # absolute path of directory
	check_dir $? $1

	if [ -z $2 ]; then
		output_dir="$source_dir/cbr-files"
		mkdir $output_dir
	else
		output_dir=$(readlink -e "$2")
		check_dir $? $2
	fi
fi

# echo $source_dir $output_dir

if [ ! -d $temp_files ]; then
	mkdir $temp_files
fi

cd $temp_files


for file in "$source_dir"/*.cbr; do
	[ -e "$file" ] || continue


	file_name=$(basename "$file" .cbr) 
	echo "Extracting $file_name ..."

	7z e "$file" -o"$file_name" && cd "$file_name"
	echo $(pwd)
	echo "Converting to cbz ..."
	
	7z a -tzip -mx=0 "$output_dir/$file_name.cbz"
	cd .. && rm -rf $file_name
done


cd "$output_dir"

# Remove temporary files
rm -rf "$temp_files"