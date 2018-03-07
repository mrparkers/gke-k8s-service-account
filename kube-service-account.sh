#!/usr/bin/env bash

set -e

serviceAccounts=$(gcloud auth list --format json | jq -r '. | map(.account)')
numberOfServiceAccounts=$(echo ${serviceAccounts} | jq '. | length')

printf "\nSelect service account (run \`gcloud auth activate-service-account\` to add to this list)\n"

for (( i = 0; i < $numberOfServiceAccounts; i++ )); do
    printf "${i})\t%s\n" "$(echo ${serviceAccounts} | jq -r --arg i "${i}" '.[$i | tonumber]')"
done

echo -n "Number: "
read index

serviceAccount=$(echo ${serviceAccounts} | jq -r --arg i "${index}" '.[$i | tonumber]')

token=$(gcloud auth print-access-token --account=${serviceAccount})

alias kubectlt='kubectl --token=${token}'

echo "Alias \`kubectlt\` has been configured to use service account ${serviceAccount}"
