# ccplugin-backend-forge

![claude-code](https://img.shields.io/badge/claude--code-plugin-black?style=flat-square)
![version](https://img.shields.io/badge/version-1.0.0-blue?style=flat-square)
![infra](https://img.shields.io/badge/infra-API--layer-orange?style=flat-square)
![plugin](https://img.shields.io/badge/plugin-open--source-green?style=flat-square)

> Part of the [Claude Code Plugin Marketplace](https://github.com/SkyWalker2506/claude-marketplace) — `./install.sh backend-forge`

Machine-callable infrastructure API layer for Claude Code. Other AI agents, MCPs, and skills call this plugin to deploy projects, create databases, configure auth, and manage environments — no human interaction needed.

## What it does

Provides a standardized command interface that other agents call with JSON in/out. Default stack: **Vercel** (hosting) + **Supabase** (database, auth, storage). Alternative providers documented in `alternatives.md`.

## Why

Building a full-stack app with Claude means the AI needs to provision real infrastructure — not just write code. Backend Forge bridges that gap: any agent can call `create_project` and get a live Vercel URL + Supabase database in one shot.

- **Agent-to-agent API** — JSON in, JSON out, no prose, no confirmation prompts
- **Full stack in one call** — Vercel project + Supabase DB + env vars wired together
- **Fail fast** — 1 retry max, structured error responses
- **Alternative providers** — Swap Supabase for Neon, PlanetScale, or Turso when needed

## Commands

| Command | Description |
|---------|-------------|
| `create_project` | Create Vercel + Supabase project, wire env vars |
| `deploy` | Deploy to Vercel, poll until ready |
| `db_exec` | Execute raw SQL |
| `db_schema` | Create tables from shorthand + RLS |
| `auth_setup` | Enable auth providers |
| `env_set` | Set environment variables |
| `storage_create` | Create storage bucket |
| `status` | Query project status |
| `destroy` | Delete project (requires confirm) |

## Installation

```bash
./install.sh
```

This copies the skill to `~/.claude/skills/backend-forge/SKILL.md`.

## Uninstall

```bash
./uninstall.sh
```

## Stack

| Layer | Default | Alternatives |
|-------|---------|-------------|
| Hosting | Vercel (via MCP) | Netlify, Railway, Fly.io |
| Database | Supabase | Neon, PlanetScale, Turso |
| Auth | Supabase Auth | Clerk, Auth0 |
| Storage | Supabase Storage | Cloudflare R2, Uploadthing |

See `alternatives.md` for setup details.

## License

MIT
