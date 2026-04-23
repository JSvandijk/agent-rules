# Learnings

Reusable patterns from AI-assisted projects. This is a promotion queue, not an archive.

> **This repo is public.** No emails, tokens, absolute local file paths, or personal data.

## Promotion rule

- **1x seen** → stays in the project repo only
- **2x seen** → add here as a short pattern
- **Keeps recurring** → promote to QUALITY-GATE.md, templates, or global ~/.claude/CLAUDE.md
- **Stale** → retire if not seen in 3+ projects

After promoting or retiring, run `bash sync.sh` to regenerate active artifacts.

---

## Patterns

| # | Pattern | Scope | Status | Promoted to |
|---|---------|-------|--------|-------------|
| 1 | AI code + AI audit in same pass miss each other's mistakes | global | absorbed | QUALITY-GATE principle 2 |
| 2 | Volume of docs ≠ quality. Test-to-doc ratio matters | global | absorbed | QUALITY-GATE principle 4 |
| 3 | AI adds but rarely subtracts. Check what to remove | global | absorbed | QUALITY-GATE "after every implementation" |
| 4 | "Works locally" ≠ done. Uncommitted work is not progress | global | absorbed | QUALITY-GATE principle 5 |
| 5 | Deprecated API + warning suppression = tech debt | global | absorbed | QUALITY-GATE principle 6 |
| 6 | Evidence from older commit is historical, not current proof | global | absorbed | QUALITY-GATE principle 7 |
| 7 | CLAUDE.md is a suggestion, not enforced. Use ALWAYS/NEVER, keep under 200 lines | tool:claude | promoted | templates/CLAUDE.md |
| 8 | Post-compaction Claude forgets rules. SessionStart hook helps | tool:claude | promoted | templates/.claude/settings.json |
| 9 | Overclaiming in docs creates false confidence | global | promoted | README |
| 10 | @AGENTS.md import in CLAUDE.md auto-loads the quality gate | tool:claude | promoted | templates/CLAUDE.md |

---

## Template

```
| # | Pattern | Scope | Status | Promoted to |
|---|---------|-------|--------|-------------|
| N | one-line pattern | global/tool:X/project-only | candidate/promoted/absorbed/retired | target or "not yet" |

Statuses: candidate (new), promoted (in active memory), absorbed (merged into QUALITY-GATE), retired (stale).
```
