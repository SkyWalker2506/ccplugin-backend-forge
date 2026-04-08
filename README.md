# ccplugin-backend-forge

![claude-code](https://img.shields.io/badge/claude--code-plugin-black?style=flat-square)
![version](https://img.shields.io/badge/version-1.3.0-blue?style=flat-square)
![infra](https://img.shields.io/badge/infra-API--layer-orange?style=flat-square)
![plugin](https://img.shields.io/badge/plugin-open--source-green?style=flat-square)
[![Tests](https://github.com/SkyWalker2506/ccplugin-backend-forge/actions/workflows/ci.yml/badge.svg)](https://github.com/SkyWalker2506/ccplugin-backend-forge/actions/workflows/ci.yml)

> Part of the [Claude Code Plugin Marketplace](https://github.com/SkyWalker2506/claude-marketplace) — `./install.sh backend-forge`

Machine-callable infrastructure API layer for Claude Code. Other AI agents, MCPs, and skills call this plugin to deploy projects, create databases, configure auth, and manage environments — no human interaction needed.

## Why backend-forge?

| Feature | backend-forge | Pulumi Neo | Replit AI | v0 by Vercel | Terraform |
|---------|:---:|:---:|:---:|:---:|:---:|
| Agent-to-agent API (JSON in/out) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Claude Code native | ✅ | ❌ | ❌ | ❌ | ❌ |
| Zero-token deploy (MCP) | ✅ | ❌ | ❌ | ✅ | ❌ |
| 17 OAuth providers built-in | ✅ | ❌ | ❌ | ❌ | ❌ |
| Auto-credential resolution | ✅ | ❌ | ❌ | ❌ | ❌ |
| Full stack in one call | ✅ | ✅ | ✅ | ❌ | ❌ |
| Open source (MIT) | ✅ | ❌ | ❌ | ❌ | ✅ |
| Multi-cloud | ❌ | ✅ | ❌ | ❌ | ✅ |
| GUI/Dashboard | ❌ | ✅ | ✅ | ✅ | ❌ |

**backend-forge is built for AI agents, not humans.** Other tools require UI interaction or natural language — backend-forge speaks JSON and executes API calls directly. If you're building Claude Code agents that need to provision infrastructure, this is the only tool designed for that exact use case.

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
| `setup_check` | Verify tokens, CLI tools, and env configuration |
| `create_project` | Create Vercel + Supabase project, wire env vars |
| `deploy` | Deploy to Vercel, poll until ready |
| `db_exec` | Execute raw SQL |
| `db_schema` | Create tables from shorthand + RLS |
| `auth_setup` | Enable auth providers (17 supported — auto-reads from secrets.env) |
| `env_set` | Set environment variables |
| `storage_create` | Create storage bucket |
| `status` | Query project status |
| `destroy` | Delete project (requires confirm) |

## Quick Start

Once installed, use `setup_check` to verify your environment, then `create_project` to bootstrap a new Vercel + Supabase stack.

**1. Verify your environment:**

```json
// Input
{ "command": "setup_check" }

// Expected output
{
  "ready": true,
  "checks": {
    "vercel_token": "ok",
    "supabase_token": "ok",
    "vercel_cli": "ok",
    "supabase_cli": "ok"
  }
}
```

**2. Bootstrap a new project:**

```json
// Input
{
  "command": "create_project",
  "name": "my-app",
  "framework": "nextjs"
}
```

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

## Compatibility

Tested with:

| Framework | Status |
|-----------|--------|
| Claude Code (native) | ✅ Fully supported |
| Claude Agent SDK | ✅ Compatible |
| LangChain / LangGraph | 🔄 Compatible (JSON tool interface) |
| CrewAI | 🔄 Compatible (custom tool wrapper) |
| AutoGen | 🔄 Compatible (function calling) |
| Any MCP client | ✅ Via MCP server mode (planned) |

> 🔄 = works via JSON in/out interface, no native integration yet

## License

MIT
