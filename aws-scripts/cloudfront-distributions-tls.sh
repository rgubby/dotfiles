#!/bin/zsh
. "$HOME/.zshrc"
set +x

source ./get-profiles.sh

echo "+===============================+"
if [[ ! -z $MINIMUM_TLS_VERSION ]]; then
  echo "Finding Cloudfront Distributions with Minimum TLS version: $MINIMUM_TLS_VERSION"
elif [[ ! -z $NOT_TLS_VERSION ]]; then
  echo "Finding Cloudfront Distributions NOT equal to TLS version: $NOT_TLS_VERSION"
else
  echo "Finding Cloudfront Distributions"
fi
echo "+===============================+"
for p in "${PROFILES[@]}"
do
  echo "Account: $p"
  echo "====="

  if [[ ! -z $ENABLED ]]; then
    ENABLED=" && Enabled==\`true\`"
    ENABLED_NO_QUERY="[?Enabled==\`true\`]"
  else
    ENABLED=""
    ENABLED_NO_QUERY=""
  fi
  if [[ ! -z $DISABLED ]]; then
    DISABLED=" && Enabled==\`false\`"
    DISABLED_NO_QUERY="[?Enabled==\`false\`]"
  else
    DISABLED=""
    DISABLED_NO_QUERY=""
  fi

  if [[ ! -z $MINIMUM_TLS_VERSION ]]; then
    IFS=$'\n' DISTROS=(`aws cloudfront list-distributions --profile $p --query "DistributionList.Items[?ViewerCertificate.MinimumProtocolVersion!=null] | [?ViewerCertificate.MinimumProtocolVersion=='$MINIMUM_TLS_VERSION' $ENABLED $DISABLED]"  | jq -r -c '.[]? | .Id + ": " + .DomainName + ", Aliases: " + ([.Aliases.Items[]?] | join(",")) + ", Origins: " + ([.Origins.Items[]?.DomainName] | join(",")) + ", Minimum TLS Version: '$MINIMUM_TLS_VERSION'"'`)
  elif [[ ! -z $NOT_TLS_VERSION ]]; then
    # echo "aws cloudfront list-distributions --profile $p --query "DistributionList.Items[?ViewerCertificate.MinimumProtocolVersion!=null] | [?ViewerCertificate.MinimumProtocolVersion!='$NOT_TLS_VERSION'] $ENABLED $DISABLED"  | jq -r -c '.[]? | .Id + ": " + .DomainName + ", Aliases: " + ([.Aliases.Items[]?] | join(",")) + ", Origins: " + ([.Origins.Items[]?.DomainName] | join(",")) + ", Minimum TLS Version: " + .ViewerCertificate.MinimumProtocolVersion'"
    IFS=$'\n' DISTROS=(`aws cloudfront list-distributions --profile $p --query "DistributionList.Items[?ViewerCertificate.MinimumProtocolVersion!=null] | [?ViewerCertificate.MinimumProtocolVersion!='$NOT_TLS_VERSION' $ENABLED $DISABLED]"  | jq -r -c '.[]? | .Id + ": " + .DomainName + ", Aliases: " + ([.Aliases.Items[]?] | join(",")) + ", Origins: " + ([.Origins.Items[]?.DomainName] | join(",")) + ", Minimum TLS Version: " + .ViewerCertificate.MinimumProtocolVersion'`)
  else
    IFS=$'\n' DISTROS=(`aws cloudfront list-distributions --profile $p --query "DistributionList.Items$ENABLED_NO_QUERY$DISABLED_NO_QUERY" | jq -r -c '.[]? | .Id + ": " + .DomainName + ", Aliases: " + ([.Aliases.Items[]?] | join(",")) + ", Origins: " + ([.Origins.Items[]?.DomainName] | join(",")) + ", Minimum TLS Version: " + .ViewerCertificate.MinimumProtocolVersion'`)
  fi
  for d in ${DISTROS[@]}
  do
    echo "* Distribution Found: $d"
  done
done

