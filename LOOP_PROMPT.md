# The Loop Prompt

Paste **only the block below** (not this header) into a fresh `ccr code` session started in the repo root, then walk away.

---

```text
You are building the Bean 2 Brew demo site in this repository, in ONE continuous loop, with NO user present. You will work until the stop condition is met. Do not stop early, and never ask the user a question.

FIRST: read CLAUDE.md completely. It contains the loop algorithm, the hard rules (R1-R10), the pinned decisions, and the stop condition. Obey it exactly.

Then read, in order: PRD.md, TECH_STACK.md, EXECUTION_PLAN.md, STATUS.md.

LOOP (repeat until stop condition):
1. Read STATUS.md.
2. Find the first unchecked task T#.# in EXECUTION_PLAN.md.
3. Do only that task. Touch only the files the task lists.
4. Run the task's exact Verify command. Exit 0 = pass.
5. Pass: check the box in EXECUTION_PLAN.md, add 1-2 factual lines to STATUS.md, then: git add -A && git commit -m "T#.# <task title>"
6. Fail: fix and re-verify. Maximum 2 extra attempts.
7. Still failing: append "T#.# BLOCKED: <one-line reason>" to STATUS.md under Open issues, leave the box unchecked, continue to the next task.

KEY CONSTRAINTS (repeated from CLAUDE.md):
- Never ask questions. Never end a turn with "shall I continue?" or similar.
- No new npm dependencies; no version changes; no re-scaffolding (R3).
- All business content comes verbatim from PRD.md sections 8 and 11 (R4).
- Forms never make network calls (R9).
- Use tools/gen_image.sh only if "tools/gen_image.sh --selftest" exits 0; otherwise keep the SVG placeholders (R8).
- Keep every edit small: one task = one commit (R5, R6).
- Pinned decisions in CLAUDE.md are final: OpenStreetMap iframe, Contact = dedicated #contact section, hero = procedural steam particle field with static fallback, palette/fonts/forms as listed.

STOP CONDITION: when EXECUTION_PLAN.md has no unchecked tasks that are not BLOCKED:
1. Run "npm run build" (must pass).
2. Write a "## Final report" section in STATUS.md: Done list, BLOCKED list, gzipped JS size number, deployment URL or pending note, caveats.
3. git add -A && git commit -m "Final: pitch-ready build"
4. Print a summary of at most 10 lines, then stop.

Begin now: start the loop with the first unchecked task.
```

---

## Operational notes (for you, not for the model)

* **Runtime:** roughly 1–3 hours on a 9B local model (28 tasks × verify + commit each). Watch `ollama ps` for VRAM and `git log --oneline` for progress.
* **Interruptions:** if the session dies mid-task, just start a new `ccr code`, paste the same prompt. The loop always resumes from the first unchecked task — `STATUS.md` + `EXECUTION_PLAN.md` are the memory.
* **The 9B ceiling:** expect a few BLOCKED tasks, especially around the 3D hero (Phase 3). That's by design — the plan falls back (static hero) and keeps going. Review BLOCKED items after the run; most are 1-line fixes a human (or a hosted model, one task at a time) can unblock, then paste the prompt again to resume.
* **After the run:** deploy is either done (T6.4) or recorded as pending with the exact command (`npx vercel --yes --prod`).
