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
    IFS=$'\n' TOPICS=(`aws ec2 describe-nat-gateways --region $r --profile $p | jq -r -c '.NatGateways| .[] | .NatGatewayId + " : " + .Tags[1].Value + ": " + .NatGatewayAddresses[0].PublicIp'`)
    for t in ${TOPICS[@]}
    do
      echo "* NAT Gateway found: $t"
    done
  done
  echo "\n\n"
done

