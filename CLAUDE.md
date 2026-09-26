# CLAUDE.md — build agent operating manual (Bean 2 Brew, Chennai)

You are the build agent for this repo. The human is not watching. Read this file fully once per session. It overrides your instincts about "helpful" behaviour.

## Read order

1. **`CLAUDE.md`**: once per session.
2. **`STATUS.md`**: the task checklist is your memory. The next task is the first `[ ]` line.
3. **`EXECUTION_PLAN.md`**: find which `plan/phase-N-*.md` holds that task.
4. **That one phase file**: never open a second phase file.
5. **Only the doc sections the task's `Read:` line names:**
   - `PRD.md`: behaviour
   - `CONTENT.md`: every word and number
   - `DESIGN.md`: look, motion, 3D
   - `TECH_STACK.md`: packages, budgets, tools
   - `ASSETS.md`: images

## Who owns what

| Topic | Owner |
|---|---|
| What exists and how it behaves | PRD.md |
| Visible words, numbers, data | CONTENT.md (verbatim) |
| Colour, type, layout, motion, 3D | DESIGN.md |
| Packages, versions, budgets, tools | TECH_STACK.md |
| Pass/fail | `scripts/check.sh` |
| What's done | STATUS.md |

If two docs conflict, follow the owner and log the conflict under STATUS → Open issues.

## The loop (per task)

1. Read the task block (Files / Read / Tools / Steps / Check / Done).
2. **Tools line:**
   - Use the listed plugin, MCP or bundled command if available.
   - For any library API you're unsure of, query Context7 before writing code.
   - If a tool is missing, proceed without it; `STATUS.md → Tooling:` already records what exists.
3. Touch only the files on the `Files:` line (plus `STATUS.md`, `qa/REPORT.md`). If you truly need another file, edit it and note why in STATUS → Decisions.
4. Run `bash scripts/check.sh <task-id>`.
   - **PASS:**
     - Tick the task `[x]` in STATUS.md.
     - Update the section table if relevant.
     - `git add -A && git commit -m "T#.#: <short description>"`.
   - **FAIL:**
     - Read the `FAIL` line and fix exactly that.
     - Run the check again. You get one retry. If it's still failing, use `/debug` for one more attempt.
     - Still failing:
       - Mark the task `[!]` in STATUS.
       - Append under Open issues: `T#.# BLOCKED: <exact FAIL line>`.
       - Make sure `npm run build` still passes (`git checkout -- <file>` for any file that breaks it).
       - Commit and move on.
5. Go to the next `[ ]` task. Never skip ahead. Never do two tasks in one commit.

## Hard rules

- **JS/JSX only.**
- **Packages:** only TECH_STACK §2–§3. Never change a version after T0.2. Never `npm install` anything else. That case is BLOCKED.
- **Zero runtime network from our code:**
  - None of `fetch(`, XHR, `axios`, `sendBeacon`, `WebSocket` or `EventSource` anywhere in `src/`.
  - The only external things are the OSM iframe and outbound links.
  - Forms are local state only (PRD §15).
- **3D is procedural:**
  - No `.glb`/`.gltf`/`.hdr`/image textures.
  - No drei helpers that download (`preset=`, `useGLTF`, remote fonts).
- **Read-only for you:**
  - `CLAUDE.md`, `PRD.md`, `CONTENT.md`, `DESIGN.md`, `TECH_STACK.md`, `ASSETS.md`, `KICKOFF.md`, `EXECUTION_PLAN.md`
  - `plan/**`
  - `scripts/**` (check.sh, make-fallback-art.mjs, loop-guard.sh), `SINGLE_LOOP.md`
  - `.claude/settings.json`
  - Never weaken or edit a check.
- **Copy comes from CONTENT.md verbatim.** A missing string gets the minimal neutral wording and a `Copy added:` note.
- **Never call image/video generation tools.** Imagery is human-supplied (ASSETS.md).
- **Follow DESIGN §5 (motion budget) and §9 (anti-template).** Adding motion not in §5 counts as a bug.
- **Re-scope down, never cut:** simpler visuals are acceptable; missing PRD sections are not. The hero has defined tiers (PRD §6).
- **Git:** never `git push`, `git reset --hard`, force, or rewrite history.

## Browser QA (Playwright MCP)

1. **Serve the production build** (run it in the background):
   ```bash
   npm run build && npx vite preview --port 4173 --strictPort
   ```
2. **Open** `http://localhost:4173`.
3. **Viewports:** 375×812, 768×1024, 1024×768, 1440×900.
4. **Overflow test** at each width:
   ```js
   document.documentElement.scrollWidth > window.innerWidth
   ```
   It must be `false`.
5. **Write findings** in `qa/REPORT.md` under a heading `## T#.#`:
   - what you checked
   - what failed
   - what you fixed
6. Screenshots are optional and gitignored.
7. Stop the preview server when done.

If Playwright is unavailable:
- Do the check by code inspection.
- Write `## T#.#` with "Playwright unavailable — code-inspected only".
- Set the related section to `Needs review`.

## Stop conditions (the only ones)

1. **T6.6 is complete.** Print a summary of at most 10 lines.
2. **The kickoff message scoped the run "through Phase N"** and that phase's checkpoint task is `[x]`. Print a summary of at most 5 lines. (Not used in single-loop mode, where the scope is always T6.6.)
3. **Every remaining task is blocked by the same external cause.** Say so plainly.

Otherwise never stop to ask. For an ambiguity, pick the reading closest to the docs' literal wording and log it under STATUS → Decisions.

## Single-loop mode (SINGLE_LOOP.md)

- A Stop hook (`scripts/loop-guard.sh`) runs whenever you try to end your turn. While `[ ]` tasks remain, it blocks the stop and names the next task.
- Treat its message as the human's instruction: continue with the named task. Don't argue with it and don't summarise first.
- **Re-read `CLAUDE.md` and `STATUS.md`:**
  - at every phase start
  - after any context compaction
  - Details from earlier phases may be gone after a compaction. STATUS.md is the truth.
- **Keep context lean:**
  - Don't paste large files or build logs back into the conversation.
  - Read the check's last line, not the whole log.

## Resuming

- A new session starts at the first `[ ]` task.
- You may retry each `[!]` task once when resuming. If it's fixed, mark it `[x]` and mark its Open-issues line `(resolved)`. Don't delete the line.
