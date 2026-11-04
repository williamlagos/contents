# Contents

[![Contents CI](https://github.com/williamlagos/contents/actions/workflows/ci.yml/badge.svg)](https://github.com/williamlagos/contents/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Django Ninja](https://img.shields.io/badge/backend-django--ninja-purple.svg)](https://django-ninja.rest-framework.com/)
[![React](https://img.shields.io/badge/frontend-react--18-blue.svg)](https://react.dev/)
[![Google Cloud](https://img.shields.io/badge/deploy-GCP%20Cloud%20Run%20%2B%20Firebase-4285F4.svg)](https://cloud.google.com/)

**Contents** is an open-source headless CMS, Plethora digital publishing network, ActivityPub social federation hub, and multi-rail e-commerce platform.

---

## Architecture Overview

Contents combines a modular React + Grommet frontend with a high-performance Django Ninja backend orchestrating 5 companion packages:

```
                           ┌─────────────────────────────────────────┐
                           │          CONTENTS PLATFORM              │
                           │  • Headless CMS & Digital Publishing    │
                           │  • React 18 + Vite + Grommet Frontend   │
                           │  • Django Ninja Typed REST API          │
                           │  • GCP Serverless (Cloud Run + Firebase)│
                           └────┬─────────────────┬────────────────┬─┘
                                │                 │                │
             ┌──────────────────┘                 │                └──────────────────┐
             ▼                                    ▼                                   ▼
 ┌─────────────────────────┐      ┌─────────────────────────┐      ┌─────────────────────────┐
 │     django-plethora     │      │       django-ship       │      │      django-feedly      │
 │  • Spreadable Articles  │      │  • Multi-Rail Payments  │      │  • AI Discovery Feeds   │
 │  • Playable Interactive │      │    - Stripe Checkout    │      │  • Semantic Search      │
 │  • Media Galleries      │      │    - PayPal v2 REST     │      │  • Content Moderation   │
 │  • Plethora CMS Engine  │      │    - Web3 EVM & SIWE    │      │                         │
 └─────────────────────────┘      └─────────────────────────┘      └─────────────────────────┘
             │                                                                        │
             ▼                                                                        ▼
 ┌─────────────────────────┐                                              ┌─────────────────────────┐
 │   django-dashboarder    │                                              │     django-socialize    │
 │  • Admin Dashboard      │                                              │  • ActivityPub Engine   │
 │  • Form Widget Tweaks   │                                              │  • Federated Actors     │
 └─────────────────────────┘                                              └─────────────────────────┘
```

---

## Repository Structure

- [`api/`](api/): Backend Django Ninja API with OpenAPI documentation at `/api/docs`.
- [`web/`](web/): Frontend Single-Page Application (React, Vite, Grommet, Storybook, Jest, Cypress).
- [`deploy/gcp/`](deploy/gcp/): Production serverless deployment configuration for Google Cloud (Cloud Run, Cloud SQL, Firebase Hosting).

---

## Companion Packages

| Package | Version | Description | PyPI / Repo |
|---|---|---|---|
| `django-plethora` | `0.1.0` | Content engine for digital publications and media | [django-plethora](https://github.com/williamlagos/django-plethora) |
| `django-dashboarder` | `0.2.0` | Modernized administration dashboard | [django-dashboarder](https://github.com/williamlagos/django-dashboarder) |
| `django-ship` | `0.4.0` | Multi-rail payments & postal shipping | [django-ship](https://github.com/williamlagos/django-ship) |
| `django-socialize` | `0.6.0` | ActivityPub federation & social identities | [django-socialize](https://github.com/williamlagos/django-socialize) |
| `django-feedly` | `0.9.0` | AI vector embeddings & ranking feeds | [django-feedly](https://github.com/williamlagos/django-feedly) |

---

## Quick Start

### 1. Backend (Django Ninja)

```bash
cd api
uv pip install -e .
python manage.py migrate
python manage.py runserver
```
Interactive OpenAPI documentation: [http://localhost:8000/api/docs](http://localhost:8000/api/docs)

### 2. Frontend (React + Vite)

```bash
cd web
npm install
npm run dev
```
Local dev application: [http://localhost:3000](http://localhost:3000) (requests to `/api/**` automatically proxy to backend).

---

## Deployment to Google Cloud (GCP)

To deploy both the backend API to Cloud Run and frontend to Firebase Hosting:

```bash
cd deploy/gcp
./deploy.sh
```

See [deploy/gcp/README.md](deploy/gcp/README.md) for full instructions.
