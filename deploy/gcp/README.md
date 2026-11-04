# Contents Platform: Google Cloud Platform Serverless Architecture

This guide details the serverless deployment architecture for the **Contents Platform**, featuring:
- **Cloud Run**: Serverless container execution for `contents-api` (Django Ninja + Gunicorn)
- **Firebase Hosting**: Global CDN edge hosting for `contents-web` (React + Vite + Grommet)
- **Same-Origin API Rewriting**: `/api/**` traffic routed via Firebase Hosting rewrites to Cloud Run (eliminating CORS)
- **Cloud SQL (PostgreSQL)**: Scalable, highly available relational storage
- **Artifact Registry & Cloud Build**: Continuous integration and container delivery

---

## Architecture Diagram

```
                 Internet / User Browser
                            │
                            ▼
               ┌───────────────────────────┐
               │  Firebase Hosting (CDN)   │
               │  • Global edge cache      │
               │  • Automatic SSL / HTTPS  │
               └────────────┬──────────────┘
                            │
            ┌───────────────┴───────────────┐
            │                               │
    Path: /* (SPA)                  Path: /api/** (Rewrites)
            │                               │
            ▼                               ▼
   ┌─────────────────┐             ┌─────────────────┐
   │ React SPA (Web) │             │ Cloud Run (API) │
   │ • Static assets │             │ • Django Ninja  │
   │ • Vite bundle   │             │ • 0..5 instances│
   └─────────────────┘             └────────┬────────┘
                                            │
                                            ▼
                                   ┌─────────────────┐
                                   │    Cloud SQL    │
                                   │ • PostgreSQL 16 │
                                   └─────────────────┘
```

---

## 1. Prerequisites

- Google Cloud Project with Billing enabled
- Installed CLI tools:
  - `gcloud` (Google Cloud SDK)
  - `firebase-tools` (`npm install -g firebase-tools`)
  - `docker` (optional, for local image verification)

---

## 2. Fast Deployment via `deploy.sh`

1. Set your GCP project:
   ```bash
   gcloud config set project <YOUR_GCP_PROJECT_ID>
   ```

2. Run the deployment script:
   ```bash
   cd deploy/gcp
   ./deploy.sh
   ```

---

## 3. Environment Secrets (Secret Manager)

Store sensitive configuration in Google Cloud Secret Manager:

```bash
# Database URL
gcloud secrets create contents-database-url --replication-policy="automatic"
echo -n "postgresql://contents_user:PASSWORD@/contents_db?host=/cloudsql/PROJECT:REGION:INSTANCE" | \
  gcloud secrets versions add contents-database-url --data-file=-

# Django Secret Key
gcloud secrets create contents-secret-key --replication-policy="automatic"
openssl rand -base64 32 | gcloud secrets versions add contents-secret-key --data-file=-
```

Bind secrets directly to Cloud Run:

```bash
gcloud run services update contents-api \
  --region us-central1 \
  --set-secrets DATABASE_URL=contents-database-url:latest,SECRET_KEY=contents-secret-key:latest
```

---

## 4. Local Testing with Docker

To test the container locally:

```bash
cd api
docker compose up --build
```

Test endpoints:
- Root health check: `curl http://localhost:8000/`
- API diagnostic: `curl http://localhost:8000/api/health`
- OpenAPI Swagger UI: Open browser at `http://localhost:8000/api/docs`
