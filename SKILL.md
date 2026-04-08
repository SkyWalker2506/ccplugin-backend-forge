---
name: infra-agent
description: "Machine-callable infrastructure API layer. Other AI agents, MCPs, and skills call this to deploy projects live. NOT for direct user interaction. Trigger when any agent needs: project creation, deployment, database setup, auth config, env variables, or any infra operation. Provides standardized commands that execute real API calls with minimal tokens. Integrates with cloud-secrets for credential management."
---

# Infra Agent — API Layer for AI Agents

> Agents call commands. Commands execute API calls. No conversation. Minimum tokens.

```
[Any AI Agent / MCP / Skill]  →  [infra-agent cmd]  →  [cloud-secrets]  →  [Provider API]  →  JSON result
```

## Secrets

**Priority:** `cloud-secrets` repo → `.secrets/` local dir → env vars

```
.secrets/
├── supabase.json   # { "access_token": "sbp_...", "org_id": "..." }
├── vercel.json     # { "token": "..." } — only if MCP unavailable
└── state.json      # project registry (auto-managed)
```

Bootstrap: if missing → create `.secrets/` + empty templates → return `{"ok":false,"error":"missing_secret","setup_url":"https://supabase.com/dashboard/account/tokens"}` → caller fills → next call works.

---

## Commands

All: INPUT JSON → execute → OUTPUT JSON.

### `create_project`
```json
IN:  { "name": "x", "framework": "nextjs" }
OUT: { "ok": true, "vercel_url": "...", "supabase_url": "...", "env_set": true }
```
Exec: Vercel MCP create → Supabase `POST /v1/projects` → get api-keys → Vercel set env (SUPABASE_URL, ANON_KEY, SERVICE_KEY, DATABASE_URL) → update state.json

### `deploy`
```json
IN:  { "project": "x" }
OUT: { "ok": true, "url": "...", "status": "ready" }
```
Exec: Vercel MCP deploy → poll until ready

### `db_exec`
```json
IN:  { "project": "x", "sql": "CREATE TABLE..." }
OUT: { "ok": true }
```
Exec: Supabase `POST /v1/projects/{ref}/database/query`

### `db_schema`
```json
IN:  { "project": "x", "tables": { "users": { "id":"uuid pk", "email":"text unique", "name":"text" } }, "rls": true }
OUT: { "ok": true, "tables_created": ["users"] }
```
Shorthand: `pk`=PRIMARY KEY+uuid, `fk:t.c`=REFERENCES, `unique`=UNIQUE NOT NULL. Converts → SQL → executes via db_exec. RLS: owner-based default.

### `auth_setup`
```json
IN:  { "project": "x", "providers": ["email","google"] }
OUT: { "ok": true, "providers_enabled": ["email","google"] }
```

### `env_set`
```json
IN:  { "project": "x", "vars": { "KEY": "val" } }
OUT: { "ok": true, "count": 1 }
```
Exec: Vercel MCP set env (all targets)

### `storage_create`
```json
IN:  { "project": "x", "bucket": "uploads", "public": false }
OUT: { "ok": true, "url": "..." }
```

### `status`
```json
IN:  { "project": "x" }  // optional, omit=all
OUT: { "projects": [{ "name":"x", "url":"...", "status":"ready" }] }
```

### `destroy`
```json
IN:  { "project": "x", "confirm": true }
OUT: { "ok": true }
```

---

## API Reference

**Supabase** — `https://api.supabase.com` — `Bearer {access_token}`
```
POST /v1/projects                       create
GET  /v1/projects/{ref}/api-keys        keys
POST /v1/projects/{ref}/database/query  sql
DELETE /v1/projects/{ref}               delete
```

**Vercel** — via MCP tools: `deploy_to_vercel`, `get_project`, `list_projects`, `list_deployments`, `get_deployment`, `get_deployment_build_logs`

---

## State

`.secrets/state.json` — auto-managed, minimal:
```json
{ "v":1, "projects": { "x": { "vercel_id":"prj_x", "supabase_ref":"ref_x", "created":"2026-04-08" } } }
```

## Error Format
```json
{ "ok": false, "error": "missing_secret|quota_exceeded|api_error|not_found", "detail": "..." }
```

## Rules for Calling Agents
- JSON in, JSON out — no prose
- No confirmation prompts — execute directly
- Defaults: Vercel + Supabase, eu-central-1, nextjs
- 1 retry max, then fail fast
- Batch where possible (env vars = 1 call)
- Read state once per session, cache in memory
