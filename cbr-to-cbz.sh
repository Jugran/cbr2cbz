#!/bin/bash

echo "CBR to CBZ converter"

# temp files will be created in memory
temp_dir="/dev/shm"
temp_files="$temp_dir/tmp_files"

if [ ! -d $temp_files ]; then
	mkdir $temp_files
fi

# if custom path to cbr files is given
if [ -z $1 ]
then
	source_dir=$(pwd)
	output_dir="$source_dir"
else
	source_dir=$(readlink -e "$1") # absolute path of directory
	output_dir=$(pwd)
fi


cd $temp_files


for file in "$source_dir"/*.cbr; do
	[ -e "$file" ] || continue

	file_name=$(basename "$file" .cbr) 
	echo "Extracting $file_name ..."

	7z e "$file" -o"$file_name" && cd "$file_name"
	echo $(pwd)
	echo "Converting to cbz ..."
	
	7z a -tzip -mx=0 "$output_dir/cbz-files/$file_name.cbz"
	cd .. && rm -rf $file_name
done


cd "$output_dir"

# Remove temporary files
rm -rf "$temp_files"
