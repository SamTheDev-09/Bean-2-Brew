# Execution Plan — Bean 2 Brew Demo Site

**Purpose:** Build the full demo defined in `PRD.md` using the pinned stack in `TECH_STACK.md`, as a single uninterrupted loop (see `CLAUDE.md` for the loop algorithm and hard rules).

**Grain size rule:** each task is one small change — roughly one file. Never do two tasks at once. Every task has an exact **Verify** command (exit 0 = pass) and a **Done** criterion.

The scaffold (Vite 8 + React 19 + Tailwind 4 + all deps pinned + lockfile) is **already committed** once T0.0 has run. Phase 0 is otherwise verification, not setup.

**This file is an index, not the task list.** As of 2026-09-26 the task bodies live in one file
per phase under `plan/`, so a single task-read costs a few KB instead of the ~30KB this whole
document used to be. **Open only the phase file `STATUS.md` says you're currently on — never open
a second phase file "to be safe."** This split exists specifically to keep per-turn token usage
low on a 12–14B local model; re-reading multiple phase files defeats the point.

---

## Skill Map (native Claude Code skills — invoke via the `Skill` tool)

Before starting a task, check this table. If a task lists a skill, invoke it before writing any
code for that task — treat it as a required step, not optional flavor. Tasks not listed need no
skill beyond the task's own written steps. Glossary of what each skill is for: `TECH_STACK.md` §
Claude Code skills used in this build.

**Session bootstrap (once, before T0.0/T0.1 — not a numbered task):** invoke `fewer-permission-prompts`
then `update-config` to configure this repo so the loop doesn't stall on interactive prompts, then
invoke `loop` to drive the phase-by-phase sequence as one self-paced run. See `CLAUDE.md` for the
exact kickoff sequence.

| Task(s) | Skill(s) to invoke |
|---|---|
| T0.1 | `init` |
| T1.1 | `design-system` |
| T1.3 | `design`, `brand` |
| T2.1, T2.4, T2.6, T2.12 | `ui-styling`, `ui-ux-pro-max` |
| T2.2 | `svg-animation` (scroll-cue bounce only) |
| T2.10 | `brand` |
| T2.13, T3.5, T4.7, T5.6, T6.3 | `code-review` (review the diff since the previous checkpoint) |
| T3.1 | `threejs-webgl`, `react-three-fiber`, `threejs-impl-react-three-fiber`, `threejs-syntax-materials`, `threejs-syntax-geometries`, `lightweight-3d-effects` |
| T3.2 | `accessible-animation` |
| T3.3 | `threejs-errors-rendering` |
| T3.4 | `60fps-animation`, `threejs-errors-performance`, `run` (to actually see it live) |
| T4.1 | `gsap-web`, `glassmorphism` (optional, cosmetic only) |
| T4.2 | `gsap-scrolltrigger`, `accessible-animation` |
| T4.3 | `motion-framer`, `micro-interaction` |
| T4.4 | `micro-interaction`, `accessible-animation` |
| T4.5 | `accessible-animation` |
| T4.6 | `60fps-animation`, `simplify` |
| T5.5 | `simplify` |
| T6.1 | `simplify` |
| T6.2, T6.3 | `security-review` |
| T6.4 | `run` |

Everything else (data files, copy, static markup, meta tags) is plain implementation work per the
task's own steps — do not invoke a skill just to invoke one.

---

## Phase index

Read `STATUS.md` first to find your current phase, then open **only** that row's file.

| Phase | Tasks | File | Objective |
|---|---|---|---|
| 0 | T0.0–T0.2 | [`plan/phase-0-environment.md`](./plan/phase-0-environment.md) | Scaffold (if missing) + verify build |
| 1 | T1.1–T1.4 | [`plan/phase-1-design-assets.md`](./plan/phase-1-design-assets.md) | Design tokens + placeholder images |
| 2 | T2.1–T2.13 | [`plan/phase-2-static-skeleton.md`](./plan/phase-2-static-skeleton.md) | Every section, static, zero animation |
| 3 | T3.1–T3.5 | [`plan/phase-3-hero-3d.md`](./plan/phase-3-hero-3d.md) | Hero 3D steam field + fallback |
| 4 | T4.1–T4.7 | [`plan/phase-4-motion-interaction.md`](./plan/phase-4-motion-interaction.md) | Scroll/motion/lightbox pass |
| 5 | T5.1–T5.6 | [`plan/phase-5-a11y-seo-perf.md`](./plan/phase-5-a11y-seo-perf.md) | Accessibility, SEO, performance hardening |
| 6 | T6.1–T6.5 | [`plan/phase-6-polish-pitch.md`](./plan/phase-6-polish-pitch.md) | Copy audit, forms check, deploy, final report |

Each phase file ends with `**Previous:**` / `**Next:**` links — use those to move on once a
phase's checkpoint task is `Done` in `STATUS.md`, rather than returning to this index.

---

## Working agreement

- `STATUS.md` is updated at the end of every task — it is the only durable memory between loops.
- When a task takes materially longer than expected, stop, re-scope down (simpler = acceptable), record the reason in `STATUS.md`.
- Do not remove a required PRD section to save time. Scope changes are out of loop authority.
- Prefer small, reversible commits over large multi-file changes.
