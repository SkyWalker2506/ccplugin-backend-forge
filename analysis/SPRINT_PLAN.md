# ccplugin-backend-forge — Sprint Plan
> Generated: 2026-04-08 | Source: Project Analysis (4 categories)
> Jira Project: BEFORGE | Sprints: 3 (2-week each)

---

## Sprint Özeti

| Sprint | Odak | SP | Task |
|--------|------|----|------|
| 1 | Security & Critical Fixes | 18 | 9 |
| 2 | Architecture & Quality | 17 | 8 |
| 3 | Business & Competitive | 13 | 8 |
| **Toplam** | | **48** | **25** |

---

## Sprint 1 — Security & Critical Fixes (P0/P1)

| # | Summary (EN) | Label | Pri | SP | Kaynak |
|---|-------------|-------|-----|-----|--------|
| 1 | Add SQL injection blacklist for db_exec command | security | P0 | 2 | #7-K1 ✅ done |
| 2 | Enforce chmod 600/700 on secrets directory in install.sh | security | P0 | 1 | #7-K4 ✅ done |
| 3 | Change destroy confirm from boolean to project name match | security | P0 | 1 | #7-K2 ✅ done |
| 4 | Remove access_token field from state-template.json | security | P0 | 1 | #7-K5 ✅ done |
| 5 | Remove or mask inline credential support in auth_setup | security | P1 | 2 | #7-K3 |
| 6 | Add secret encryption at rest (age/sops) | security | P1 | 2 | #7-İ1 |
| 7 | Add audit logging for command invocations | security | P1 | 2 | #7-İ2 |
| 8 | Add rate limiting / quota control per command | security | P1 | 2 | #7-İ3 |
| 9 | Add SECURITY.md with credential management policy | security | P1 | 1 | #12-KO4 |

> ✅ done = önceki commit'te düzeltildi. Jira'ya "Done" olarak girilecek.

**Sprint 1 Toplam: 14 SP (4 done + 10 remaining)**

---

## Sprint 2 — Architecture & Quality (P0/P1/P2)

| # | Summary (EN) | Label | Pri | SP | Kaynak |
|---|-------------|-------|-----|-----|--------|
| 10 | Fix state-template projects format: array → object | arch | P0 | 1 | #10-KD1 ✅ done |
| 11 | Fix SKILL.md frontmatter name: infra-agent → backend-forge | arch | P0 | 1 | #10-KD2 ✅ done |
| 12 | Define JSON Schema for all command inputs/outputs | arch | P1 | 2 | #10-K1 |
| 13 | Add state migration mechanism (version upgrade logic) | arch | P1 | 1 | #10-K3 |
| 14 | Add version check to install.sh (--force flag) | arch | P2 | 1 | #10-K4 |
| 15 | Create smoke test / integration test script | arch | P2 | 2 | #10-İ1 |
| 16 | Set up CI pipeline (shellcheck, markdown lint, schema) | arch | P2 | 1 | #10-İ2 |
| 17 | Add CHANGELOG.md + semver tagging | arch | P2 | 1 | #10-İ3 |

**Sprint 2 Toplam: 10 SP (2 done + 8 remaining)**

---

## Sprint 3 — Business & Competitive (P1/P2/P3)

| # | Summary (EN) | Label | Pri | SP | Kaynak |
|---|-------------|-------|-----|-----|--------|
| 18 | Add "Why backend-forge?" comparison section to README | growth | P1 | 1 | #12-K1 |
| 19 | Set up GitHub Sponsors + OpenCollective | monetization | P1 | 1 | #5-K1 |
| 20 | Add anonymous opt-in telemetry (install count, cmd usage) | analytics | P1 | 2 | #5-K3 |
| 21 | Create agent framework compatibility matrix | growth | P2 | 2 | #12-İ2 |
| 22 | Publish benchmark report (tokens/seconds per deploy) | growth | P2 | 2 | #12-İ1 |
| 23 | Add dry-run mode for all commands | arch | P2 | 2 | #10-İ4 |
| 24 | Document premium tier candidates (Open Core plan) | monetization | P2 | 1 | #5-K4 |
| 25 | Add multi-channel distribution (npm, brew, GH Releases) | growth | P3 | 2 | #5-KD3 |

**Sprint 3 Toplam: 13 SP**

---

## Backlog (Nice-to-Have — gelecek sprint'ler)

| Summary (EN) | Label | SP |
|-------------|-------|-----|
| Add rollback command (revert to previous deployment) | arch | 2 |
| Add template system (nextjs+auth, api-only, static) | arch | 3 |
| Add multi-environment support (staging/production) | arch | 3 |
| Add webhook/notification on deploy complete | arch | 2 |
| Add cost estimation command | arch | 2 |
| Provider plugin system (standard interface for new providers) | arch | 3 |
| macOS Keychain / 1Password CLI integration for secrets | security | 3 |
| Command-level RBAC (agent permissions) | security | 3 |
| Managed SaaS tier (credentials dashboard) | monetization | 5 |
| MCP server publication (beyond Claude Code) | growth | 3 |
| Plugin SDK / extension API | arch | 5 |
