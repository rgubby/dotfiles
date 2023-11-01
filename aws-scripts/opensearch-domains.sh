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
    IFS=$'\n' TOPICS=(`aws opensearch list-domain-names --region $r --profile $p | jq -r -c '.DomainNames| .[] | .DomainName'`)
    for t in ${TOPICS[@]}
    do
      echo "* Cluster found: $t"
    done
  done
  echo "\n\n"
done

