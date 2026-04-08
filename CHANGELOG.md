# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/).

## [1.1.0] - 2026-04-08

### Added
- SQL injection blacklist for `db_exec` command
- `destroy` command requires project name confirmation (not boolean)
- Secrets directory permissions enforcement in `install.sh` (chmod 600/700)
- Audit logging specification
- Rate limiting specification
- State migration mechanism
- Dry-run mode for all commands
- Telemetry (opt-in, anonymous)
- SECURITY.md credential management policy
- JSON Schema definitions for all commands
- Agent framework compatibility matrix
- "Why backend-forge?" comparison in README

### Changed
- SKILL.md frontmatter name: `infra-agent` → `backend-forge`
- `state-template.json` projects: array → object (matches SKILL.md spec)
- `auth-providers.md`: `git add -A` → `git add secrets.env`

### Removed
- `access_token` field from state-template.json
- Inline credential support in `auth_setup` (use secrets.env exclusively)

### Security
- SQL dangerous keyword blacklist (DROP DATABASE, GRANT, ALTER ROLE, etc.)
- Schema restriction: only `public` schema allowed for `db_exec`
- File permission enforcement for secrets directory

## [1.0.0] - 2026-04-07

### Added
- Initial release: create_project, deploy, db_exec, db_schema, auth_setup, env_set, storage_create, status, destroy
- 17 OAuth providers with auto-credential resolution
- Vercel + Supabase default stack
- Alternative providers documentation
