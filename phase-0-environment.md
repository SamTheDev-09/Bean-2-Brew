# Execution Plan — Phase 0

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-0 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Next:** [phase-1-design-assets.md](./phase-1-design-assets.md)

---

## Phase 0 — Environment check

### T0.0 — Scaffold the project (only if `package.json` doesn't exist)
- **Files:** `package.json`, `package-lock.json`, `vite.config.js`, `index.html`, `src/main.jsx`, `src/App.jsx`, `src/index.css`, `.gitignore`
- **Steps:**
  1. `npm create vite@latest . -- --template react` (accept overwrite into the current dir, which only has docs + `.git`).
  2. Install exact pinned versions from `TECH_STACK.md`: `npm install react@19.3.0 react-dom@19.3.0 && npm install -D vite@8.3.1 @vitejs/plugin-react@6.1.1 tailwindcss@4.3.3 @tailwindcss/vite@4.3.3 three@0.186.1 @react-three/fiber@9.8.1 @react-three/drei@10.7.9 gsap@3.15.0 framer-motion@13.4.4 yet-another-react-lightbox@3.32.2 @fontsource/fraunces@5.3.0 @fontsource/inter@5.3.0`.
  3. Configure Tailwind v4 (CSS-first, no `tailwind.config.js`): add `@import "tailwindcss";` plus the `@theme` token block to `src/index.css` per `PRD.md` §6 (cream/espresso/terracotta/sage + Fraunces/Inter).
  4. Add `@tailwindcss/vite` plugin to `vite.config.js`.
  5. Create `.gitignore` with `node_modules/`, `dist/`, `.env`.
  6. `git add -A && git commit -m "T0.0: project scaffold"`.
- **Verify:** `npm run build` exits 0.
- **Done:** `package.json`/lockfile committed with the exact pinned versions; build passes.
- **Skip this task entirely** if `package.json` already exists — go straight to T0.1.

### T0.1 — Install dependencies and verify build
- **Files:** none (repo root)
- **Steps:**
  1. Run `npm install` (uses the committed `package-lock.json`; versions are pinned — do not change them).
  2. Run `npm run build`.
- **Verify:** `npm run build` exits 0 and prints `built in`.
- **Done:** `dist/` exists with `index.html` and `assets/`.
- **If it fails:** check `node -v` (needs 20.19+ or 22+; 22 LTS recommended). One retry. Still failing → BLOCKED with the exact error text.

### T0.2 — Verify dist output is complete
- **Files:** none
- **Steps:** inspect the build output only.
- **Verify:** `test -f dist/index.html && test -d dist/assets && test -f dist/assets/index-*.js` — write it as: `test -f dist/index.html && ls dist/assets/*.js`
- **Done:** both the HTML entry and at least one JS bundle exist in `dist/`.

---

