# Execution Plan — Phase 6

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-6 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-5-a11y-seo-perf.md](./phase-5-a11y-seo-perf.md)  

---

## Phase 6 — Polish & pitch readiness

### T6.1 — Copy audit
- **Files:** any file with placeholder copy
- **Steps:**
  1. Run: `grep -rni "lorem\|tbd\|placeholder\|fixme\|xxx\|scaffold ok" src/ index.html`
  2. Fix **every** hit. Allowed exceptions: the `ANALYTICS SLOT` comment in `index.html` and the demo-form disclaimer string in `ContactSection.jsx`.
  3. Confirm all visible copy matches `PRD.md` exactly.
- **Verify:** `! grep -rni "lorem\|tbd\|fixme\|scaffold ok" src/ index.html && npm run build`
- **Done:** zero visible placeholder copy.

### T6.2 — Forms final verification
- **Files:** `src/components/Newsletter.jsx`, `src/components/ContactSection.jsx` (only if a fix is needed)
- **Steps:**
  1. Confirm: required fields enforced, email format validated, inline errors, inline success, no page reload.
  2. Confirm zero network calls anywhere: `grep -rn "fetch(\|XMLHttpRequest\|axios\|http://\|https://" src/components/Newsletter.jsx src/components/ContactSection.jsx` must show nothing except the `mailto:`/`tel:` in Footer (different file).
- **Verify:** `npm run build && ! grep -rn "fetch(" src/`
- **Done:** both forms are demo-safe per `PRD.md` §17.

### T6.3 — Full final verification
- **Files:** none
- **Steps + Verify (run all, all must pass):**
  ```bash
  npm run build \
  && test -f dist/index.html \
  && for id in hero menu story gallery visit newsletter contact; do grep -q "id=\"$id\"" src/App.jsx || exit 1; done \
  && grep -q "Springfield" src/components/VisitUs.jsx \
  && test $(for f in dist/assets/*.js; do gzip -c "$f"; done | wc -c) -lt 400000
  ```
- **Done:** every PRD section present, budget met, demo data intact. Record the result in `STATUS.md`.

### T6.4 — Deploy (conditional, never blocks)
- **Files:** none
- **Steps:**
  1. Check the CLI: `command -v vercel || npx --no-install vercel --version` — and auth: `vercel whoami`.
  2. **If both pass:** run `npx vercel --yes --prod` from the repo root (Vite is auto-detected; build command `npm run build`; output `dist`). Capture the URL.
  3. **If not:** do NOT try to authenticate interactively. Append to `STATUS.md`: `Deploy: pending — Vercel CLI not authenticated (run: vercel login, then npx vercel --yes --prod)`.
- **Verify:** either a deployment URL was printed, or the STATUS note exists.
- **Done:** site is deployed, or the exact human follow-up is recorded.

### T6.5 — Final commit & report
- **Files:** `STATUS.md`
- **Steps:**
  1. Write `## Final report` in `STATUS.md`: Done list, BLOCKED list, bundle size, deployment URL or pending note, any caveats.
  2. `git add -A && git commit -m "Final: pitch-ready build"`.
  3. Print a summary of **at most 10 lines**. Stop (stop condition met).

---

