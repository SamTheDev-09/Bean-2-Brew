# SINGLE LOOP — build the whole site in one session

One Claude Code session runs every task, T0.1 → T6.6, without you stepping in.

**Same as the split plan:**
- the tasks
- the checks
- the docs

**What's different is how the run keeps going:**

| Problem in a long run | What handles it |
|---|---|
| The agent "finishes" early and waits for you | **Stop hook** `scripts/loop-guard.sh` (wired in `.claude/settings.json`). It blocks every stop while `[ ]` tasks remain and tells the agent the next task id |
| An infinite loop if something is truly stuck | The guard allows the stop after **3 stop attempts in a row with no task finished**, or if a `STOP` file exists |
| Context fills up over ~55 tasks | Claude Code auto-compacts. `STATUS.md` is the memory; the agent re-reads CLAUDE.md + STATUS.md at each phase start and after compaction (the guard reminds it) |
| Permission prompts stall the run | The allow-list in `.claude/settings.json` plus `--permission-mode acceptEdits` |
| Model switching mid-run isn't automatic | One model for the whole run (see §2) |

## 1. Before you start (once)

1. **Do KICKOFF.md steps 1–2:** folder, git, MCPs, plugins.
2. **Open `claude` in the folder and run `/hooks`.** Confirm a **Stop** hook runs `scripts/loop-guard.sh`.
   - If it's not listed, `.claude/settings.json` didn't load. Run `/permissions` to see the error.
3. **Optional:** start the Higgsfield asset session now in another terminal (ASSETS.md §4). Photos dropped in any time before Phase 6 get picked up automatically.

## 2. Model

| Choice | When |
|---|---|
| **Opus for the whole run** (recommended) | Phases 3–4 (3D shader, GSAP choreography) decide how the demo looks. Opus there is worth more than the savings on easy phases |
| Sonnet for the whole run | If Opus usage limits would cut the run short. The hero tiers (PRD §6) keep the result shippable, but expect Tier B more often |

Don't switch models mid-run. A switch means a manual interruption, which defeats the single loop.

## 3. Launch

```bash
cd bean2brew
claude --permission-mode acceptEdits
```

Inside Claude Code: `/model opus`, then paste:

```
You are the build agent. Read CLAUDE.md fully and follow it exactly.

Single-loop mode: work through every task in STATUS.md, from the first unchecked task to T6.6, in this one session. For each task: read the task block in its phase file, implement it, run `bash scripts/check.sh <task-id>`, update STATUS.md, commit, and move to the next. Follow the FAIL/BLOCKED rules in CLAUDE.md exactly; never weaken a check.

Never stop to ask me anything. Log every assumption under STATUS.md → Decisions.

At the start of each phase (T1.1, T2.1, T3.1, T4.1, T5.1, T6.1) and after any context compaction, re-read CLAUDE.md and STATUS.md before continuing. Open only the current phase file.

If the loop guard tells you tasks remain, continue with the task it names.

Scope: run to T6.6, then print the final summary and stop.
```

## 4. What happens during the run

| Stage | Tasks | Gate before moving on |
|---|---|---|
| Scaffold | T0.1–T0.3 | pinned deps + build pass |
| Foundations | T1.1–T1.8 | all data files load, 9 section ids exist |
| Sections | T2.1–T2.14 | **complete static site**, browser QA at 4 widths, `/code-review` |
| Hero 3D | T3.1–T3.6 | tier decision recorded (A/B/C) |
| Motion | T4.1–T4.10 | bundle budget, motion QA, `/code-review` |
| A11y/SEO/perf | T5.1–T5.7 | keyboard path, JSON-LD, budget |
| Ship | T6.1–T6.6 | `check.sh final`, visual QA, deploy or pending note, final report |

The gates are the checkpoint tasks' checks. There is no pause for you. A failed checkpoint becomes `[!]`, gets logged, and the loop moves on without breaking the build.

## 5. Watching and control

- **Progress:** in a second terminal, run `git log --oneline` or read `STATUS.md`. Every task is one commit.
- **Pause cleanly:**
  - `touch STOP` in the repo root. The agent stops at its next stop attempt instead of being pushed on.
  - Delete `STOP` before resuming, and don't commit it.
- **Stop immediately:** press Esc in Claude Code. Nothing is lost past the last commit.
- **Stuck detection:** if 3 stop attempts pass with no task finished, the guard lets it stop. Read STATUS.md → Open issues for the cause.

## 6. If the run is interrupted

This covers usage limits, a crash, a closed laptop, or a guard stop.

1. Fix the cause if it's yours (a missing tool, a Windows path issue, a bad settings rule).
2. Run `rm -f STOP`, then `claude --permission-mode acceptEdits` and `/model opus`.
3. Paste:
   ```
   Resume single-loop mode. Read CLAUDE.md and STATUS.md, continue from the first unchecked task, retry each [!] task once, and run to T6.6.
   ```

## 7. When it ends

Read `STATUS.md → ## Final report` and do the human follow-ups:
- **og-cover:** supply `public/og-cover.jpg`.
- **Studio credit:** fix the `STUDIO` spelling.
- **Map pin:** confirm the pin.
- **Photos:** add real photos if the site is still on fallback art.
- **Deploy:** run the deploy command if it's pending.
