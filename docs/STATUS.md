# Plainspeak build status

Updated 7 October 2026. Original handoff commit: `20e1084`.

## Implemented

- Validated YAML rules with per-app/channel/person/thread/domain overrides and line limits.
- Read-only Obsidian vault search/note MCP tools, configured locally for this Mac.
- Local authenticated HTTP capture/result service, channel notifications and MCP image/show tools.
- Correlated results retained for late overlay connections; one active capture, two-minute timeout.
- Private temporary screenshots removed on reply, timeout and orderly shutdown.
- Hammerspoon read/draft/context hotkeys and floating overlay; draft result copied, never sent.
- Persistent interactive Opus xhigh tmux session, startup/stop/attach/status scripts.
- Login startup installed on this Mac. Hammerspoon module installed without overwriting existing config.
- README with usage, rules, context setup, privacy, quota and platform limits.

## Verified on this Mac

- `bun test`: 20 pass, zero fail, including a real stdio MCP client/server smoke test.
- `bun run typecheck`: pass.
- Shell syntax checks and Lua parser: pass.
- Local health endpoint responds; custom channel appears in Claude's interactive session.
- Synthetic capture reached the channel. Opus could not reply because the signed-in
  Team account exhausted its session allowance; terminal reports reset at 20:20 London time.
- Browser overlay check passes: result rendering treats HTML literally and enables copying.
- No model API key used. Startup removes inherited API/provider environment overrides.
- Temporary tokens, screenshots and personal rules are excluded from Git.

## Remaining live checks

- Grant Hammerspoon Accessibility and Screen Recording in macOS, reload its config,
  then test R against a fictional message. The actual native capture/overlay has
  not been exercised end to end; no claim of full desktop verification.
- Test a real Opus result after the allowance resets. Account policy permitted
  registering the channel, but a successful model response is still unverified.
- Google Drive, Gmail and Slack report connected in Claude MCP health checks.
  Local vault index reads succeed through the read-only vault module. Verify an
  Opus-grounded context response with G after quota resets; no automatic thread-ID
  lookup or new remote connectors were provisioned.
- Feature video: 36-second silent preview at http://localhost:3002/#project/plainspeak.
  Final check: zero runtime/layout/motion errors, 112/112 contrast checks pass;
  five non-blocking lint recommendations to split scenes into sub-compositions.
  Review sheet inspected. Preview approved and MP4 exported to
  `videos/plainspeak/renders/plainspeak.mp4`: 36.0s, 1920×1080, 30fps, silent.
  Export verified with ffprobe; rendered binaries remain local and ignored by Git.

## Deliberate limits

macOS front end, Claude only. No polling, automatic sending, GPT/Grok worker,
Windows/Linux overlay, or guaranteed cache/usage savings. Per-person/thread rules
use model interpretation of visible identity; line limits are prompt instructions.
Unknown source identity skips the conditional rule. Context reads may require
approval in the attached terminal. launchd launches tmux at login; it does not
supervise the Claude child or restart it after quota exhaustion.
