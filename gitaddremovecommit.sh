#!/bin/bash

# gitaddremovecommit.sh
# made by Adam Cotner, but I guess you can use it
# just give me some credit or something

main() {	
	# hints if you supply zero, or less than 2 (with a -p flag)
	if [ $# -eq 0 ] || ([ "$1" == "-p" ] && [ $# -lt 2 ])
		then
			print_general_usage
			exit 1 
	fi

	# add all new, updated, and deleted files
	git add .
	git add -u

	# check if you're supposed to pull/push
	if [ "$1" == "-p" ]
		then
			# pass all but the first argument (-p flag)
			commit_message "${@:2}"
			pull_push
		else
			# pass all arguments
			commit_message "$@"
	fi
}

commit_message() {

	# build commit message
	MSG=""
	for ARG in "$@"
	do
		MSG="$MSG $ARG"
	done

	# commit
	git commit -m "$MSG"
}

pull_push() {

	# get branch name
	BRANCH=$(git branch | awk '/\*/ { print $2; }')

	# pull before you push
	git pull origin "$BRANCH"

	# push
	git push origin "$BRANCH"
}

#usage information
print_general_usage() {
	echo "~~ gitaddremovecommit usage: ~~"
	echo "- Please supply a commit message."
	echo "~~ ~~"
}

# go!
main "$@"