# Plainspeak build status

Updated 7 October 2026. Original handoff commit: `20e1084`.

## Implemented

- Validated YAML rules with per-app/channel/person/thread/domain overrides and line limits.
- Local authenticated HTTP capture/result service, channel notifications and MCP image/show tools.
- Correlated results retained for late overlay connections; one active capture, two-minute timeout.
- Private temporary screenshots removed on reply, timeout and orderly shutdown.
- Hammerspoon read/draft/context hotkeys and floating overlay; draft result copied, never sent.
- Persistent interactive Opus xhigh tmux session, startup/stop/attach/status scripts.
- Login startup installed on this Mac. Hammerspoon module installed without overwriting existing config.
- README with usage, rules, context setup, privacy, quota and platform limits.

## Verified on this Mac

- `bun test`: 19 pass, zero fail, including a real stdio MCP client/server smoke test.
- `bun run typecheck`: pass.
- Shell syntax checks and Lua parser: pass.
- Local health endpoint responds; custom channel appears in Claude's interactive session.
- Synthetic capture reached the channel. Opus could not reply because the signed-in
  Team account exhausted its session allowance; terminal reports reset at 20:20 London time.
- No model API key used. Startup removes inherited API/provider environment overrides.
- Temporary tokens, screenshots and personal rules are excluded from Git.

## Remaining live checks

- Grant Hammerspoon Accessibility and Screen Recording in macOS, reload its config,
  then test R against a fictional message. The actual native capture/overlay has
  not been exercised end to end; no claim of full desktop verification.
- Test a real Opus result after the allowance resets. Account policy permitted
  registering the channel, but a successful model response is still unverified.
- Configure/authenticate Obsidian and Google Drive MCP sources in Claude; verify
  a context lookup with G. No automatic thread-ID lookup or new connectors were provisioned.
- Review the feature-video preview before rendering: the video skill requires approval.

## Deliberate limits

macOS front end, Claude only. No polling, automatic sending, GPT/Grok worker,
Windows/Linux overlay, or guaranteed cache/usage savings. Per-person/thread rules
use model interpretation of visible identity; line limits are prompt instructions.
Unknown source identity skips the conditional rule. Context reads may require
approval in the attached terminal. launchd launches tmux at login; it does not
supervise the Claude child or restart it after quota exhaustion.
