# agent-rules

Claude-first AI memory pipeline with ChatGPT Project support.

> **This repo is public.** No emails, passwords, tokens, API keys, absolute local file paths, or personal data.

## How it works: Capture → Promote → Hydrate

```
        CAPTURE                        PROMOTE                        HYDRATE
  ┌─────────────────┐           ┌─────────────────┐           ┌─────────────────┐
  │  Project repo   │           │  agent-rules    │           │                 │
  │                 │  pattern   │                 │  sync.sh   │  Claude:        │
  │  case studies   │──repeats─▶│  LEARNINGS.md   │──(auto)──▶│  ~/.claude/     │
  │  audits         │           │  (queue)        │           │    CLAUDE.md    │
  │  AGENTS.md      │           │                 │           │                 │
  │                 │  rule      │  QUALITY-GATE   │  sync.sh   │  ChatGPT:       │
  │                 │──proven──▶│  .md            │──(gen)───▶│  Project file   │
  │                 │           │                 │           │  (upload once)  │
  └─────────────────┘           └─────────────────┘           └─────────────────┘
```

## What each file does

| File | Role | Consumed by |
|------|------|-------------|
| `QUALITY-GATE.md` | Universal rules — canonical source | `sync.sh` generates all active artifacts from this |
| `LEARNINGS.md` | Promoted patterns with scope and status | `sync.sh` includes promoted patterns |
| `PROFILE.md` | User context for ChatGPT | `sync.sh` generates ChatGPT project file from this |
| `CHATGPT-PROJECT.md` | Generated context file for ChatGPT Projects | Upload into a ChatGPT Project |
| `CHATGPT-INSTRUCTIONS.md` | Generated Custom Instructions (optional fallback) | Manual paste into ChatGPT Settings |
| `templates/` | Starter files for new projects | `sync.sh` copies to `~/.claude/templates/` |
| `sync.sh` | Generates all active artifacts from source | Run after any change |

## Quick start

### Claude Code

```bash
git clone https://github.com/JSvandijk/agent-rules.git
cd agent-rules
bash sync.sh
```

Generates `~/.claude/CLAUDE.md` from source. Automatic — every new session reads it.

### ChatGPT

1. Run `bash sync.sh` (generates `CHATGPT-PROJECT.md`)
2. In ChatGPT, create a Project (e.g. "Agent Rules")
3. Upload `CHATGPT-PROJECT.md` into that Project
4. Work inside that Project — every new chat has the rules automatically

When rules change: run `sync.sh`, re-upload `CHATGPT-PROJECT.md` into the Project.

### Per project

```bash
cp path/to/agent-rules/templates/AGENTS.md .
cp path/to/agent-rules/templates/CLAUDE.md .
mkdir -p .claude/commands
cp path/to/agent-rules/templates/.claude/commands/rules.md .claude/commands/
cp path/to/agent-rules/templates/.claude/settings.json .claude/
```

`CLAUDE.md` uses `@AGENTS.md` to auto-import the quality gate.

## After changes

```bash
# Edit QUALITY-GATE.md, LEARNINGS.md, or PROFILE.md, then:
bash sync.sh    # regenerates all active artifacts
```

## Precedence

Project rules override global rules where they add repo-specific context. The global quality gate remains the baseline.

## If Claude doesn't load CLAUDE.md

1. Claude won't say "CLAUDE.md loaded" → rules not active
2. Type `/memory` to check what's loaded
3. Type `/rules` to force-load rules

## How memory works for each AI

| | Claude | ChatGPT |
|---|--------|---------|
| **Hydration** | Automatic — `sync.sh` generates `~/.claude/CLAUDE.md`, Claude reads it at session start | Project-based — upload `CHATGPT-PROJECT.md` into a ChatGPT Project |
| **Scope** | Every session in every project | Every chat inside that Project |
| **When rules change** | Run `sync.sh` | Run `sync.sh`, re-upload file into Project |
| **Outside scope** | Other AI tools won't see it | Chats outside the Project won't see it |
| **Enforcement** | Suggestion (hooks for hard enforcement) | Suggestion only |

## Limitations

- **CLAUDE.md is a suggestion, not enforcement.** Hooks are the only hard enforcement.
- **ChatGPT Project context is automatic within the Project** but chats outside the Project don't see it.
- **Re-uploading after rule changes is manual.** There is no API to auto-update ChatGPT Project files.
- **Post-compaction hook is a reminder, not a reload.** It asks Claude to re-read; it cannot force it.
- **Learnings don't auto-propagate.** Run `sync.sh` after changes.
