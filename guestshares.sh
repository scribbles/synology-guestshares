#!/bin/bash
guestshare="/volume1/share"
mountlist="/volume1/data/mounts"

mount() {
	while read mount
	do
		/bin/mount -obind "$mount" "$guestshare/${mount##*/}"
	done < "$mountlist"
}

unmount() {
	while read mount
	do
		/bin/umount "$guestshare/${mount##*/}"
	done < "$mountlist"
}

addshare() {
	for mount in "$@"
	do
		/bin/mkdir "$guestshare/${mount##*/}"
	
		if [[ $? ]]
		then 
			/bin/mount -obind "$mount" "$guestshare/${mount##*/}"
			/bin/echo "$mount" >> $mountlist
		else
			/bin/echo "mkdir $mount failed!"
			exit 1
		fi
	done
}

removeshare() {
	for mount in "$@"
	do
		/bin/umount "$mount"
	
		if [[ $? ]]
		then 
			/bin/rmdir "$guestshare/${mount##*/}"
			/bin/sed -i "\%$mount%d" $mountlist
			if [[ ! -s "$mountlist" ]]
			then
				rm -f "$mountlist"
			fi
		else
			/bin/echo "umount $mount failed!"
			exit 1
		fi
	done
}

mountlistexists() {
	if [[ ! -e "$mountlist" ]]
	then
		echo "$mountlist not found, use addshare to populate."
		exit 1
	fi
}

case $1 in 
	mount)
		mountlistexists
		mount
	;;
	unmount)
		mountlistexists
		unmount
	;;
	addshare)
		shift
		addshare "$@"
	;;
	removeshare)
		shift
		removeshare "$@"
	;;
	*)
		/bin/echo "Usage: $0 '(mount|unmount|addshare DIRLIST|removeshare DIRLIST)'"
	;;
esac
