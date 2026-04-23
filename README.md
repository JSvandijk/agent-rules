# agent-rules

AI memory pipeline for quality rules and accumulated learnings.

> **This repo is public.** No emails, passwords, tokens, API keys, absolute local file paths, or personal data.

## How it works: Capture → Promote → Hydrate

```
                    CAPTURE                          PROMOTE                         HYDRATE
              ┌─────────────────┐            ┌─────────────────┐            ┌─────────────────┐
              │  Project repo   │            │  agent-rules    │            │  Active context  │
              │                 │   pattern   │                 │  sync.sh   │                 │
              │  case studies   │──repeats──▶│  LEARNINGS.md   │──────────▶│  ~/.claude/      │
              │  audits         │            │  (promotion     │  sync.sh   │    CLAUDE.md     │
              │  incidents      │            │   queue)        │  (auto)    │                 │
              │  AGENTS.md      │            │                 │            │  ChatGPT Custom │
              │                 │   rule     │  QUALITY-GATE   │──────────▶│   Instructions  │
              │                 │──proven──▶│  .md            │  sync.sh   │  (manual paste) │
              └─────────────────┘            └─────────────────┘            └─────────────────┘
                                                     │
                                                     │ templates
                                                     ▼
                                              ┌─────────────────┐
                                              │  New project    │
                                              │  CLAUDE.md      │
                                              │   └ @AGENTS.md  │
                                              │  .claude/       │
                                              │   ├ settings    │
                                              │   └ commands    │
                                              └─────────────────┘
```

## What each file does

| File | Role | Consumed by |
|------|------|-------------|
| `QUALITY-GATE.md` | Universal rules — the canonical source | `sync.sh` generates Claude global memory from this |
| `LEARNINGS.md` | Promoted patterns with scope and status | `sync.sh` includes promoted patterns in Claude memory |
| `CHATGPT-INSTRUCTIONS.md` | ChatGPT Custom Instructions (generated, manual paste) | Manual paste into ChatGPT Settings |
| `PROFILE.md` | "About you" section for ChatGPT instructions | `sync.sh` generates ChatGPT instructions from this |
| `templates/` | Starter files for new projects | `sync.sh` copies to `~/.claude/templates/` |
| `sync.sh` | Generates active artifacts from repo source | Run after any change to rules or learnings |

## Precedence

Project rules override global rules where they add repo-specific context. The global quality gate remains the baseline. Tool-specific workarounds live in templates, not in the universal gate.

## Quick start

```bash
git clone https://github.com/JSvandijk/agent-rules.git
cd agent-rules
bash sync.sh
```

This generates:
- `~/.claude/CLAUDE.md` ← built from QUALITY-GATE.md + promoted LEARNINGS.md
- `~/.claude/commands/rules.md` ← `/rules` fallback
- `~/.claude/settings.json` ← post-compaction hook
- `~/.claude/templates/` ← project starter files

Test: open Claude Code → Claude says "CLAUDE.md loaded" → working.

## After changes

```bash
# Edit QUALITY-GATE.md or LEARNINGS.md, then:
bash sync.sh    # regenerates active artifacts
```

## ChatGPT setup

Paste `CHATGPT-INSTRUCTIONS.md` content into ChatGPT > Settings > Custom Instructions.
This is manual — ChatGPT has no auto-sync mechanism.

## New project setup

```bash
# From any project directory:
cp path/to/agent-rules/templates/AGENTS.md .
cp path/to/agent-rules/templates/CLAUDE.md .
mkdir -p .claude/commands
cp path/to/agent-rules/templates/.claude/commands/rules.md .claude/commands/
cp path/to/agent-rules/templates/.claude/settings.json .claude/
```

Then fill in the project-specific sections. `CLAUDE.md` uses `@AGENTS.md` to auto-import the quality gate.

## If Claude doesn't load CLAUDE.md

1. Claude won't say "CLAUDE.md loaded" → rules not active
2. Type `/memory` to check what's loaded
3. Type `/rules` to force-load rules
4. If nothing works, check file path: `~/.claude/CLAUDE.md`

## Limitations

- **CLAUDE.md is a suggestion, not enforcement.** Claude may ignore it. Hooks are the only hard enforcement.
- **ChatGPT requires manual paste.** No API or sync exists for Custom Instructions.
- **Post-compaction hook is a reminder, not a reload.** It tells Claude to re-read rules; it cannot force it.
- **Learnings don't auto-propagate.** Run `sync.sh` after changes to regenerate active artifacts.
