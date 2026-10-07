# plainspeak build status

Session stopped on 2026-10-07 when the Claude usage limit was reached. This file is
the handoff for the next session. Delete it once the build is complete.

## Decided design (confirmed with Oscar)

- Output is for Oscar's understanding only. Nothing is ever sent back to Slack or Gmail.
- Trigger: hotkey, not clipboard. Hammerspoon grabs the focused window (snapshot +
  AX selected text), POSTs to a local channel server, shows the result in a floating
  webview overlay. Two hotkeys: ⌃⌥⌘R "read" (what do they mean), ⌃⌥⌘D "draft"
  (clean up my own text, auto-copied to clipboard).
- Slack and Gmail both run in Chrome on this Mac. App detection is from the tab title
  suffix "- Slack" / "- Gmail".
- Daemon: one persistent interactive `claude` session (Opus) in a detached tmux
  session started by launchd. Interactive is required because
  `--dangerously-load-development-channels` is ignored under `-p` during the
  channels research preview.
- No API keys. Subscription OAuth only. Allowed for personal automation per
  https://code.claude.com/docs/en/legal-and-compliance
- Rules: YAML, per person / channel / thread / sender domain / app / mode, with
  `max_lines` and stackable instructions. Deterministic keys resolved by the server,
  person-level keys handed to Claude as conditionals.

## Done

- `package.json`, `.gitignore`, `bun install` (MCP SDK + zod). tmux and Hammerspoon
  installed via Homebrew.
- `src/rules.ts` rules engine (resolve, loadRules, title parsing).
- `src/rules.test.ts`: 12 tests, all passing (`bun test`).
- `rules/rules.example.yaml` with the three profiles: ai-drivel, esl, dyslexic.

## Not done

1. (done)
2. `src/prompt.ts`: build the `<channel>` event body from Capture + Resolved.
3. `src/server.ts`: MCP server declaring `claude/channel` and
   `claude/channel/permission`, tool `show(request_id, text, kind)`, HTTP on
   127.0.0.1:8790: `POST /capture` (JSON with base64 image, writes to `captures/`),
   `GET /events` (SSE), `POST /permission`, `GET /overlay` (HTML), `GET /health`,
   `GET /rules?app=&title=` (debug). Watch `rules/rules.yaml` and reload.
   Reference: https://code.claude.com/docs/en/channels-reference
4. `.mcp.json` → `{"mcpServers":{"plainspeak":{"command":"bun","args":["src/server.ts"]}}}`
5. `CLAUDE.md` (project) persona for the daemon session.
6. `daemon/claude-settings.json`: allow `mcp__plainspeak__*`, `Read`, Slack/Gmail
   read tools; deny `mcp__plugin_slack_slack__slack_send_message*`,
   `mcp__claude_ai_Gmail__send_message`, `reply`, `forward`, `create_draft`.
7. `daemon/start.sh|stop.sh|attach.sh|status.sh`: tmux session "plainspeak" running
   `claude --model opus --name plainspeak --permission-mode auto --settings daemon/claude-settings.json --dangerously-load-development-channels server:plainspeak`
   from the repo root. `claude` lives at `/Users/oscar/.local/bin/claude`, tmux at
   `/opt/homebrew/bin/tmux`; launchd needs both on PATH.
8. `scripts/install-launchd.sh` rendering `daemon/com.oscarc.plainspeak.plist`.
9. `hammerspoon/plainspeak.lua` + `scripts/install-hammerspoon.sh` (symlink into
   `~/.hammerspoon`, append `require("plainspeak")` to init.lua).
10. Smoke test: run server standalone and `curl POST /capture`; then full e2e in tmux
    (handle the dev-channel warning dialog and the .mcp.json consent dialog by reading
    the pane). Use `--model sonnet` for the test to protect Opus quota.
11. `README.md`: problem (AI drivel, ESL senders, dyslexic text both ways), how it
    works, install, rules authoring, why it pays off, limits, privacy note that
    screenshots go to Anthropic.
12. Oscar creates the public repo himself (auto-mode classifier blocks Claude creating public surfaces):
    `gh repo create OscarC178/plainspeak --public --source . --push --description "Always-on plain-English overlay for Slack and Gmail. Hotkey, then see what they actually mean. Runs on your Claude subscription, no API keys."`
13. Launch video via the `brag:brag` skill (installed plugin), from the repo root.
