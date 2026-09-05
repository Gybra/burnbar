# Contributing

1. Open an **issue** first.
2. Branch from `main`: `issue-N-short-slug`.
3. Make the smallest fix. `make selftest` must pass.
4. Review the diff with **Grok 4.6 (thinking, effort high)** in the right pane.
5. Open a PR that closes the issue. Wait for CI.
6. Merge only when CI is green.
7. Releases are `vX.Y.Z` tags on `main`, not merge commits.

Full rules: [AGENTS.md](AGENTS.md). Network rules: [SECURITY.md](SECURITY.md).
