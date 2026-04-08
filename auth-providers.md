# Auth Providers — Setup Guide

> Add social login to any project. One-time setup per provider — works across all projects.

## How it works

```
1. Create OAuth app on provider console     (one-time)
2. Add credentials to secrets.env           (one-time)
3. auth_setup picks them up automatically   (every project)
```

**You do step 1-2 once. After that, every new project gets social login with zero effort.**

---

## Quick start

### 1. Open secrets file

```bash
nano ~/.claude/secrets/secrets.env
```

### 2. Add the AUTH section (copy-paste, fill in your values)

```bash
# --- AUTH PROVIDERS ---
# Sadece kullanmak istediklerini doldur, geri kalanini bos birak veya sil

# Google — https://console.cloud.google.com/apis/credentials
AUTH_GOOGLE_CLIENT_ID=
AUTH_GOOGLE_CLIENT_SECRET=

# Facebook — https://developers.facebook.com/apps
AUTH_FACEBOOK_CLIENT_ID=
AUTH_FACEBOOK_CLIENT_SECRET=

# Apple — https://developer.apple.com/account/resources/identifiers
AUTH_APPLE_CLIENT_ID=
AUTH_APPLE_SECRET=

# GitHub — https://github.com/settings/developers
AUTH_GITHUB_CLIENT_ID=
AUTH_GITHUB_CLIENT_SECRET=

# Twitter/X — https://developer.twitter.com/en/portal/projects
AUTH_TWITTER_CLIENT_ID=
AUTH_TWITTER_CLIENT_SECRET=

# Discord — https://discord.com/developers/applications
AUTH_DISCORD_CLIENT_ID=
AUTH_DISCORD_CLIENT_SECRET=

# LinkedIn — https://www.linkedin.com/developers/apps
AUTH_LINKEDIN_CLIENT_ID=
AUTH_LINKEDIN_CLIENT_SECRET=

# Spotify — https://developer.spotify.com/dashboard
AUTH_SPOTIFY_CLIENT_ID=
AUTH_SPOTIFY_CLIENT_SECRET=

# Twitch — https://dev.twitch.tv/console/apps
AUTH_TWITCH_CLIENT_ID=
AUTH_TWITCH_CLIENT_SECRET=

# Slack — https://api.slack.com/apps
AUTH_SLACK_CLIENT_ID=
AUTH_SLACK_CLIENT_SECRET=

# Notion — https://www.notion.so/my-integrations
AUTH_NOTION_CLIENT_ID=
AUTH_NOTION_CLIENT_SECRET=

# GitLab — https://gitlab.com/-/profile/applications
AUTH_GITLAB_CLIENT_ID=
AUTH_GITLAB_CLIENT_SECRET=

# Azure/Microsoft — https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps
AUTH_AZURE_CLIENT_ID=
AUTH_AZURE_CLIENT_SECRET=

# Bitbucket — https://bitbucket.org/account/settings/app-passwords
AUTH_BITBUCKET_CLIENT_ID=
AUTH_BITBUCKET_CLIENT_SECRET=

# Keycloak (self-hosted)
AUTH_KEYCLOAK_CLIENT_ID=
AUTH_KEYCLOAK_CLIENT_SECRET=
AUTH_KEYCLOAK_URL=
```

### 3. Save and push

```bash
cd ~/.claude/secrets && git add -A && git commit -m "add auth providers" && git push
```

### 4. Use in any project

```json
{ "project": "myapp", "providers": ["email", "google", "github"] }
```

Credentials are picked up automatically. Done.

---

## Callback URL

When creating OAuth apps, you need a **redirect/callback URL**. It's always:

```
https://<your-supabase-ref>.supabase.co/auth/v1/callback
```

Replace `<your-supabase-ref>` with your Supabase project reference ID (found in project settings).

> For local development, also add `http://localhost:3000` as a redirect URI in the provider console.

---

## Provider setup — step by step

### Google

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create project (or select existing)
3. **APIs & Services → Credentials → Create Credentials → OAuth client ID**
4. Application type: **Web application**
5. Name: anything (e.g. "My App Auth")
6. Authorized redirect URIs → **Add URI** → paste callback URL
7. Click **Create** → copy **Client ID** and **Client Secret**
8. Paste into `secrets.env` as `AUTH_GOOGLE_CLIENT_ID` and `AUTH_GOOGLE_CLIENT_SECRET`

### Facebook

