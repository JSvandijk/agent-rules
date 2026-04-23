# AGENTS.md

Quality gate for AI-assisted development on this project.
Works with ChatGPT (T3 Code Alpha / Codex), Claude Code, and any agent that reads project-root markdown.

## Repo-Specific Context

> Replace this section for each new project.

- Repository: `owner/repo-name`
- Product: [one-line description]
- Highest-risk areas:
  - [file or area 1]
  - [file or area 2]

## Portable Quality Gate

These are mandatory steps before calling work complete.

### 1. Security Sweep

- Check every HTTP response, log line, startup banner, and console output for filesystem paths, secrets, tokens, config values, and internal state.
- Tie every security finding to a concrete threat model. Distinguish operator-only output (stdout, local logs) from network-reachable output (HTTP endpoints, response headers). Do not file a finding if you cannot answer: who sees this, how, and what does it give an attacker?
- Check every HTML template for unescaped dynamic values.
- Verify security headers (CSP, CORS, etc.) on every response path.
- Review every cache layer for sensitive data exposure.
- Add explicit size limits to buffered responses and in-memory aggregation.
- Do not silently swallow errors that affect correctness or security.

### 2. Consistency Check

- Read code, docs, audits, and evidence against each other.
- If a document claims a mitigation exists, verify it in code.
- If evidence references a commit or SHA, confirm it matches the current code.
- Treat any code/doc mismatch as a bug.

### 3. Platform Check

- Check deprecated APIs against minimum and target platform versions.
- Suppressing warnings is not a fix. Replace deprecated behavior.
- Verify behavior on both minimum and target platform assumptions.

### 4. Cleanup

- Remove dead code, stale files, and duplicate implementations.
- Check whether new files are tracked in git.
- When adding something new, check if something old should be removed.

### 5. Definition of Done

- Green checks are necessary, not sufficient.
- Local-only changes are not done work for GitHub-facing projects.
- Evidence is not valid if it describes an older state than the current code.
- If not verified, say "not verified" — never "done."

### 6. Adversarial Self-Review

- After implementation, try to break your own output.
- Ask: "What would a hostile reviewer attack first?"
- Fix the strongest known weakness before closing.
- If unfixable, call it out explicitly as an open risk.

### 7. Rule Placement

- Before editing a rule or learning, ask: "Is this a canonical change or a downstream change?"
- Canonical changes go to `QUALITY-GATE.md` or `LEARNINGS.md` in the `agent-rules` repo.
- Project-specific changes go to `AGENTS.md` in that project.
- Never edit downstream when the change belongs upstream.

## Review Priorities

> Replace this section for each new project.

- [hot spot 1]
- [hot spot 2]
- [hot spot 3]

## Reuse

When copying to a new project:
1. Keep **Portable Quality Gate** as-is.
2. Replace **Repo-Specific Context** and **Review Priorities**.

## Operational Rule

If a review exposes a recurring failure mode, update this file in the same pass.
