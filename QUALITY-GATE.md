# Quality Gate

Universal rules for AI-assisted development. These apply to every project regardless of language, framework, or domain.

> **This repo is public.** Keep content generic. No emails, tokens, absolute local file paths, or personal data.

## Principles

1. **Verify before claiming done.** Never say "fixed" or "done" without confirming. If you can't verify, say "not verified."
2. **Check your own outputs against each other.** Code vs docs vs audit vs evidence — mismatches are bugs, not follow-ups.
3. **Push back when appropriate.** Blind agreement is not useful. If a finding or request is wrong, say so with evidence.
4. **Less is more.** One working test beats five documents about testing. Don't add what wasn't asked for.
5. **Local-only changes are not done.** For version-controlled projects, work is done when committed and pushed.
6. **Deprecated = replace, not suppress.** Warning suppression is a TODO marker, not a fix.
7. **Evidence must match the current code.** Old proof is historical, not current.
8. **Status reports describe state at time of writing.** If the state changes afterward, record that as an update instead of judging the earlier report against the newer state.

## Security (any project with network/web/API surface)

- Check every HTTP response, log line, and error message for leaked paths, secrets, tokens, or config
- Check every HTML/template for unescaped dynamic values
- Check every cache layer for sensitive data exposure
- Check every buffer/stream for size limits
- Don't silently swallow errors: `catch (e) { /* ignore */ }` is almost always wrong
- Tie every security finding to a concrete threat model. Distinguish operator-only output (stdout, local logs) from network-reachable output (HTTP endpoints, response headers). Do not file a finding if you cannot answer: who sees this, how, and what does it give an attacker?

## After every implementation

- Run the project's test suite
- Adversarial pass: "what would a hostile reviewer attack first?"
- Check for dead code or legacy files that should have been removed
- Check if new additions mean something old should be deleted
- Before editing a rule or learning, ask: "Is this a canonical change or a downstream change?" Canonical changes go to QUALITY-GATE.md or LEARNINGS.md in the agent-rules repo. Project-specific changes go to AGENTS.md in that project. Never edit downstream when the change belongs upstream.

## Definition of done

- [ ] Tests pass
- [ ] Changes committed and pushed
- [ ] No contradictions between code, docs, and claims
- [ ] No leaked secrets/paths in outputs
- [ ] Evidence matches current code state
- [ ] Dead code removed
