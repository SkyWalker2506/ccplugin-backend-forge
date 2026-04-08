# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/).

## [1.2.0] - 2026-04-08

### Added
- `schemas/` directory with `state.schema.json` and `commands.schema.json` (uses `$ref` for dry_run deduplication)
- `VERSION` file for single-source version tracking
- `Makefile` with install, uninstall, test, and lint targets
- `CONTRIBUTING.md` with development workflow and contribution guidelines
- GitHub Actions release workflow for automated versioning
- `uninstall.sh`: `--force` flag and interactive y/N confirmation prompt
- `test.sh`: tests 9–13 covering new functionality
- `auth-providers.md`: PRIVATE repository warning added
- `.gitignore`: `forge/`, `.jira-state/`, `.claude/` entries added

### Changed
- `state-template.json` updated to v2: added `_rate`, `_telemetry`, and `preferences.telemetry` fields
- `SKILL.md` title fixed to "Backend Forge"
- `install.sh`: reads `VERSION` file for version injection, copies `schemas/`, `SECURITY.md`, and `CHANGELOG.md` to install target, fixed for-loop syntax
- `test.sh`: arithmetic fix (`PASS=$((PASS+1))`)
- `README` version badge updated to 1.2.0
- `FUNDING.yml` username fixed

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
