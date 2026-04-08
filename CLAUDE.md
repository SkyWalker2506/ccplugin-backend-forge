# ccplugin-backend-forge — Yönlendirici

> **Bu dosya sadece yönlendiricidir.** Tüm kurallar `~/Projects/claude-config/CLAUDE.md` dosyasındadır.

---

## Her oturum başında

1. **`~/Projects/claude-config/CLAUDE.md` dosyasını oku** ve talimatlarını uygula
2. Yanıt başında model etiketi: `(Model Adı)`
3. Dil: kullanıcıya Türkçe; kod/commit İngilizce

## Bu plugin hakkında

Machine-callable infrastructure API layer. Diğer AI agent'lar, MCP'ler ve skill'ler bu plugin'i çağırarak proje oluşturur, deploy eder, veritabanı kurar. Doğrudan kullanıcı etkileşimi için değil — agent-to-agent çalışır.

Default stack: Vercel + Supabase. Alternatifler `alternatives.md` dosyasında.

Tek giriş noktası: `install.sh`

```bash
./install.sh    # ~/.claude/skills/backend-forge/ altına skill kur
./uninstall.sh  # Kaldır
```

Kurulum sonrası `backend-forge` skill'i tüm Claude Code session'larında kullanılabilir olur.

## Komutlar

| Komut | Açıklama |
|-------|----------|
| `create_project` | Vercel + Supabase proje oluştur, env set et |
| `deploy` | Vercel deploy + poll until ready |
| `db_exec` | SQL çalıştır |
| `db_schema` | Shorthand ile tablo oluştur + RLS |
| `auth_setup` | Auth provider'ları etkinleştir |
| `env_set` | Environment variable'ları set et |
| `storage_create` | Storage bucket oluştur |
| `status` | Proje durumu sorgula |
| `destroy` | Proje sil |
