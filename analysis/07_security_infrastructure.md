## #7 Security & Infrastructure Analiz Raporu
> Lead: A13 SecLead | Worker: B13 Security Auditor | Model: Opus 4.6

### Mevcut Durum

**Guclul yanlar:**
- Secret'lar kod reposunda degil, ayri `~/.claude/secrets/` dizininde tutuluyor — separation of concerns saglanmis
- `install.sh` ve `uninstall.sh` `set -euo pipefail` kullaniyor — hata yonetimi iyi
- State template'te gercek secret degerleri yok (sadece `null` placeholder'lar)
- Vercel entegrasyonu token gerektirmiyor (MCP uzerinden)
- Secret resolution hiyerarsisi mantikli: env dosyasi > inline override > hata
- `.secrets/state.json` local tutularak uzak sunucuya secret sizintisi onleniyor
- Proje bazli secret izolasyonu var (`projects/{name}.env`)

**Puan: 5/10**

Temel secret ayirimi yapilmis ancak runtime guvenlik, input validasyonu, encryption, audit logging ve access control eksik.

---

### Kritik Eksikler (hemen yapilmali)

| # | Sorun | Etki | Cozum | Efor |
|---|-------|------|-------|------|
| 1 | **`db_exec` SQL injection riski** — Kullanici/agent'tan gelen raw SQL dogrudan Supabase API'ye gonderiliyor, hicbir sanitizasyon veya whitelist yok | High | Tehlikeli SQL komutlarini (DROP DATABASE, GRANT, ALTER ROLE vb.) blacklist'le. Sadece belirli schema'lara erisim izni ver. Prepared statement kullan veya en azindan dangerous keyword filtresi ekle | M |
| 2 | **`destroy` komutu tek boolean ile proje siliyor** — `confirm: true` yeterli, ek dogrulama yok | High | Proje adini tekrar girmesini iste (`confirm: "proje-adi"` seklinde). Cooldown suresi ekle (ornegin 30 saniye bekleme) | S |
| 3 | **Inline credentials log'a/konusmaya sizabilir** — `auth_setup` ve `credentials` inline olarak JSON'da acikcasi gecebiliyor, agent konusmasi log'lanirsa secret'lar gorunur | High | Inline credential destegini kaldir veya sadece env dosyasindan okumaya zorla. Agent ciktisinda credential degerlerini maskele (`***`) | M |
| 4 | **secrets.env dosya izinleri kontrol edilmiyor** — Dosya 644 olabilir, baska kullanicilar okuyabilir | High | `install.sh` icerisinde `chmod 600 ~/.claude/secrets/secrets.env` ve `chmod 700 ~/.claude/secrets/` ekle. Runtime'da izin kontrolu yap | S |
| 5 | **state-template.json'da `access_token` ve `org_id` alanlari var** — State dosyasi git'e commit edilirse token sizabilir | High | `access_token` alanini state'ten cikar, sadece secrets.env'den oku. state.json'u `.gitignore`'a ekle. Template'ten hassas alanlari kaldir | S |

---

### Iyilestirme Onerileri (planli)

| # | Oneri | Etki | Cozum | Efor |
|---|-------|------|-------|------|
| 1 | **Secret encryption at rest** — secrets.env duz metin olarak duruyor | Med | `age` veya `sops` ile encrypt et. Decrypt islemi runtime'da yapilsin | M |
| 2 | **Audit logging** — Hangi komutun ne zaman calistirildigina dair log yok | Med | Her komut cagrisini timestamp + komut adi + proje adi ile `~/.claude/secrets/.audit.log` dosyasina yaz (secret degerleri haric) | M |
| 3 | **Rate limiting / quota kontrolu** — Bir agent sinirsiz API cagrisi yapabilir | Med | Komut basina dakikalik limit koy (ornegin `destroy` icin 1/saat). State'e son cagri zamanini yaz | M |
| 4 | **Input validation schema** — Komut girdileri icin JSON schema dogrulamasi yok | Med | Her komut icin JSON Schema tanimla, gecersiz input'u reject et | M |
| 5 | **Secret rotation rehberi** — Token'larin ne zaman expire olacagi veya nasil rotate edilecegi belirtilmemis | Low | `secrets.md` rehberine rotation takvimi ve adimlari ekle | S |
| 6 | **install.sh integrity check** — Script degistirilmis mi kontrolu yok | Low | Checksum dogrulamasi veya GPG imzasi ekle | M |

---

### Kesin Olmali (industry standard)

- Secret dosyalari icin dosya izinleri (600/700) zorunlu olmali
- `.gitignore` icerisinde `state.json`, `*.env`, `.secrets/` olmali
- SQL injection korumalari (en azindan blacklist + parameterized queries)
- Destroy gibi yikici islemler icin cift dogrulama (proje adi + confirm)
- Secret degerlerinin log/output'a yazilmamasi garanti edilmeli

### Kesin Degismeli (mevcut sorunlar)

- `state-template.json`'daki `access_token` alani kaldirilmali — secret'lar state'te tutulmamali
- `auth-providers.md`'deki `git add -A && git commit && git push` ornegi tehlikeli — yanlis dizinde calistirilirsa tum dosyalari push'layabilir. `git add secrets.env` olarak degistirilmeli
- Inline credential gecisi (`credentials` parametresi) ya kaldirilmali ya da zorunlu olarak maskelenmeli
- `install.sh` kurulum sonrasi `~/.claude/secrets/` dizin izinlerini set etmeli

### Nice-to-Have (diferansiasyon)

- Secret backend olarak macOS Keychain / 1Password CLI entegrasyonu
- Komut bazli RBAC (bazi agent'lar sadece `status` gorebilir, `destroy` goremez)
- Otomatik secret rotation (Supabase API key refresh)
- Canary token — state.json'a gizli token koy, leak tespit et
- Signed SKILL.md — skill dosyasinin degistirilmedigini dogrula

### Referanslar

- OWASP Top 10 (A01: Broken Access Control, A03: Injection)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/platform/going-into-prod)
- [12-Factor App — Config](https://12factor.net/config)
- CIS Benchmark — File Permissions
- NIST SP 800-57 — Key Management
