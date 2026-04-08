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

**Source:** `~/.claude/secrets/` (synced via `claude-secrets` private repo)

```
~/.claude/secrets/
├── secrets.env              # Genel: AI keys, Supabase token, AUTH_* credentials
└── projects/
    ├── coinhq.env           # Proje bazli: SUPABASE_URL, DB_PASSWORD, vs.
    ├── artlift.env
    └── {project-name}.env   # Yeni proje → yeni dosya
```

**General keys** (secrets.env):
```
SUPABASE_ACCESS_TOKEN=...              # Management API
AUTH_{PROVIDER}_CLIENT_ID=...          # OAuth (see auth-providers.md)
AUTH_{PROVIDER}_CLIENT_SECRET=...
```

**Project keys** (projects/{name}.env — no prefix, standard names):
```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
SUPABASE_DB_PASSWORD=...
```

Vercel: via MCP (no token needed).

**Resolution:** `secrets.env` for shared keys → `projects/{name}.env` for project keys → inline override → error with setup URL

**State:** `.secrets/state.json` (local, auto-managed)

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
IN:  { "project": "x", "providers": ["email","google","facebook"] }
OUT: { "ok": true, "providers_enabled": ["email","google","facebook"], "pending_config": [] }
```

Supported providers: `email`, `google`, `facebook`, `apple`, `github`, `twitter`, `discord`, `linkedin`, `spotify`, `twitch`, `slack`, `notion`, `bitbucket`, `gitlab`, `azure`, `keycloak`, `phone`

Zero-config: `email` works instantly. `phone` needs Twilio creds.

**Credential resolution (automatic):**
1. Read `~/.claude/secrets/secrets.env`
2. Look for `AUTH_{PROVIDER}_CLIENT_ID` and `AUTH_{PROVIDER}_CLIENT_SECRET`
3. If found → enable provider with credentials automatically
4. If missing → return in `pending_config` with setup URL + env var names to add

```
# secrets.env — AUTH section example:
# --- AUTH PROVIDERS ---
AUTH_GOOGLE_CLIENT_ID=xxx.apps.googleusercontent.com
AUTH_GOOGLE_CLIENT_SECRET=GOCSPX-xxx
AUTH_FACEBOOK_CLIENT_ID=123456789
AUTH_FACEBOOK_CLIENT_SECRET=abc123
AUTH_GITHUB_CLIENT_ID=Iv1.xxx
AUTH_GITHUB_CLIENT_SECRET=xxx
```

Naming convention: `AUTH_{PROVIDER}_CLIENT_ID` / `AUTH_{PROVIDER}_CLIENT_SECRET`
Special cases: `AUTH_APPLE_SECRET` (base64 .p8 key), `AUTH_KEYCLOAK_URL` (realm URL)

Exec: Read secrets → Supabase `PUT /auth/v1/config` per provider → update state

**Override:** credentials can still be passed inline for one-off use:
```json
IN:  { "project": "x", "providers": ["google"], "credentials": { "google": { "client_id": "...", "client_secret": "..." } } }
```
Priority: inline `credentials` > `secrets.env` > `pending_config`

**Callback URL** (same for all): `https://{supabase_ref}.supabase.co/auth/v1/callback`

See `auth-providers.md` for per-provider setup guide with console URLs.

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
