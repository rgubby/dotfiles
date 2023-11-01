#!/bin/zsh
. "$HOME/.zshrc"
set +x

source ./get-profiles.sh

START_TIME=`date -v '-6m'  +%Y-%m-%dT%H:%M:%S`
END_TIME=`date -v '-30M'  +%Y-%m-%dT%H:%M:%S`

echo "Start time: $START_TIME"
echo "End time: $END_TIME"

for p in "${PROFILES[@]}"
do
  echo "Account: $p"
  echo "====="
  source ./get-regions.sh $p
  
  for r in "${REGIONS[@]}"
  do
    IFS=$'\n' BUSES=(`aws events list-event-buses --profile $p --region $r | jq -r -c '.EventBuses | .[] | .Name'`)
    for b in ${BUSES[@]}
    do
      echo "--- EventBusName: $b ---"
      IFS=$'\n' RULES=(`aws events list-rules --event-bus-name $b --profile $p --region $r | jq -r -c '.Rules| .[] | .Name'`)
      for u in ${RULES[@]}
      do
        echo "  -- rule: $u"
        IFS=$'\n' TARGETS=(`aws events list-targets-by-rule --event-bus-name $b --rule $u --profile $p --region $r | jq -r -c '.Targets | .[] | .Arn'`)
        for t in ${TARGETS[@]}
        do
          TARGET=`echo $t | awk -F 'function:' '{print $2}'`
          if [ "${TARGET}" ]; then
            ERRORS=`aws cloudwatch get-metric-statistics --namespace "AWS/Lambda" --metric-name Errors --start-time "$START_TIME" --end-time "$END_TIME" --period 15724800 --profile $p --statistics Sum --dimensions Name=FunctionName,Value=$TARGET | jq -r -c '.Datapoints | .[] | .Sum'`
            echo "    * target: $TARGET errors: $ERRORS"
          fi
        done
      done
      echo "\n"
    done
    echo "\n\n"
  done
done

