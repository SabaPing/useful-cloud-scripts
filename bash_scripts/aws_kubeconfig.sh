#!/usr/bin/env bash
set -euo pipefail

unset KUBECONFIG

# Make sure to config SSO and profile in ~/.aws/config.
# Make sure to login with aws sso login (`aws sso login --profile xxxx`).
awsProfile=( auto-dev-rw auto-prod-rw)

awsRegions=( ap-northeast-1 ap-northeast-2 ap-south-1 ap-southeast-1 ap-southeast-3 eu-central-1 us-east-1 us-west-1 us-west-2 )

function awsKubeConfig(){
    aws eks --profile $1 --region $2 --output text list-clusters | awk '{print $2}' | xargs -n 1 -I {} aws eks --profile $1 --region $2 update-kubeconfig --kubeconfig output/aws.kubeconfig.yaml --name {} || true
}

# update kubeconfig for AWS EKS cluster
for profile in "${awsProfile[@]}"
do
  for region in "${awsRegions[@]}"
  do
    awsKubeConfig $profile $region
  done
done
