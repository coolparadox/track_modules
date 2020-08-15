#!/bin/bash
F='/tmp/mod.txt'
rm -f $F
touch $F
no-reps(){
	while read m; do
		fgrep -q $m $F || {
			echo $m >> $F
			echo $m
		}
	done
}

deps(){
	test -n "$1" || return
	n=$@
	/usr/sbin/modinfo -k 5.4.48-gentoo-tormenta16 --basedir sample --field depends $n | tr "," "\n" | \
	while read l; do
		deps $l
	done
 	echo $n
}

deps $@ | no-reps
