#!/bin/bash

#Description: This script moves movie and subtitle files (with the mentioned extensions) to a folder created with the movie name.

echo "Enter the path > "
read path
cd $path
for file in *.avi *.mpeg *.mkv *.mp4 *.m4v *.nfo *.jpg *.jpeg; do
	if [ -e "$file" ]; then
		dir=${file%.*} 
		mkdir -p "$dir"  												 
		echo "Folder created --->$dir"
		mv "$file" "$dir"  
		echo "Moved file $file to folder $dir"
    fi
done
for file1 in *.srt *.sub; do
	if [[ -e "$file1" && $file1 == *"$dir"* ]]; then
		mv "$file1" "$dir"
		echo "Moved file $file to folder $dir"
	fi
done
