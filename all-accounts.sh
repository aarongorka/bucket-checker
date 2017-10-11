#!/usr/bin/env bash
PROFILES="$(cat ~/.aws/config | grep -Po 'profile.*' | grep -v 'default' | sed 's/]$//g' | sed 's/profile //g' | sort | uniq)"
#echo "${PROFILES}"
IFS=$'\n'
function assume-role-eval() {
	eval "$(assume-role $@)"
}
for PROFILE in ${PROFILES}; do
	echo "Running ./bucket.sh on profile '${PROFILE}'."
	assume-role-eval "${PROFILE}"
	./bucket.sh
done
