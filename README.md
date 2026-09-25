# Bean-2-Brew

Demo site for a fictional cafe — the "premium $2,000 package" pitch build.

## Docs (source of truth)

| File | Role |
|---|---|
| [CLAUDE.md](./CLAUDE.md) | Build-agent loop protocol, hard rules, pinned decisions |
| [PRD.md](./PRD.md) | Requirements + all copy + fictional business data |
| [TECH_STACK.md](./TECH_STACK.md) | Pinned versions, plugins, performance budget |
| [EXECUTION_PLAN.md](./EXECUTION_PLAN.md) | The 28 atomic tasks the agent executes |
| [STATUS.md](./STATUS.md) | Live tracker (updated every task) |
| [PREREQUISITES.md](./PREREQUISITES.md) | Human-side environment setup (one-time) |
| [LOOP_PROMPT.md](./LOOP_PROMPT.md) | The exact prompt to paste into Claude Code |
| [tools/README.md](./tools/README.md) | Image-worker contract (model TBD) |

## Quick start (human)

```bash
npm install
npm run dev        # local dev
npm run build      # static build -> dist/
```

To run the full autonomous build: follow [PREREQUISITES.md](./PREREQUISITES.md), then paste the prompt from [LOOP_PROMPT.md](./LOOP_PROMPT.md) into `ccr code`.
