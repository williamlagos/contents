#!/usr/bin/env bash
set -euo pipefail

# Contents Platform - Google Cloud Deployer
# Deploys:
#   1. Backend API (Django Ninja) -> Cloud Run
#   2. Frontend SPA (React + Vite) -> Firebase Hosting with Cloud Run /api/** rewrites

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

PROJECT_ID="${GCP_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || echo "")}"
REGION="${GCP_REGION:-us-central1}"
SERVICE_NAME="${SERVICE_NAME:-contents-api}"
FIREBASE_SITE="${FIREBASE_SITE:-contents-web}"

echo "=========================================="
echo " Contents GCP Serverless Deployment"
echo "=========================================="
echo " Project:   ${PROJECT_ID}"
echo " Region:    ${REGION}"
echo " Service:   ${SERVICE_NAME}"
echo " Web Site:  ${FIREBASE_SITE}"
echo "=========================================="

if [[ -z "${PROJECT_ID}" ]]; then
  echo "ERROR: GCP_PROJECT_ID is not set. Run 'gcloud config set project <ID>' or export GCP_PROJECT_ID."
  exit 1
fi

# Step 1: Deploy Backend to Cloud Run
echo ""
echo "==> [1/2] Building and Deploying Backend to Cloud Run..."
cd "${ROOT_DIR}/api"

gcloud run deploy "${SERVICE_NAME}" \
  --source . \
  --project "${PROJECT_ID}" \
  --region "${REGION}" \
  --platform managed \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 5 \
  --memory 512Mi \
  --set-env-vars "DEBUG=False,ALLOWED_HOSTS=*"

API_URL="$(gcloud run services describe "${SERVICE_NAME}" --platform managed --region "${REGION}" --project "${PROJECT_ID}" --format='value(status.url)')"
echo "Backend deployed successfully: ${API_URL}"

# Step 2: Build & Deploy Frontend to Firebase Hosting
echo ""
echo "==> [2/2] Building and Deploying React Web Frontend..."
cd "${ROOT_DIR}/web"
npm install
npm run build

cd "${ROOT_DIR}"
if command -v firebase >/dev/null 2>&1; then
  firebase use --add "${PROJECT_ID}" || true
  firebase deploy --only hosting
else
  echo "WARNING: firebase CLI not found. Install with 'npm install -g firebase-tools' and run 'firebase deploy'."
fi

echo ""
echo "=========================================="
echo " Deployment Complete!"
echo " API URL:      ${API_URL}"
echo " Documentation: ${API_URL}/api/docs"
echo "=========================================="
