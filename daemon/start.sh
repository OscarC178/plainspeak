#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$HOME/.local/bin:$HOME/.bun/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
for tool in tmux claude bun; do command -v "$tool" >/dev/null || { echo "Missing $tool" >&2; exit 1; }; done
if tmux has-session -t '=plainspeak' 2>/dev/null; then echo 'Plainspeak session already exists.'; exit 0; fi
# Quote each word before handing the command to tmux's shell. No -p or API key.
printf -v invocation '%q ' claude --model "${PLAINSPEAK_MODEL:-opus}" --effort xhigh --name plainspeak --permission-mode default --settings "$ROOT/daemon/claude-settings.json" --dangerously-load-development-channels server:plainspeak
# Prevent inherited API credentials from selecting API billing instead of the user's login.
unset ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_USE_BEDROCK CLAUDE_CODE_USE_VERTEX CLAUDE_CODE_USE_FOUNDRY || true
tmux new-session -d -s plainspeak -c "$ROOT" -x 140 -y 45 "env -u ANTHROPIC_API_KEY -u ANTHROPIC_AUTH_TOKEN -u CLAUDE_CODE_USE_BEDROCK -u CLAUDE_CODE_USE_VERTEX -u CLAUDE_CODE_USE_FOUNDRY $invocation"
echo 'Plainspeak started. Run bun run daemon:attach to complete first-run trust/channel prompts.'
