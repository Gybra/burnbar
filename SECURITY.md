# Security

BurnBar is local-first. Session logs stay on disk. The only network calls are
quota lookups to the provider you already logged into.

## Allowlist

| Host | When |
|---|---|
| `api.anthropic.com` | Claude usage / header probe / profile |
| `platform.claude.com` | Claude OAuth refresh |
| `chatgpt.com` | Codex usage |
| `auth.openai.com` | Codex OAuth refresh |
| `auth.x.ai` | Grok OAuth refresh |
| `cli-chat-proxy.grok.com` | Grok billing |
| `api.github.com` | Copilot `/copilot_internal/user` |
| `oauth2.googleapis.com` | Antigravity token refresh |
| `cloudcode-pa.googleapis.com` | Antigravity quota |

No other host. No Sparkle feed. No Discord. No LiteLLM/OpenRouter fetch.
`TOKSCALE_PRICING_CACHE_ONLY=1` is set at process start; the vendored engine
never calls `PricingService::get_or_init` on the local graph path.

## Credentials

Quota needs tokens the CLIs already wrote:

- Keychain `Claude Code-credentials` (`/usr/bin/security`)
- `~/.claude/.credentials.json`
- Codex / Grok / Google oauth files
- OpenCode Copilot token

Refresh may **write back** a new access token to those same files. BurnBar does
not send them anywhere except the matching provider.

## What we removed from TokenBar

- Sparkle auto-update (Nanako’s signing key)
- Discord Rich Presence
- Homebrew `xattr -d com.apple.quarantine`
- LiteLLM / OpenRouter pricing download
- Install-count badge, Patreon, Tauri migration

## Reporting

Open a GitHub issue. Do not file a public issue with live tokens.
