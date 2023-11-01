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
    IFS=$'\n' TOPICS=(`aws sns list-topics --profile $p --region $r| jq -r -c '.Topics | .[] | .TopicArn'`)
    for t in ${TOPICS[@]}
    do
      echo $t
      echo "-----subscriptions-----"
      aws sns list-subscriptions-by-topic --topic-arn $t --profile $p --region $r | jq -r -c '.Subscriptions | .[] | .Endpoint'
      echo "\n"
    done
    echo "\n\n"
  done
done

