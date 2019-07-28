#!/bin/bash

set -euo pipefail

: $REGION
: $TF_STATE_BUCKET
: $PROJECT_ID
: $TF_ADMIN

# Create bucket

export TF_VAR_region=${REGION}
export TF_VAR_bucket=${TF_STATE_BUCKET}
export TF_ADMIN=${PROJECT_ID}-terraform-admin

# CREATE TF project
gcloud projects create ${PROJECT_ID}  \
--name="kubernetes ${PROJECT_ID} project" --labels=type=${PROJECT_ID} \
--set-as-default

# gcloud beta billing projects link ${PROJECT_ID} \
#   --billing-account ${BILLING_ACCOUNT}

# CREATE TF service account
gcloud iam service-accounts create terraform \
  --display-name "Terraform '${PROJECT_ID}' account" \
  --project ${PROJECT_ID}

# Enable services for terraform
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable compute.networks.create

gcloud iam service-accounts keys create  ${TF_CREDS} \
  --billing-project ${PROJECT_ID} \
  --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/storage.admin

# This role should be enough
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/editor

gcloud iam service-accounts keys create  ${TF_CREDS} \
  --billing-project ${PROJECT_ID} \
  --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com

gsutil mb -c regional -p ${PROJECT_ID} -l ${REGION} gs://${TF_STATE_BUCKET}
gsutil versioning set on gs://${TF_STATE_BUCKET}
# https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform

