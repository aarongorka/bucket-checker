#!/usr/bin/env bash
BUCKETS="$(aws s3api list-buckets --query 'Buckets[*].Name' | jq -r '.[]')"
IFS=$'\n'
for BUCKET in $BUCKETS; do
#	echo "Checking bucket ${BUCKET}..."
	POLICY="$(aws s3api get-bucket-acl --bucket "${BUCKET}")"
#	echo "Policy: ${POLICY}"
	GRANTS="$( echo "${POLICY}" | jq -r '.Grants[].Grantee.URI')"
	IFS=$'\n'
	for GRANT in ${GRANTS}; do
		if [[ ${GRANT} == "http://acs.amazonaws.com/groups/global/AllUsers" ]]; then
			echo "Hit on ${BUCKET} in account ${ASSUMED_ROLE}"
		fi
	done
done
