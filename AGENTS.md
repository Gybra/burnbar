# BurnBar — agent & contributor guide

BurnBar is a native macOS menu-bar app that shows local AI token usage and
provider quota. It is a Gybra-owned MIT fork of
[TokenBar](https://github.com/Nanako0129/TokenBar).

This file is the source of truth for how work lands. `docs/knowledge/` is
upstream history; do not treat it as current process.

## Network policy (non-negotiable)

Nothing leaves the machine except **official provider quota APIs**, and only
when the matching local OAuth credentials already exist:

| Allowed | Why |
|---|---|
| `api.anthropic.com` | Claude quota / token refresh |
| `platform.claude.com` | Claude OAuth refresh |
| `chatgpt.com` / `auth.openai.com` | Codex quota / refresh |
| `auth.x.ai` / `cli-chat-proxy.grok.com` | Grok quota / refresh |
| `api.github.com/copilot_internal/user` | Copilot quota |
| `oauth2.googleapis.com` / `cloudcode-pa.googleapis.com` | Antigravity quota / refresh |

Forbidden: telemetry, Discord, Sparkle/appcast, LiteLLM, OpenRouter, Patreon,
any Gybra/GitHub phone-home. Session logs never upload.

Pricing uses a **local cache only** (`TOKSCALE_PRICING_CACHE_ONLY=1` plus an
engine patch). Missing cache ⇒ unpriced rows; provider-reported costs still
show.

If a PR adds a URL or HTTP client, it needs an issue that names the host and
why it is on the allowlist. Default answer is no.

## Development flow

Every change follows this loop. Do not skip a gate.

1. **Issue** — open a GitHub issue first. One problem, one issue. Label it.
2. **Branch** — `git checkout -b issue-N-short-slug` from `main`.
3. **Fix** — smallest diff that solves the issue. See “Code”.
4. **Review (Grok 4.6)** — before opening a PR, review the diff with
   **Grok 4.6, thinking, effort high**, in the **right pane**. Address every
   finding or reply why it is wrong. Paste a short review note on the PR.
5. **PR** — one PR per issue. Title: `fix(#N): …` / `feat(#N): …` /
   `chore(#N): …`. Body links the issue (`Closes #N`).
6. **CI** — GitHub Actions must be green (`build`, `--selftest`, `--smoke`).
   No merge with failing checks.
7. **Merge** — squash or rebase onto `main` only after CI is green and the
   Grok review note is on the PR.
8. **Release** — version bump is a separate tagged commit on `main`:
   - bump `CFBundleShortVersionString` via the release workflow input / tag
   - tag `vX.Y.Z` (semver)
   - pushing the tag publishes a GitHub Release with `BurnBar.app.tar.gz`
   - no auto-update channel

Hotfixes still get an issue.

## Code

- Swift 6, macOS 14+, Apple Silicon. Rust staticlib in `crates/tb_core_ffi`,
  engine vendored at `vendor/tokscale-core` (pinned snapshot, not a live
  submodule).
- Do not reformat files you did not touch.
- Do not add Sparkle, Discord wiring, or analytics.
- Prefer the existing TokenBarCore types over new abstractions.
- User-facing name is **BurnBar**. Bundle id `com.gybra.burnbar`. The Swift
  executable target is still `TokenBar` (historical); do not rename it in a
  drive-by.

```
make            # cargo --release && swift build
make run
make selftest   # required before PR
swift run TokenBar --smoke
```

## PR checklist

- [ ] Issue linked
- [ ] `make selftest` passed locally (English: `-AppleLanguages "(en)"`)
- [ ] No new outbound hosts
- [ ] Grok 4.6 thinking/high review done (right pane), notes on the PR
- [ ] CI green
