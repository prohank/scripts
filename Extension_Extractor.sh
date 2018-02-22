#!/bin/bash

#Description: This Script shows the extensions of files within a specified folder and all nested folders.
#Disclaimer: This Script doesn't guarantee that the extension is a filetype for e.g. file 'abc.txt' will show extension as 'txt' 
#            but files 'abcd.abc' and 'abc' will show extensions as 'abc' even though they are not valid filetypes.

exit_on_signal_SIGINT () {
echo "Script interrupted." 2>&1
exit 0
}
exit_on_signal_SIGTERM () {
echo "Script terminated." 2>&1
exit 0
}
trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

echo "Enter the path > "
read path
cd $path
files=$(find -type f -printf "%f\n")
IFS=$'\n'
allext=""
abc=$(for i in $files; do
	ext=${i##*.}
	echo "$allext$ext "
done)
echo $'\n'
echo $"Total files: $(echo "$abc" | wc -l)"
echo $'\n'
echo "Note:
echo "The Types of files are:"
ext=$(echo "$abc" | grep -v "~" | sort | uniq -ic)
echo "$ext"
