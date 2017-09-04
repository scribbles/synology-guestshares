#!/bin/bash
rootshare=/volume1/data
guestshare=/volume1/share

mount() {
	while read mount; do
		/bin/mount -obind $rootshare/$mount $guestshare/$mount
	done < $rootshare/mounts
}

unmount() {
	while read mount; do
		/bin/umount $guestshare/$mount
	done < $rootshare/mounts 
}

addshare() {
	/bin/mkdir $guestshare/$1
	if [[ $? ]]; then 
		/bin/mount -obind /volume1/data/$1/ /volume1/share/$1/
		/bin/echo "$1" >> $rootshare/mounts
	else
		/bin/echo "mkdir failed!"
		exit 1
	fi
}

removeshare() {
	/bin/umount $guestshare/$1
	if [[ $? ]]; then 
		/bin/rmdir /volume1/share/$1/
		/bin/echo "$(/bin/grep -v "$1" $rootshare/mounts)" > $rootshare/mounts
	else 
		/bin/echo "umount failed!"
		exit 1
	fi
}

case $1 in 
	mount)
		mount
	;;
	unmount)
		unmount
	;;
	addshare)
		addshare $2
	;;
	removeshare)
		removeshare $2
	;;
	*)
		/bin/echo "Usage: $0 '(mount|unmount|addshare DIRNAME|removeshare DIRNAME)'"
	;;
esac
