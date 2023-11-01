if [ -n "$REGION" ]
then
  REGIONS=($REGION)
else
  if [ -n "$REGIONS" ]
  then
    REGIONS=($(echo "$REGIONS" | tr ',' '\n'))
  else
    echo "Getting regions for profile "$1
    IFS=$'\n' REGIONS=(`aws ec2 describe-regions --profile $1 | jq -r -c '.Regions | .[] | .RegionName'`)
  fi
fi