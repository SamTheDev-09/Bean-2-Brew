# CLAUDE.md — Build agent instructions (read this first, every session)

You are building the **Bean 2 Brew** demo site in this repo, **in one continuous loop, with no user present**. This file defines how you work. The other files define what you build.

## Docs map

| File | Role |
|---|---|
| `CLAUDE.md` (this file) | How you work. Loop algorithm + hard rules + pinned decisions. |
| `PRD.md` | What to build. All requirements, all copy, all fictional business data. |
| `TECH_STACK.md` | How to build. Pinned versions, plugins, budgets. Do not deviate. |
| `EXECUTION_PLAN.md` | The task list. You execute it, one task per loop. |
| `STATUS.md` | State tracker. You update it. Read it at the start of every loop. |
| `PREREQUISITES.md` | Human-only environment setup. Already done. Never re-run it. |
| `tools/README.md` | Image-worker contract (model TBD). See rule R8. |

## The loop (repeat until the stop condition)

1. Read `STATUS.md` (it is short).
2. Open `EXECUTION_PLAN.md` and find the **first unchecked task** (`T#.#`).
3. Do **only that task**. Touch **only the files the task lists**. Read only the sections of `PRD.md` the task references.
4. Run the task's exact **Verify** command. Exit code 0 = pass.
5. **Pass:** check the box in `EXECUTION_PLAN.md` → add 1–2 factual lines to `STATUS.md` → `git add -A && git commit -m "T#.# <task title>"`.
6. **Fail:** fix and re-run Verify. Maximum **2 extra attempts**.
7. **Still failing:** append `T#.# BLOCKED: <one-line reason>` under *Open issues* in `STATUS.md`, leave the box unchecked, and continue with the next task.

## Hard rules

- **R1 — Never stop to ask the user a question.** If something is ambiguous: use a Pinned decision below; if none covers it, choose the simplest option that satisfies `PRD.md`, record the choice under *Decisions* in `STATUS.md`, and continue.
- **R2 — Do not edit `PRD.md` or `TECH_STACK.md`.** The only files you edit are: source files under `src/`, `index.html`, `public/`, checkbox lines in `EXECUTION_PLAN.md`, and `STATUS.md`.
- **R3 — No new npm dependencies.** Everything needed is already in `package.json` (pinned). Do not run `npm install <anything>`, do not run `npm create vite`, do not change versions.
- **R4 — All business content comes from `PRD.md` §8 and §11.** Never invent new business data (name, address, phone, email, hours, menu items, prices, social handles).
- **R5 — Commit after every completed task.** Never let 3+ tasks pass uncommitted.
- **R6 — Keep edits small and self-contained.** One task = one small change. If a task's Verify fails because of an error you introduced in the same task, fix that, not unrelated code.
- **R7 — Respect the performance budget in `TECH_STACK.md`.** Never add heavy assets.
- **R8 — Image generation is conditional.** Use `tools/gen_image.sh` **only** if `tools/gen_image.sh --selftest` exits 0. If it exits non-zero, use the committed SVG placeholders in `public/img/` and say so in `STATUS.md`. The loop must complete either way.
- **R9 — Forms are demo-safe, always.** No `fetch(`, no `XMLHttpRequest`, no real endpoints. Success states are local state only.
- **R10 — Do not start long-running servers and leave them running.** If a task needs the dev server, start it, test, and kill it in the same command (e.g. `timeout 10 npm run dev -- --port 5173 & sleep 4; curl -s http://localhost:5173 | grep -o "SCAFFOLD OK" || true; kill %1 2>/dev/null; wait 2>/dev/null; exit 0`).

## Pinned decisions (already resolved — never re-decide)

| Decision | Value |
|---|---|
| Map | OpenStreetMap iframe, no API key. Exact URL is in task T2.7. |
| Contact destination | Dedicated mini-section `#contact` (NOT a modal), placed between Visit Us and Newsletter. |
| Hero effect | Ambient steam/particle field: procedural R3F `<points>`, no external 3D assets, no glTF. |
| Palette | cream `#F5EDE2` · espresso `#3B2A20` · terracotta `#C97C4B` · sage `#7C8B6F`. Locked (PRD §6 defaults). |
| Fonts | Fraunces (display) + Inter (body). Self-hosted via `@fontsource`, already imported in `src/main.jsx`. |
| Forms | Mock/no-op handlers, inline success, zero network calls (R9). |
| Footer studio credit | `Brewworks Studio` (fictional; one constant in `Footer.jsx`). |
| Text contrast | Body text: espresso on cream only. Terracotta: large text/graphics only. Sage: decorative/large only. Footer: cream text on espresso background. |
| Images | SVG placeholders in `public/img/` are the default image set; AI-generated images (via `tools/gen_image.sh`) are a drop-in upgrade only. |
| Language | JavaScript (`.jsx`), not TypeScript. Do not add TS files. |

## Stop condition

When `EXECUTION_PLAN.md` has **no unchecked tasks that are not BLOCKED**:
1. Run `npm run build` (must pass).
2. Write a `## Final report` section in `STATUS.md`: what is Done, what is BLOCKED, bundle size number, any caveats a human should know.
3. `git add -A && git commit -m "Final: pitch-ready build"`.
4. Print a summary of **at most 10 lines** and stop.

Do not end the session earlier with "shall I continue?" or similar. Work until the stop condition.
