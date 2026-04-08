# Alternative Providers Reference

Use this file when user wants to switch from the default stack.

---

## Database Alternatives

### Neon (PostgreSQL)
- **What:** Serverless Postgres, auto-scales to zero
- **Free tier:** 0.5 GB storage, 1 project, autosuspend after 5min idle
- **API:** Full REST + SQL over HTTP
- **Setup:**
  1. https://console.neon.tech/signup
  2. Create project → copy connection string
- **Best for:** Serverless apps that sleep between requests

### PlanetScale (MySQL)
- **What:** MySQL-compatible, branching like git
- **Free tier:** 5GB storage, 1B row reads/mo, 10M row writes/mo
- **API:** REST + MySQL protocol
- **Setup:**
  1. https://app.planetscale.com/sign-up
  2. Create database → Settings → Passwords → New password
- **Best for:** MySQL-native apps, schema branching

### Turso (SQLite at edge)
- **What:** Distributed SQLite, runs at edge
- **Free tier:** 9GB storage, 500 databases, 25M rows read/mo
- **API:** HTTP API + libSQL
- **Setup:**
  1. https://turso.tech/app
  2. Create database → copy URL + auth token
- **Best for:** Edge-first apps, read-heavy workloads

---

## Auth Alternatives

### Clerk
- **What:** Drop-in auth UI components + API
- **Free tier:** 10,000 MAU
- **API:** Full REST API + SDKs
- **Setup:**
  1. https://dashboard.clerk.com/sign-up
  2. Create application → API Keys → copy
- **Best for:** Fastest auth setup, great prebuilt UI

### Auth0
- **What:** Enterprise-grade identity platform
- **Free tier:** 25,000 MAU (with limits)
- **API:** Full REST + SDKs
- **Setup:**
  1. https://auth0.com/signup
  2. Applications → Create → copy domain + client ID + secret
- **Best for:** Complex auth flows, enterprise needs

---

## Storage Alternatives

### Cloudflare R2
- **What:** S3-compatible storage, no egress fees
- **Free tier:** 10GB storage, 10M reads, 1M writes/mo
- **API:** S3-compatible
- **Setup:**
  1. https://dash.cloudflare.com → R2
  2. Create bucket → Manage R2 API Tokens
- **Best for:** High-bandwidth file serving, S3 migration

### Uploadthing
- **What:** File uploads for Next.js, simple API
- **Free tier:** 2GB storage, 2GB bandwidth
- **API:** SDK-based
- **Setup:**
  1. https://uploadthing.com/dashboard
  2. Create app → copy API key
- **Best for:** Quick file upload in Next.js apps

---

## Hosting Alternatives

### Netlify
- **What:** JAMstack hosting + serverless functions
- **Free tier:** 100GB bandwidth, 300 build min/mo
- **API:** Full REST API
- **Setup:**
  1. https://app.netlify.com/signup
  2. User settings → Applications → Personal access tokens
- **Best for:** Static sites, JAMstack

### Railway
- **What:** Full backend hosting with databases
- **Free tier:** $5/mo credit (trial), then pay-as-you-go
- **API:** GraphQL API
- **Setup:**
  1. https://railway.app/login
  2. Account → Tokens → Create
- **Best for:** Backend services, Docker containers

### Fly.io
- **What:** Deploy containers globally at edge
- **Free tier:** 3 shared VMs, 3GB storage
- **API:** REST + CLI
- **Setup:**
  1. https://fly.io/app/sign-up
  2. Account → Access Tokens → Create
- **Best for:** Global distribution, Docker-based apps
