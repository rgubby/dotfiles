#!/bin/zsh
. "$HOME/.zshrc"
set +x

source ./get-profiles.sh

for p in "${PROFILES[@]}"
do
  echo "Account: $p"
  echo "====="
  source ./get-regions.sh $p

  for r in "${REGIONS[@]}"
  do
    echo "Region: $r"
    IFS=$'\n' INSTANCES=(`aws ec2 describe-instances --filters Name=instance-state-name,Values='running' --region $r --profile $p | jq -r -c '.Reservations | .[] | .Instances | .[] | .InstanceId + ": " + .PublicDnsName'`)
    for i in ${INSTANCES[@]}
    do
      echo "* Instance found: $i"
    done
  done
  echo "\n\n"
done

