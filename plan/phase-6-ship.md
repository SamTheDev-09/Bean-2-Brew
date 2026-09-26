# Phase 6 — Ship

**Previous:** [phase-5-a11y-seo-perf.md](./phase-5-a11y-seo-perf.md)

### T6.1 — Copy and anti-template audit
- **Files:** any file with a hit
- **Read:** CONTENT (sections relevant to hits), DESIGN §9
- **Tools:** frontend-design
- **Steps:**
  1. Run `bash scripts/check.sh T6.1`. It lists forbidden strings:
     - `lorem`, `TODO`, `TBD`, `FIXME`, `placeholder`
     - `uppercase`
     - `→`
     - ` · `
  2. Fix every hit.
  3. Compare every visible string in `src/` against CONTENT.md and fix any drift.
  4. Review DESIGN §9 "also avoid" by eye; fix what you find.
- **Check:** `bash scripts/check.sh T6.1`
- **Done:** zero forbidden strings, copy matches CONTENT.

### T6.2 — Forms security review
- **Files:** form components (only if a fix is needed)
- **Read:** PRD §15
- **Tools:** `/security-review`
- **Steps:**
  1. Run `/security-review`.
  2. Confirm:
     - no network APIs in `src/`
     - no URLs inside the three form components
     - no secrets or `.env` usage
     - external links have `rel="noopener"`
     - the `.ics` object URL is revoked
  3. Fix any findings.
- **Check:** `bash scripts/check.sh T6.2`
- **Done:** the forms are demo-safe.

### T6.3 — Final checks
- **Files:** none (fixes only if something fails)
- **Read:** —
- **Tools:** none
- **Steps:** run `bash scripts/check.sh final`. If anything fails, fix it (within the owning task's scope) and rerun.
- **Check:** `bash scripts/check.sh T6.3`
- **Done:** every automated check passes at once.

### T6.4 — Final visual QA
- **Files:** fixes, `qa/REPORT.md`
- **Read:** DESIGN §4–§5
- **Tools:** Playwright MCP
- **Steps:**
  1. Full-page pass at 375, 768, 1024 and 1440:
     - no overflow
     - hero tier renders
     - the pin and process scroll behave
     - every section matches its wireframe intent
     - no text over busy imagery
  2. Fix small issues.
  3. Write `## T6.4` with a one-line verdict per section.
- **Check:** `bash scripts/check.sh T6.4`
- **Done:** pitch-ready visuals.

### T6.5 — Deploy (conditional, never blocks)
- **Files:** `STATUS.md`
- **Read:** TECH_STACK §7
- **Tools:** `/run` (optional pre-deploy look)
- **Steps:**
  1. Check the CLI: `command -v vercel || npx --no-install vercel --version`, then `vercel whoami`.
  2. **If both succeed:** run `npx vercel --yes --prod` and record `**Deploy:** <url>`.
  3. **Otherwise:** record `**Deploy:** pending — run: npx vercel login, then npx vercel --yes --prod`.
  4. Never log in interactively.
- **Check:** `bash scripts/check.sh T6.5`
- **Done:** deployed, or the exact human step is recorded.

### T6.6 — Final report
- **Files:** `STATUS.md`
- **Read:** —
- **Tools:** none
- **Steps:**
  1. Append `## Final report` with:
     - the done list
     - the blocked list
     - the hero tier
     - the bundle numbers
     - the deploy URL or pending note
     - images (fallback or real)
     - human follow-ups: og-cover, STUDIO, map pin, real photos
  2. `git add -A && git commit -m "Final: pitch-ready build"`
  3. Print a summary of at most 10 lines, then stop.
- **Check:** `bash scripts/check.sh T6.6`
- **Done:** stop condition met.
