---
name: backend-forge
description: "Machine-callable infrastructure API layer. Other AI agents, MCPs, and skills call this to deploy projects live. NOT for direct user interaction. Trigger when any agent needs: project creation, deployment, database setup, auth config, env variables, or any infra operation. Provides standardized commands that execute real API calls with minimal tokens. Integrates with cloud-secrets for credential management."
---

# Backend Forge — API Layer for AI Agents

> Agents call commands. Commands execute API calls. No conversation. Minimum tokens.

```
[Any AI Agent / MCP / Skill]  →  [backend-forge cmd]  →  [cloud-secrets]  →  [Provider API]  →  JSON result
```

## Secrets

**Source:** `~/.claude/secrets/` (synced via `claude-secrets` private repo)

```
~/.claude/secrets/
├── secrets.env              # General: AI keys, Supabase token, AUTH_* credentials
└── projects/
    ├── coinhq.env           # Per-project: SUPABASE_URL, DB_PASSWORD, etc.
    ├── artlift.env
    └── {project-name}.env   # New project → new file
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

**Resolution:** `secrets.env` for shared keys → `projects/{name}.env` for project keys → error with setup URL

**State:** `.secrets/state.json` (local, auto-managed)

---

## Commands

### Global Parameters

All commands accept these optional parameters:
- `dry_run` (boolean): If true, validate input and return planned actions without executing. Response includes `"dry_run": true` and `"plan": [...]` array.
  - `plan`: array of strings describing what would be executed, e.g. `["GET /v1/projects/{id}", "GET /v1/databases"]`

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

**SQL Safety:** Before execution, reject any SQL containing dangerous keywords:
`DROP DATABASE`, `DROP SCHEMA`, `GRANT`, `REVOKE`, `ALTER ROLE`, `CREATE ROLE`,
`COPY TO`, `pg_dump`, `pg_read_file`, `pg_write_file`, `lo_import`, `lo_export`.
Return `{ "ok": false, "error": "blocked_sql", "detail": "Dangerous SQL keyword detected: [keyword]" }`.
Only `public` schema is allowed — queries targeting `pg_catalog`, `information_schema` (write), or `auth` schema are blocked.

Exec: Validate SQL → Supabase `POST /v1/projects/{ref}/database/query`

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

Zero-config: `email` works instantly. `phone` needs Twilio creds. See auth-providers.md → Phone / SMS (Twilio) for setup steps.

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

### `setup_check`
```json
IN:  {}
OUT: {
  "ok": true,
  "tokens": {
    "VERCEL_TOKEN": "set|missing",
    "SUPABASE_ACCESS_TOKEN": "set|missing"
  },
  "cli": {
    "vercel": "accessible|missing",
    "supabase": "accessible|missing"
  },
  "ready": true,
  "missing": []
}
```
Verifies the environment is fully configured before running other commands.

**Checks performed:**
1. `VERCEL_TOKEN` — present in `~/.claude/secrets/secrets.env` or environment
2. `SUPABASE_ACCESS_TOKEN` — present in `~/.claude/secrets/secrets.env` or environment
3. Vercel CLI — `vercel --version` exits 0
4. Supabase CLI — `supabase --version` exits 0

**`ready`** is `true` only when all four checks pass. **`missing`** lists the names of failed checks.

If any check fails, `ok` is still `true` (command itself succeeded) but `ready` is `false`:
```json
{ "ok": true, "ready": false, "missing": ["VERCEL_TOKEN", "vercel_cli"] }
```

Example usage:
```json
IN:  {}
OUT: {
  "ok": true,
  "tokens": { "VERCEL_TOKEN": "set", "SUPABASE_ACCESS_TOKEN": "set" },
  "cli": { "vercel": "accessible", "supabase": "accessible" },
  "ready": true,
  "missing": []
}
```

### `destroy`
```json
IN:  { "project": "x", "confirm": "x" }
OUT: { "ok": true }
```
**Safety:** `confirm` must be the exact project name (not a boolean). Mismatched name → `{ "ok": false, "error": "confirm_mismatch", "detail": "confirm value must match project name" }`.

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

## State Migration

When state version changes, auto-migrate on first read:
- v1 → v2: add `_rate` field, convert `projects` array to object (if needed)
- Unknown version → error: `{ "ok": false, "error": "state_version_unsupported" }`
- Missing state → create from template
- Backup before migration: `.secrets/state.json.bak`

## Error Format
```json
{ "ok": false, "error": "<code>", "detail": "..." }
```

| Code | Meaning |
|------|---------|
| `missing_secret` | required env var or secret not set |
| `quota_exceeded` | Vercel or Supabase plan limit reached |
| `api_error` | upstream API returned an error |
| `not_found` | requested resource does not exist |
| `blocked_sql` | SQL statement blocked by safety rules |
| `confirm_mismatch` | confirmation string did not match project name |
| `rate_limited` | command rate limit exceeded |
| `state_version_unsupported` | state.json version incompatible with this plugin version |
| `invalid_input` | request parameters failed validation |

## Audit Logging

Every command invocation is logged to `~/.claude/secrets/.audit.log`:
```
FORMAT: [ISO_TIMESTAMP] [COMMAND] [PROJECT] [STATUS] [DURATION_MS]
Example: 2026-04-08T14:30:00Z create_project myapp ok 3200
```
- Secret values are NEVER logged
- Log file permissions: 600
- Max size: 10MB (rotate to .audit.log.1)

## Rate Limiting

| Command | Limit |
|---------|-------|
| create_project | 5/hour |
| destroy | 1/hour |
| deploy | 10/hour |
| db_exec | 30/hour |
| Others | 60/hour |

Exceeded → `{ "ok": false, "error": "rate_limited", "detail": "destroy limit: 1/hour, retry after: [seconds]s" }`
Counters stored in state.json `_rate` field. Reset hourly.

## Telemetry (opt-in)

Anonymous usage stats, disabled by default:
```json
{ "telemetry": true }  // in state.json preferences
```

Collected (anonymous, no PII):
- Command name + frequency
- Success/failure ratio
- Framework type (nextjs, remix, etc.)

NOT collected: project names, URLs, secrets, SQL content.
Endpoint: configurable in state.json. Default: none (local-only counters in state.json `_telemetry`).

## Rules for Calling Agents
- JSON in, JSON out — no prose
- No confirmation prompts — execute directly
- Defaults: Vercel + Supabase, eu-central-1, nextjs
- 1 retry max, then fail fast
- Batch where possible (env vars = 1 call)
- Read state once per session, cache in memory