1. Go to [Meta for Developers](https://developers.facebook.com/apps)
2. **Create App → Other → Consumer → Next**
3. App name: anything → **Create App**
4. Find **Facebook Login** → **Set Up** → **Web**
5. Skip the quickstart, go to **Settings** (left menu under Facebook Login)
6. Valid OAuth Redirect URIs → paste callback URL → **Save**
7. Go to **App Settings → Basic** (left menu) → copy **App ID** and **App Secret**
8. Paste into `secrets.env` as `AUTH_FACEBOOK_CLIENT_ID` and `AUTH_FACEBOOK_CLIENT_SECRET`

### Apple

> Requires paid Apple Developer account ($99/year). Most complex provider.

1. Go to [Apple Developer — Identifiers](https://developer.apple.com/account/resources/identifiers)
2. **Register an App ID** → enable "Sign In with Apple"
3. **Register a Services ID** (Identifiers → + → Services IDs)
4. Configure: add your domain + callback URL
5. **Create a Key** (Keys → +) → enable "Sign In with Apple" → download `.p8` file
6. You need: Services ID (= client_id), Team ID, Key ID
7. Base64-encode the .p8 file contents: `base64 -i AuthKey_XXXXX.p8`
8. Paste into `secrets.env`:
   - `AUTH_APPLE_CLIENT_ID` = Services ID
   - `AUTH_APPLE_SECRET` = base64-encoded .p8 key content

### GitHub

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. **OAuth Apps → New OAuth App**
3. Application name: anything
4. Homepage URL: your app URL
5. Authorization callback URL → paste callback URL
6. **Register application** → copy **Client ID**
7. **Generate a new client secret** → copy it
8. Paste into `secrets.env`

### Twitter / X

1. Go to [Twitter Developer Portal](https://developer.twitter.com/en/portal/projects)
2. Create a project → create an app inside it
3. **App Settings → User authentication settings → Set up**
4. Enable **OAuth 2.0**
5. Type: **Web App**
6. Callback URL → paste callback URL
7. Website URL → your app URL
8. **Save** → go to **Keys and tokens** tab
9. Under OAuth 2.0 → copy **Client ID** and **Client Secret**
10. Paste into `secrets.env`

### Discord

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. **New Application** → name it → **Create**
3. Left menu → **OAuth2**
4. **Add Redirect** → paste callback URL → **Save**
5. Copy **Client ID** (from OAuth2 page) and **Client Secret** (click Reset Secret)
6. Paste into `secrets.env`

### LinkedIn

1. Go to [LinkedIn Developers](https://www.linkedin.com/developers/apps)
2. **Create App** → fill company page (create one if needed)
3. **Auth** tab → OAuth 2.0 settings
4. Authorized redirect URLs → add callback URL
5. Copy **Client ID** and **Primary Client Secret**
6. Paste into `secrets.env`

### Spotify

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. **Create App** → name + description → set Redirect URI to callback URL
3. **Settings** → copy **Client ID** and **Client Secret**
4. Paste into `secrets.env`

### Twitch

1. Go to [Twitch Developer Console](https://dev.twitch.tv/console/apps)
2. **Register Your Application**
3. OAuth Redirect URLs → add callback URL
4. Category: pick any
5. **Create** → click **Manage** → copy **Client ID**
6. **New Secret** → copy it
7. Paste into `secrets.env`

### Slack

1. Go to [Slack API](https://api.slack.com/apps)
2. **Create New App → From scratch** → pick a workspace
3. Left menu → **OAuth & Permissions** → Redirect URLs → add callback URL
4. Left menu → **Basic Information** → App Credentials
5. Copy **Client ID** and **Client Secret**
6. Paste into `secrets.env`

### Notion

1. Go to [Notion Integrations](https://www.notion.so/my-integrations)
2. **New integration** → name it
3. Change type to **Public** (required for OAuth)
4. OAuth Domain & URIs → Redirect URI → paste callback URL
5. Copy **OAuth client ID** and **OAuth client secret**
6. Paste into `secrets.env`

### GitLab

1. Go to [GitLab Applications](https://gitlab.com/-/profile/applications)
2. Name: anything
3. Redirect URI → paste callback URL
4. Scopes: check **read_user**
5. **Save application** → copy **Application ID** and **Secret**
6. Paste into `secrets.env`

### Azure / Microsoft

1. Go to [Azure App Registrations](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps)
2. **New registration** → name it
3. Redirect URI: platform **Web** → paste callback URL → **Register**
4. Copy **Application (client) ID** from overview
5. Left menu → **Certificates & secrets → New client secret** → copy **Value**
6. Paste into `secrets.env`

### Bitbucket

1. Go to [Bitbucket Settings — OAuth consumers](https://bitbucket.org/account/settings/app-passwords)
2. **Add consumer** → name it
3. Callback URL → paste callback URL
4. Permissions: check **Account — Read**
5. **Save** → copy **Key** (= client_id) and **Secret**
6. Paste into `secrets.env`

### Keycloak

1. Open your Keycloak admin console
2. Select realm → **Clients → Create**
3. Client ID: pick a name, Client Protocol: openid-connect
4. Settings → Valid Redirect URIs → add callback URL
5. **Credentials** tab → copy **Client Secret**
6. Paste into `secrets.env` + set `AUTH_KEYCLOAK_URL=https://your-keycloak.com/realms/your-realm`

---

## Common mistakes

| Problem | Fix |
|---------|-----|
| "redirect_uri_mismatch" | Callback URL must match exactly — check trailing slash |
| "invalid_client" | Wrong client_id or client_secret — re-copy from provider console |
| Provider not showing | Check Supabase dashboard → Auth → Providers |
| Apple not working | Requires $99/yr Apple Developer account + correct .p8 key |
| Localhost redirect fails | Add `http://localhost:3000` as separate redirect URI |
| secrets.env not picked up | Run `cd ~/.claude/secrets && git pull` to sync |
