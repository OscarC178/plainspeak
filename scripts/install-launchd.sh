#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$HOME/Library/LaunchAgents"
python3 - "$ROOT" "$HOME/Library/LaunchAgents/com.oscarc.plainspeak.plist" <<'PY'
import pathlib, plistlib, sys
root, target = sys.argv[1:]
payload = {'Label': 'com.oscarc.plainspeak', 'ProgramArguments': ['/bin/bash', root+'/daemon/start.sh'], 'WorkingDirectory': root, 'RunAtLoad': True, 'StandardOutPath': root+'/.local/launchd.log', 'StandardErrorPath': root+'/.local/launchd.log'}
pathlib.Path(root+'/.local').mkdir(mode=0o700, exist_ok=True)
pathlib.Path(target).write_bytes(plistlib.dumps(payload))
PY
plutil -lint "$HOME/Library/LaunchAgents/com.oscarc.plainspeak.plist"
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.oscarc.plainspeak.plist"
echo 'Login startup enabled. launchd starts tmux once; it does not supervise the Claude child.'
