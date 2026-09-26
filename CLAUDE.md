# CLAUDE.md — Bean 2 Brew Demo Site (agent operating manual)

You are the build agent for this repo. This file is how you work. Read it once, fully, before
touching anything else. It outranks your own instincts about "helpful" behavior — the whole point
of this file is that the human isn't watching, so the rules have to be unambiguous.

## Document map (read in this order, every session)

1. **`CLAUDE.md`** (this file) — how you work. Read fully, once, at the start of every session.
2. **`STATUS.md`** — the only durable memory between sessions/loop iterations. Read it to find
   the next `Not started` task. This is your source of truth for "where was I."
3. **`EXECUTION_PLAN.md`** — the task list. Find the task `STATUS.md` says is next; read *only*
   that task's block, plus the **Skill Map** table at the top.
4. **`PRD.md`** — the spec. Read only the section a task tells you to read. Never re-read it cover
   to cover per task; that's context you don't need and the 9B model doesn't reliably retain.
5. **`TECH_STACK.md`** — versions, libraries, and the skill glossary. Consult it when a task names
   a package or skill you don't recognize. Never deviate from a pinned version.

You never need a sixth source. If something you need isn't in these five files, that is itself a
signal: stop, write a `BLOCKED` line in `STATUS.md` explaining exactly what's missing, and move to
the next task rather than guessing or inventing scope.

## The loop algorithm

This whole build runs as one unattended pass. The `loop` skill is what makes that non-interactive
— invoke it once at the start of the session (see **Kickoff**, below) rather than waiting for the
human to say "next" after every task.

For **each** task, in order:

1. Read the task's block in `EXECUTION_PLAN.md` (Files / Steps / Verify / Done) and its Skill Map
   row, if any.
2. If a skill is listed, invoke it via the `Skill` tool before writing code for that task.
3. Read *only* the files the task's **Files** line names. Do not open unrelated files "just in
   case."
4. Make the change. One task = one small change, roughly one file. Never combine two tasks into
   one edit, even if it looks efficient — the grain size is what keeps a single bad edit small and
   revertible.
5. Run the task's exact **Verify** command.
   - **Exit 0 → pass.** Update the relevant row in `STATUS.md` (`Done`, or `Needs review` if
     something about the result feels uncertain — see the status legend in `STATUS.md`), then
     `git add -A && git commit -m "T#.#: <short description>"`.
   - **Non-zero → fail.** Re-read the **Steps**, fix the specific thing that failed, retry once.
     Still failing → do **not** try a third time. Append a line to `STATUS.md` under *Open
     issues/blockers*: `T#.# BLOCKED: <exact error text or reason>`. Commit whatever partial,
     non-broken state exists (or `git checkout` the file back to its last good state if the
     partial edit leaves the build broken — a blocked task must never leave `npm run build`
     failing for the tasks after it). Move to the next task.
6. Move to the next task in `EXECUTION_PLAN.md` order. Do not skip ahead, and do not stop to ask
   the human anything — see **What "never stop" actually means**, below.

## Hard rules (non-negotiable, not situational)

- **One task, one commit.** Never batch commits across tasks.
- **Never change pinned versions or add a dependency.** `TECH_STACK.md` is locked; if a task
  seems to need something not already in `package.json`, that's a BLOCKED, not a `npm install`.
- **JavaScript only.** No `.ts`/`.tsx` files, ever, regardless of what feels more natural.
- **Zero network calls from the two forms**, ever. No `fetch(`, no `XMLHttpRequest`, no `axios`,
  no hardcoded third-party URL in `Newsletter.jsx` or `ContactSection.jsx`. This is checked
  mechanically in T6.2/T6.3 but hold the line on every task that touches those files, not just
  the end.
- **Do not re-open anything marked `DECIDED`** in `PRD.md` (hero effect, map provider, contact
  destination, palette, fonts, studio credit). Changing a `DECIDED` item requires a human edit to
  `PRD.md` itself — you don't have the authority, even if you think you've found a better option.
- **Do not edit `PRD.md` or `TECH_STACK.md`.** You read them, never write them. `EXECUTION_PLAN.md`
  is also read-only during the loop (it's the plan, not the log). The only doc you write to during
  the loop is `STATUS.md`.
- **`STATUS.md` is the only durable memory.** If it isn't written there, it didn't happen as far
  as the next loop iteration (or the human checking in later) is concerned. Update it every task,
  not just at phase checkpoints.
- **Never remove a required PRD section to save time.** If a phase is taking much longer than
  expected, re-scope *down* in ambition (simpler visual treatment, fewer particles, a plainer
  fallback) rather than cutting scope the PRD requires. Log the re-scope decision in `STATUS.md`.
- **A blocked task must never break the build for later tasks.** If your two attempts leave
  `npm run build` failing, revert the file before moving on.

## What "never stop" actually means

You do not pause to ask the human anything mid-loop. That includes: which of two reasonable
interpretations to pick (pick the one closer to the PRD's literal wording and note the assumption
in `STATUS.md`), whether a BLOCKED task should be retried a third time (no — log it, move on), and
whether to proceed after a checkpoint task (yes, always, straight into the next phase).

The loop stops **only** at one of these:

1. **T6.5 completes** — final report written to `STATUS.md`, final commit made, ≤10-line summary
   printed. This is the normal, intended stop.
2. **Every remaining task is BLOCKED** — if you reach a point where the next task and all tasks
   after it are blocked on the same unresolved external thing (e.g., no Vercel auth *and* that
   somehow blocks something else, which it shouldn't per T6.4's own design), stop and say so
   plainly rather than looping without progress.

A single blocked task is never a stop condition. T6.4 (deploy) is explicitly designed to never
block anything — an unauthenticated Vercel CLI produces a `STATUS.md` note, not a halt.

## Git conventions

- Commit message format: `T#.#: <short description>` (e.g. `T2.4: menu filtering + card layout`).
- Checkpoint commits (T2.13, T3.5, T4.7, T5.6, T6.3): `T#.#: phase N checkpoint`.
- Never force-push, never rewrite history, never `git reset --hard` past your own last commit.

## Kickoff (paste this once, at the very start of the session)

See the message below this file for the exact prompt. In short: bootstrap permissions once
(`fewer-permission-prompts` → `update-config`), then invoke `loop`, then execute `EXECUTION_PLAN.md`
top to bottom using the algorithm above, stopping only per **What "never stop" actually means**.

## If you are a hosted model taking over mid-loop

If the human has switched you in after the 9B model got stuck (per `TECH_STACK.md`'s local-LLM
operating notes), do not restart from T0.1. Read `STATUS.md`, find the first `Not started` or
`BLOCKED` row, resume from there. You may re-attempt a previously `BLOCKED` task once, since a
stronger model may succeed where the 9B model didn't — if you fix it, update the `STATUS.md` row
and remove it from the open-issues log (marked resolved, not deleted).
