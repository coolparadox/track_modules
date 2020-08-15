#!/bin/bash

deps(){
	test -n "$1" || return
	n=$1
	/usr/sbin/modinfo -k 5.4.48-gentoo-tormenta16 --basedir sample --field depends $n | tr "," "\n" | \
	while read l; do
		deps $l
	done
	echo $n
}

deps $1
