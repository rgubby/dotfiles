#!/bin/zsh
. "$HOME/.zshrc"
set +x

source ./get-profiles.sh

echo "+===============================+"
echo "Finding Cloudfront Distributions"
echo "+===============================+"
for p in "${PROFILES[@]}"
do
  echo "Account: $p"
  echo "====="

  IFS=$'\n' DISTROS=(`aws cloudfront list-distributions --profile $p | jq -r -c '.DistributionList.Items | .[] | .Id + ": " + .DomainName + ", Aliases: " + ([.Aliases.Items[]?] | join(",")) + ", Origins: " + ([.Origins.Items[] | .DomainName] | join(","))'`)
  for d in ${DISTROS[@]}
  do
    echo "* Distribution Found: $d"
  done
done

