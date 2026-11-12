# Sada Artifact Registry bootstrap

This feature branch adds GitHub Actions automation for provisioning and publishing to Google Artifact Registry.

It includes Terraform-based Artifact Registry provisioning and a manual Docker image push workflow for the `sada-seed-2025-sandbox` project.

This repository is prepared for a GitHub Actions setup that:

- provisions a Google Artifact Registry repository in the `sada-seed-2025-sandbox` project using Terraform
- runs a Terraform plan on pull requests to `main`
- runs Terraform apply on merge to `main`
- builds and pushes a Docker image to the provisioned Artifact Registry manually from the `main` branch

## Required Google Cloud setup

Use the exact environment values below in Cloud Shell:

```bash
export MEMBER_ID="yourname"
export GITHUB_REPO="your-github-username/your-repo-name"
export PROJECT_ID="sada-seed-2025-sandbox"
export PROJECT_NUMBER="607748495856"
export POOL_ID="ga-identity"
export PROVIDER_ID="zenitsu"
export SA_NAME="${MEMBER_ID}-cicd-sa"
export SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
```

Then create the service account and bind the GitHub repo to it:

```bash
gcloud iam service-accounts create "$SA_NAME" \
  --display-name="Terraform CI/CD SA - ${MEMBER_ID}"

gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}"

gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.serviceAccountTokenCreator" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}"
```

The IAM condition should allow the OIDC principal used by GitHub Actions, for example:

- `attribute.actor == "sponnur1"`
- `attribute.repository_owner == "sadasystems"`
- `attribute.repository == "sadasystems/<your-repo-name>"`

## Required GitHub repository secrets

Configure the following GitHub repository secrets:

- `GCP_SERVICE_ACCOUNT`: the service account email, for example `yourname-cicd-sa@sada-seed-2025-sandbox.iam.gserviceaccount.com`
- `GCP_WORKLOAD_IDENTITY_PROVIDER`: `projects/607748495856/locations/global/workloadIdentityPools/ga-identity/providers/zenitsu`

The repo must also have access to create Artifact Registry resources:

```bash
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.admin"
```

Optional values can also be set as repository variables:

- `PROJECT_ID` = `sada-seed-2025-sandbox`
- `REGION` = `us-central1`
- `ARTIFACT_REPOSITORY` = `sada-docker`
- `IMAGE_NAME` = `sada-app`

## Terraform

Terraform code lives under `infra/terraform/`.

## GitHub Actions workflows

- `.github/workflows/terraform-artifact-registry.yml`
- `.github/workflows/docker-build-push.yml`
