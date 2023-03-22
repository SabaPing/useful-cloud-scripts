#!/usr/bin/env bash
set -euo pipefail

unset KUBECONFIG

# Make sure to login to gcloud first (`gcloud auth application-default login`).
projects=( gcp-autonomous-dev gcp-autonomous-prod)
gcpRegions=( asia-east1 asia-northeast1 asia-northeast2 asia-southeast1 us-central1 us-east4 us-west1 )

function gcpKubeConfig(){
    gcloud container clusters list --project $1 --region $2 | awk 'NR == 1 {next} {print $1}' | xargs -n 1 -I {} gcloud container clusters get-credentials {} --project $1 --region $2 || true
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUTPUT_DIR=$SCRIPT_DIR/output
mkdir -p $OUTPUT_DIR
touch $OUTPUT_DIR/gcp.kubeconfig.yaml
export KUBECONFIG=$OUTPUT_DIR/gcp.kubeconfig.yaml

for project in "${projects[@]}"; do
    for region in "${gcpRegions[@]}"; do
        gcpKubeConfig $project $region
    done
done

unset KUBECONFIG
