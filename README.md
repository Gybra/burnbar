# BurnBar

Native macOS menu bar for **local** AI token usage and **provider quota**.

Fork of [TokenBar](https://github.com/Nanako0129/TokenBar) (MIT), owned by
[Gybra](https://github.com/Gybra). Same Swift + Rust engine, without auto-update,
Discord, telemetry, or a Homebrew cask that strips Gatekeeper quarantine.

**Requires** Apple Silicon, macOS 14+.

## What it does

- Reads session logs already on disk (Claude Code, Codex, Cursor, OpenCode, …)
- Shows today’s tokens, cost, live tokens/min, and remaining quota in the menu bar
- Quota cards call **only** the official provider APIs, using OAuth tokens the
  corresponding CLI already stored (Keychain / `~/.claude`, `~/.codex`, …)
- Transcripts never leave the Mac

See [SECURITY.md](SECURITY.md) for the network allowlist.

## Install (from source)

```sh
git clone https://github.com/Gybra/burnbar.git
cd burnbar
make
make run
```

Packaged app:

```sh
scripts/bundle.sh 0.1.0 1
open dist/BurnBar.app
```

The `.app` is ad-hoc signed. First launch: System Settings → Privacy & Security
→ Open Anyway. BurnBar does **not** strip `com.apple.quarantine` for you.

## Build

```
make            # cargo build --release && swift build
make selftest   # logic suite
swift run TokenBar --smoke
```

Rust first, then Swift. Run `swift build` from the repo root (`Package.swift`
uses a relative `-L target/release`).

## Credits

- [tokscale](https://github.com/junhoyeo/tokscale) by Junho Yeo — parsing & pricing
- [TokenBar](https://github.com/Nanako0129/TokenBar) by Nanako0129 — native shell
- [tokcat](https://github.com/handlecusion/tokcat) — menu-bar form
- [RunCat](https://kyome.io/runcat/) by Takuto Nakamura — the running cat
- [CodexBar](https://github.com/steipete/CodexBar) by Peter Steinberger — quota cards

MIT. See [LICENSE](LICENSE).

## Contributing

Read [AGENTS.md](AGENTS.md) before opening a PR. Flow: issue → branch → GPT-6.1 Sol
review (thinking, effort high, right pane) → PR → CI green → merge → tagged
release.
