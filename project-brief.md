# ccplugin-backend-forge — Project Brief
> Oluşturuldu: 2026-04-08 | A14 DiscoveryAgent (auto)

## Özet
Machine-callable infrastructure API layer — diğer AI agent'lar bu plugin'i çağırarak Vercel + Supabase üzerinde proje oluşturur, deploy eder, veritabanı kurar.

## Platform & Hedef Kitle
- Platform: CLI plugin (Claude Code skill)
- Kullanıcı tipi: Agent-to-agent (B2B/internal)
- Hedef kitle: Claude Code kullanıcıları ve diğer AI agent'lar
- Ölçek: Claude Code marketplace kullanıcıları

## Özellikler & Kapsam
- Proje oluşturma (Vercel + Supabase)
- Deploy & poll
- SQL execution & schema shorthand
- 17 OAuth provider desteği (auto-credential resolution)
- Environment variable yönetimi
- Storage bucket oluşturma
- Proje durumu sorgulama & silme
- Alternatif provider desteği (Neon, PlanetScale, Turso, Clerk, Auth0, R2, Uploadthing)

## Monetizasyon
Open source (MIT) — ücretsiz plugin

## Auth & Veri
Supabase Auth entegrasyonu; credential'lar `~/.claude/secrets/secrets.env`'den otomatik okunur

## Tech Tercihi
Vercel (hosting) + Supabase (DB/Auth/Storage) — shell script installer, Markdown skill dosyası

## Resolved (as of v1.2.0)
- CI/CD pipeline: GitHub Actions (shellcheck, markdown lint, schema validation, smoke tests)
- Test suite: test.sh smoke tests
- Version management: VERSION file + CHANGELOG.md + semver tagging
