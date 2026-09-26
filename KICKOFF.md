# KICKOFF — what you (the human) do

These docs build a **brand-new** site in a **fresh folder**. Do not drop them into the old Springfield repo.

## 1. Set up the folder (once)

```bash
mkdir bean2brew && cd bean2brew && git init
# copy in everything from this docs pack: *.md, plan/, scripts/, .claude/
git add -A && git commit -m "Docs: Bean 2 Brew Chennai build plan"
```

Needs Node 22 LTS and Git. On Windows, install Git for Windows; Claude Code runs commands in Git Bash.

## 2. Install tools (once, in a terminal)

```bash
# Required: the agent's eyes (browser QA)
claude mcp add playwright -- npx @playwright/mcp@latest

# Optional: performance traces for the 3D hero
claude mcp add chrome-devtools -- npx chrome-devtools-mcp@latest

# Optional, asset session only (ASSETS.md). User scope; blocked inside this repo by .claude/settings.json
claude mcp add --transport http --scope user higgsfield https://mcp.higgsfield.ai/mcp
```

Then inside Claude Code:

```
/plugin install frontend-design@claude-plugins-official
/plugin install context7@claude-plugins-official
/mcp                # log in to Higgsfield if you added it; confirm playwright is connected
/permissions        # confirm .claude/settings.json loaded without errors
```

If `/permissions` reports a rule it can't parse, fix that one line. Rule syntax changes between Claude Code versions.

## 3. Run the build

**One uninterrupted run:** follow `SINGLE_LOOP.md` instead of the split below.

Recommended split (the loop resumes from STATUS.md, so sessions are interchangeable):

| Session | Model (`/model`) | Scope |
|---|---|---|
| 1 | sonnet | through Phase 2 |
| 2 | opus | through Phase 4 |
| 3 | sonnet | to the end |

**Kickoff prompt** (paste into `claude`, change the last line per session):

> You are the build agent. Read CLAUDE.md fully and follow it exactly. Then open STATUS.md and work task by task from the first unchecked task using the loop in CLAUDE.md. Run `bash scripts/check.sh <task-id>` for every task, commit after each pass, and don't stop to ask me questions. Log decisions in STATUS.md.
> Scope: run through Phase 2, then stop.

- For the last session, replace the scope line with: `Scope: run to T6.6.`
- Press **Shift+Tab** to switch to auto-accept edits so the loop doesn't wait on you. The settings file pre-approves the commands it needs.

## 4. While it runs (optional, any time before Phase 6)

Generate the photos in a separate Higgsfield session (ASSETS.md §4). Drop them into `src/assets/img/` and `public/og-cover.jpg`. The next build picks them up automatically.

## 5. After T6.6

Read `STATUS.md → ## Final report` and handle the human follow-ups:
- **og-cover:** supply `public/og-cover.jpg` if the report says it's missing.
- **Studio credit:** confirm the `STUDIO` spelling in `src/data/site.js`.
- **Map pin:** check the map pin position.
- **Photos:** add real photos if the site is still on fallback art.
- **Deploy:** run the deploy command if it's pending.
