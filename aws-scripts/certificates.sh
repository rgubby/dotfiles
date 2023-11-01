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
    IFS=$'\n' GWS=(`aws acm list-certificates --region $r --profile $p | jq -r -c '.CertificateSummaryList| .[] | .DomainName + ": alternatives(" + (.SubjectAlternativeNameSummaries // [] | join(",") ) + ")"'`)
    for g in ${GWS[@]}
    do
      echo "* Certificate: $g"
    done
  done
  echo "\n\n"
done

