# Plainspeak

A personal plain-English overlay for messages that take too much work to read.

AI filler. Awkward wording across languages. Spelling, swapped letters and missing
words in your own drafts. Plainspeak helps you get to the meaning while staying
in the app where the conversation is happening.

**macOS MVP · Claude Code subscription login · Opus · no API keys · no automatic sending**

## Use it

| Hotkey | Action |
| --- | --- |
| Control + Option + Command + R | Capture the focused window and explain the visible message |
| Control + Option + Command + D | Correct selected draft text and copy the result to the clipboard |
| Control + Option + Command + G | Explain the visible message with context from configured read-only MCP sources |
| Escape | Close the overlay |

Reading needs no copy-and-paste. Focus a Slack or Gmail conversation and press R.
The overlay leads with the point, the request and any deadline. Ambiguity is flagged.
For writing, select your own text and press D. Review the correction, then paste
and send it yourself. It does not generate a reply from an incoming screenshot.

Slack and Gmail in Chrome are detected using window titles. Screenshot reading
also works in other apps. The operating-system capture/overlay is **macOS only**;
Windows/Linux front ends and GPT/Grok engines are not implemented.

## Install

Requirements: Bun, tmux, Hammerspoon, and Claude Code signed in with a subscription.
No Anthropic API key is used. First authenticate Claude interactively if needed.

```sh
bun install
cp rules/rules.example.yaml rules/rules.yaml
bun run rules:check
bun run install:hammerspoon
bun run daemon:start
bun run daemon:attach
```

In the Claude terminal, accept this project's trust, its local Plainspeak MCP
server and the development-channel warning. The preview warning appears on each
fresh Claude start; login startup can wait at that prompt until you attach. Detach tmux with Control+B, then D.
You need not leave a terminal window open. Open Hammerspoon, grant macOS
Accessibility and Screen Recording permissions, then select Reload Config.
The draft hotkey relies on the app exposing selected text through Accessibility;
if it does not, Plainspeak tells you rather than silently editing a whole thread.

Optional startup at login:

```sh
bun run install:launchd
```

This starts one detached tmux session at login. It does not supervise or blindly
restart Claude if it exits. Nothing is captured while you are away: there is no
polling, unread-message scraping or automatic screenshot loop.

```sh
bun run daemon:status
bun run daemon:stop
bun run uninstall:launchd
```

## Make the rules yours

Edit `rules/rules.yaml`; it is private and ignored by Git. Changes are read on the
next capture. Invalid YAML, unknown profiles or invalid line limits fail visibly.
The example includes `ai-drivel`, `esl` and `dyslexic` profiles. Assign a profile
only when you know it is appropriate; the app does not diagnose a person.

```yaml
- name: Short replies for this channel
  match: { app: slack, channel: planning }
  max_lines: 3
  instructions: Keep the decision, owner and deadline.

- name: A particular person's messages
  match: { app: slack, person: "Example Person" }
  profile: esl
  max_lines: 5

- name: This recurring thread
  match: { app: slack, thread: "Website release checklist" }
  instructions: Keep unresolved blockers and distinguish suggestions from decisions.
```

Rules go inside the existing `rules:` list. `app`, `channel`, `title` (regex),
`text` (regex) and `mode` match locally. `person`, `sender_domain` and `thread`
are conditional: Claude must identify them in the capture. These are best-effort
visual matches, not verified Slack IDs. Unknown identity means skip the rule.

Deterministic rules run in file order; later matching limits win. Within each
rule: rule limit overrides profile limit, which overrides the default. Conditional
rules are applied afterwards by Claude and may override that limit. Instructions
accumulate. `max_lines` is a model instruction, not a hard guarantee; wrapping a
long sentence can occupy more visual lines. Allowed limits: 1–30.

## Vault and Google Drive context

Plainspeak provides its own read-only vault MCP tools and also uses the MCP
servers available to its Claude session. To enable local Obsidian search, create
`.local/config.json` with your vault's absolute path (this file is ignored by Git):

```json
{"vault": "/absolute/path/to/your/vault"}
```

Restart the session after changing this path. `vault_search` returns up to eight
excerpts; `vault_note` reads a relative markdown path inside that vault. Both reject
reads outside the vault, including symlink escapes. Search is capped at 4,000 notes
and the first 16,000 characters per note; truncated coverage is reported. There is
no vault write tool. Configure/authenticate your Google Drive connector in Claude
Code; Plainspeak does not ask for model API keys or copy connector credentials.
Press G for grounded reading. Without connected sources it says context was not
checked. Source titles/links should appear alongside factual context.

Remote source tools beyond the local overlay/vault tools retain normal Claude permission
prompts: approve read access in the attached terminal. Never grant broad wildcard
write permissions. Exact tool names vary between connectors. Existing connector
credentials and service login requirements still apply; “no API keys” refers to
the model engine. A live model-grounded lookup still needs verification after any setup changes. Automatic thread lookup from a tab title is not implemented.

## Why this helps — and where it does not

| Choice | Benefit | Cost / difficulty |
| --- | --- | --- |
| Window screenshot + hotkey | Read the conversation where you already are | Captures other visible content; macOS permissions; medium setup |
| Persistent Opus session | Subscription login; one session without a new CLI process per message | Still consumes quota; context grows; may need a fresh session |
| Personal YAML rules | Adapt length and interpretation per person/thread | Visual identity can be uncertain; easy to edit |
| Explicit context hotkey | Check relevant documents without looking everything up yourself | Requires authenticated MCP sources and read approvals; medium setup |

A rewrite can still misunderstand a message. Verify dates, numbers and commitments
before acting. The output is a reading aid, not an authoritative account of intent.

## Privacy and usage

Screenshots and selected text are sent to Claude through your signed-in account.
The local bridge binds to 127.0.0.1 and authenticates capture/results with a local
owner-readable token; arbitrary websites cannot post captures. No capture content
is written to application logs. Temporary PNGs are removed after a result, timeout
or orderly shutdown; a forced crash can leave files in `.local/`. Results expire
from memory after ten minutes. Claude's own session history may retain content;
local deletion does not erase provider history. Do not capture material you cannot
share with the provider. There is no Slack/Gmail sending endpoint in this project.

Channels remain a research preview. Team/Enterprise organisations must enable them;
custom channels need the interactive development flag. A transport health response
proves the MCP server is running, **not** that Claude accepted the channel or can
answer. A two-minute timeout points you to the attached session for quota or prompts.
The starter denies local command execution/file edits and known messaging writes;
other connected tools still require normal approval. No permission bypass is used.

No promise is made about cache savings or requests per subscription window. Opus
usage, screenshots, accumulated context and MCP lookups all count. Restart the
session when context becomes unwieldy. Other engines can be added later; they are
not present in this MVP.

## Development and evidence

```sh
bun test
bunx tsc --noEmit
```

Tests cover rule matching, capture authentication, foreign-origin rejection,
request/result correlation, concurrent capture rejection, PNG lifetime, transport
failure, invalid configuration and read-only vault path boundaries. See `docs/STATUS.md` for machine verification.
The feature-video project lives in `videos/plainspeak/` and uses fictional messages.

Official references: [Claude channels](https://code.claude.com/docs/en/channels),
[channel implementation contract](https://code.claude.com/docs/en/channels-reference),
[legal and compliance](https://code.claude.com/docs/en/legal-and-compliance),
[Hammerspoon window capture](https://www.hammerspoon.org/docs/hs.window.html#snapshot),
[Hammerspoon webview](https://www.hammerspoon.org/docs/hs.webview.html).
