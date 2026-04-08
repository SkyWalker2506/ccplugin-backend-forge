# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability, please report it privately:
- Email: [create a GitHub Security Advisory](https://github.com/SkyWalker2506/claude-marketplace/security/advisories)
- Do NOT open a public issue for security vulnerabilities

## Credential Management

### How secrets are stored
- All secrets are stored in `~/.claude/secrets/secrets.env` (local, never committed)
- Project-specific secrets in `~/.claude/secrets/projects/{name}.env`
- File permissions enforced: `chmod 700` on directory, `chmod 600` on files

### What is NOT stored
- No secrets in state.json
- No secrets in SKILL.md or any committed file
- No secrets in command output or logs

### Secret resolution order
1. `secrets.env` (shared keys)
2. `projects/{name}.env` (project-specific)
3. Error with setup instructions (never falls through silently)

### Best practices
- Rotate Supabase access tokens quarterly
- Use separate OAuth apps per environment
- Never pass credentials inline — use secrets.env exclusively
- Review `.audit.log` periodically for unauthorized access

## Supported versions

| Version | Supported |
|---------|-----------|
| 1.2.x   | ✅        |
| 1.1.x   | ✅        |
| < 1.1   | ❌        |

## Scope

This policy covers the backend-forge plugin itself. For Supabase and Vercel security, refer to their respective security policies.
