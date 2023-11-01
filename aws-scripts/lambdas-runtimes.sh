#!/bin/zsh
# Usage: ./lambdas-runtimes.sh
#  -or-: PROFILE=sandbox1-sso REGION=eu-west-1 RUNTIME=nodejs14.x ./lambas-runtimes.sh
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
    if [[ -z $RUNTIME ]]; then
      IFS=$'\n' LAMBDAS=(`aws lambda list-functions --region $r --profile $p | jq -r -c '.Functions| .[] | .FunctionName'`)
    else
      IFS=$'\n' LAMBDAS=(`aws lambda list-functions --region $r --profile $p --query "Functions[?Runtime=='$RUNTIME']" | jq -r -c '.[] | .FunctionName'`)
    fi
    for l in ${LAMBDAS[@]}
    do
      echo "* Lambda found: $l"
    done
  done
  echo "\n\n"
done

