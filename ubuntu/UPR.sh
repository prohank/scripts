#!/bin/bash -e

# Description: UPR is Ubuntu Playlist Regenerator. This script reads a playlist and checks whether the music files in it exist or not.
# If the music file is not found at the original position then it will be searched and if found the corresponding address will be modified in the new playlist.
# A new playlist will be generated named "sample_changed.m3u" within the directory of the "sample" playlist itself. 
#Limitations:
#1.Works only on m3u playlists created in Ubuntu
#2.Script fails if name of missing music file is changed

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

sleep 1
echo $"................................................................................"
echo -e "\nRead the Description before continuing and make sure that all the necessary drives are mounted and others are unmounted. Do that first and then return.\n"
echo $"................................................................................"
read -p "Press Enter to continue."
mkdir /home/"$USER"/tmp 2> /dev/null
#Creating temporary file
touch /home/"$USER"/tmp/$(basename $0).$$
tmpfile=/home/"$USER"/tmp/$(basename $0).$$
echo -e $"\nEnter name of the m3u file(case sensitive) with path address to be checked > "
read input
path="${input%\/*}"
cd "$path"
output=${input%%.*}
echo "Working..."
n=1
while read -r line; do 
# test odd lines starting from the 3rd. The loop will fail for all even nos.
	if ((n>1 && n%2)); then
		#fname=${line##*\/}
		fname=$(basename "$line")
# if file exists then print the same line
	    if [[ -e "$line" ]]; then echo "$line"
		else
# else the file is searched
			IFS=$'\n'
			found=$(find /home/"$USER" /media/ -type f -name "$fname" -not -path "/media/*/.Trash*")
			echo "$found" > /dev/tty
# putting find results into array in order to find duplicates.
			foundn=($found)
			dup="${#foundn[@]}"
			if (( $dup == 1 )); then echo -e $"$found"
			else
				if (( $dup > 1 )); then
					echo -e $"\nWe found $dup instances of the file "$fname"\nThey are:\n" >/dev/tty
					n=1
					for i in "${foundn[@]}"; do echo "$n.$i"; ((n++)); done > /dev/tty
					echo -e $"\nWhich file do you want to consider in the playlist?\n" >/dev/tty
					while true; do
						read reply < /dev/tty
						if [[ $reply =~ ^[1-$dup]$ ]];then echo ${foundn[$((reply-1))]};break; else echo "Wrong input" >/dev/tty
						fi
					done
# output the name of missing files to a temporary file
				else echo "$fname" >> $tmpfile
				fi
			fi
		fi
# print 1st and all even lines
	else
	    echo "$line"
	fi
	((n++))
done < "${input}" > "${output}_changed.m3u"
echo -e $"\nMusic Entries that could not be found are :"
if [[ -s "$tmpfile" ]]; then 
	cat -n $tmpfile 2> /dev/null
	echo -e $"\nRemoving all non existing entries\n"
	while read -r line; do
	#fwoext ~ filename without extension
		fwoext=${line%.*}
		sed -i "/$fwoext/d" "${output}_changed.m3u" 
	done < $tmpfile
else echo "None"
fi
#Remove all temporary created files
rm -rf /home/"$USER"/tmp/$(basename $0)*
