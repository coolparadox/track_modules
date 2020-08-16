#!/bin/bash
set -euo pipefail
F=`mktemp`
basedir=""

while getopts "b:" OPT; do
        case $OPT in
    	    b) basedir=$OPTARG
            ;;
	esac
done
shift $(($OPTIND-1))

#No-reps(no repetition) we use this function to filter lines in stdin and give
#same lines whithout repetitions in the same order.

no-reps(){
	while read m; do
		fgrep -qw $m $F || {
			echo $m >> $F
			echo $m
		}
	done
}

#Deps_mod1 search direct and independencies modules of the module
#that was insert and show for the user a complete list
#Notes: there may be repetition

deps_mod1(){
	test -n "$1" || return 0
	n=$1
	/usr/sbin/modinfo -k 5.4.48-gentoo-tormenta16 --basedir $basedir --field depends $n | tr "," "\n" | \

	while read l; do
		test -n "$l" && deps_mod1 $l || :
	done
	echo $n
}

#Deps_modn separe arguments and apply deps_mod1 for each argument
deps_modn(){
	for m in $@; do
		deps_mod1 $m
	done
}

deps_modn $@ | no-reps
rm $F
