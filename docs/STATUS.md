# Plainspeak build status

Updated 7 October 2026. Original handoff commit: `20e1084`.

## Implemented

- Validated YAML rules with per-app/channel/person/thread/domain overrides and line limits.
- Read-only Obsidian vault search/note MCP tools, configured locally for this Mac.
- Local authenticated HTTP capture/result service, channel notifications and MCP image/show tools.
- Correlated results retained for late overlay connections; one active capture, two-minute timeout.
- Private temporary screenshots removed on reply, timeout and orderly shutdown.
- Hammerspoon front side button corrects visible text; back simplifies it; Command +
  back searches Obsidian and Google Drive. PS menu calibrates physical button IDs.
  Keyboard read/draft/context shortcuts retained; draft result copied, never sent.
- Persistent interactive Opus xhigh tmux session, startup/stop/attach/status scripts.
- Login startup installed on this Mac. Hammerspoon module installed without overwriting existing config.
- README with usage, rules, context setup, privacy, quota and platform limits.

## Verified on this Mac

- `bun test`: 23 pass, zero fail, including a real stdio MCP client/server smoke test.
- `bun run typecheck`: pass.
- Shell syntax checks and Lua parser: pass.
- Local health endpoint responds; custom channel appears in Claude's interactive session.
- Synthetic capture reached the channel. Opus could not reply because the signed-in
  Team account exhausted its session allowance; terminal reports reset at 20:20 London time.
- Browser overlay check passes: result rendering treats HTML literally and enables copying.
- No model API key used. Startup removes inherited API/provider environment overrides.
- Temporary tokens, screenshots and personal rules are excluded from Git.

## Remaining live checks

- Physical side-button mapping still needs the owner's check; use the PS calibration
  menu if needed. Accessibility, Screen Recording, module loading and active mouse
  listener were verified after a full Hammerspoon restart. Native dummy-text capture
  reached the MCP image/show tools, and WebKit reported the result rendered, Ready,
  with copying enabled. No screenshot was sent to Claude for this desktop test.
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

## Permission/capture fix — 7 October 2026

Hammerspoon had stayed in the original process after permissions were changed;
full restart made both permissions active. Native testing then exposed a code bug:
`hs.window.snapshot` is not a module function. Replaced it with `window:snapshot()`.
Added non-prompting permission preflight checks so clicks report missing access
rather than trying protected operations repeatedly. Temporary test configuration
was restored after the local-only dummy capture/overlay test.
