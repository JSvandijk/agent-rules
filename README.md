# agent-rules

Persistent quality rules and accumulated learnings for AI-assisted development.

> **This repo is public.** Do not commit email addresses, passwords, tokens, API keys, absolute local file paths, or other private information. Learnings and rules only.

## What this is

This repo is the single source of truth for how AI agents (Claude, ChatGPT) should work on my projects. It solves one problem: **AI doesn't remember between sessions, so the lessons need to live somewhere permanent.**

After every project or review, new findings get added here. Per-project files (`CLAUDE.md`, `AGENTS.md`) carry the relevant rules into each session. Learnings accumulate here but must be manually referenced or copied into project files — neither AI loads this repo automatically.

## Precedence

Project rules override global rules where they add repo-specific context. The global quality gate (`QUALITY-GATE.md`) remains the baseline. Tool-specific workarounds (Claude acknowledgment line, ChatGPT Custom Instructions) live in their own files or templates, not in the universal gate.

## How it works

```
agent-rules (this repo)              →  permanent, accumulates over time
        │
        ├── QUALITY-GATE.md          →  universal rules (any project)
        ├── LEARNINGS.md             →  findings from each project
        ├── CHATGPT-INSTRUCTIONS.md  →  copy into ChatGPT Custom Instructions
        │
        └── templates/
              ├── AGENTS.md          →  project template for ChatGPT
              ├── CLAUDE.md          →  project template for Claude Code
              └── .claude/commands/
                    └── rules.md     →  /rules slash command (fallback)
        │
        ▼
~/.claude/CLAUDE.md              →  global Claude context (auto-read)
~/.claude/commands/rules.md      →  global /rules command (recovery)
{project}/CLAUDE.md              →  project-specific Claude context
{project}/AGENTS.md              →  project-specific ChatGPT context
{project}/.claude/commands/      →  project-specific slash commands
```

## Quick start (Claude Code)

```bash
git clone https://github.com/JSvandijk/agent-rules.git
cd agent-rules
bash setup.sh
```

This creates three things:
- `~/.claude/CLAUDE.md` — rules that Claude reads at session start
- `~/.claude/commands/rules.md` — `/rules` fallback if Claude forgets
- Hook in `~/.claude/settings.json` — reminds Claude to re-read rules after context compaction

Test: open Claude Code → Claude says "CLAUDE.md loaded" → done.

## Setup for ChatGPT

Copy `CHATGPT-INSTRUCTIONS.md` content into ChatGPT > Settings > Custom Instructions.

## After each project

Add a new entry to `LEARNINGS.md` with what was found and what was learned.
Sync `~/.claude/CLAUDE.md` if the quality gate changed.

## New project setup

Copy templates manually:

```bash
cp path/to/agent-rules/templates/AGENTS.md .
cp path/to/agent-rules/templates/CLAUDE.md .
mkdir -p .claude/commands
cp path/to/agent-rules/templates/.claude/commands/rules.md .claude/commands/
cp path/to/agent-rules/templates/.claude/settings.json .claude/
```

Or set up a git alias (one-time, optional):

```bash
git config --global alias.add-agents '!cp ~/.claude/templates/AGENTS.md . && cp ~/.claude/templates/CLAUDE.md . && mkdir -p .claude/commands && cp ~/.claude/templates/.claude/commands/rules.md .claude/commands/ && cp ~/.claude/templates/.claude/settings.json .claude/ && echo "copied"'
```

Then fill in the project-specific sections.

## If Claude Code doesn't load CLAUDE.md

1. You'll know because Claude won't say "CLAUDE.md loaded" at the start.
2. Type `/rules` — this forces Claude to read and apply the project rules.
3. This works because `.claude/commands/rules.md` is a slash command, not auto-read — it's triggered explicitly.
