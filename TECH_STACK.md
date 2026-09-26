# TECH STACK — packages, tooling, budgets

## 1. Environment and model

| Item | Requirement |
|---|---|
| Node.js | 22 LTS (`node -v`). Vite 8 needs `^20.19.0 \|\| >=22.12.0` |
| Shell | bash. On Windows, Claude Code uses Git Bash; `scripts/check.sh` needs it |
| Git | any recent version |
| Language | JavaScript/JSX only. No `.ts`/`.tsx` |
| Model | Hosted Claude via Claude Code. **Opus is recommended for Phases 3–4** (3D shader + GSAP choreography). Sonnet is fine for 0–2 and 5–6. Do not run this build on a small local model. |

## 2. Pinned core (exact versions, installed with `--save-exact` in T0.2)

| Package | Version | Use |
|---|---|---|
| react, react-dom | 19.3.0 | UI |
| vite | 8.3.1 (dev) | build/dev server |
| @vitejs/plugin-react | 6.1.1 (dev) | JSX |
| tailwindcss, @tailwindcss/vite | 4.3.3 (dev) | CSS-first styling. Tokens live in `@theme` in `src/index.css`. There is no `tailwind.config.js` |
| three | 0.186.1 | hero only |
| @react-three/fiber | 9.8.1 | hero scene |
| @react-three/drei | 10.7.9 | **only** `Environment` + `Lightformer`. Nothing that downloads assets (no presets, `useGLTF`, remote fonts, `Text`) |
| gsap | 3.15.0 | ScrollTrigger (pins/scrub) + SplitText (hero lines). Both ship inside the `gsap` package |
| framer-motion | 13.4.4 | layout/exit animations, `MotionConfig`. Import from `framer-motion`. Do **not** install `motion` |
| yet-another-react-lightbox | 3.32.2 | gallery lightbox; import its `styles.css` |

## 3. Allowed additions (latest at install time, `--save-exact`, versions recorded in STATUS)

| Package | Use | If install fails |
|---|---|---|
| lenis | smooth scroll synced to the GSAP ticker | BLOCKED (T0.2) |
| @fontsource/rozha-one | display face | use `@fontsource/fraunces@5.3.0` + log |
| @fontsource/hind-madurai | body + Tamil | use `@fontsource/inter@5.3.0` + log |

**Nothing else may be installed.** A task that seems to need another package is BLOCKED, not `npm install`.

## 4. Explicitly not used

- **These libraries:**
  - `motion` (different package)
  - `@react-three/postprocessing` (bundle cost)
  - Spline, Lottie, Rive
  - Locomotive Scroll
  - react-helmet
  - form libraries
  - date-picker libraries (native `<input type="date">` plus a custom slot grid is enough)
  - TypeScript
- **Anything network-bound:** any backend, CMS, analytics script, or form relay.

## 5. Claude Code tooling

**Bundled, nothing to install:**

| Command | Used for |
|---|---|
| `/run`, `/verify` | launching and eyeballing the app when Playwright isn't enough |
| `/code-review` | every phase checkpoint |
| `/security-review` | T6.2 |
| `/simplify` | T5.6 |
| `/debug` | any task stuck after one failed attempt |

**Plugins (install once, see KICKOFF.md):**

| Plugin | Why |
|---|---|
| `frontend-design@claude-plugins-official` | design judgement for every UI task; keeps output away from template looks |
| `context7@claude-plugins-official` | current docs for R3F 9, drei 10, GSAP 3.15 (SplitText/ScrollTrigger), Lenis, framer-motion 13, Tailwind 4, which can be newer than the model's training |

**MCP servers:**

| Server | Status | Why |
|---|---|---|
| Playwright (`@playwright/mcp`) | **required** | the agent opens the built site, checks 4 breakpoints, tests forms, keyboard path, lightbox, and the 3D hero |
| Chrome DevTools (`chrome-devtools-mcp`) | optional | performance traces for the hero's fps and LCP (T3.5, T4.10) |
| Higgsfield (`https://mcp.higgsfield.ai/mcp`) | optional, **asset session only** | photoreal images per ASSETS.md. **Blocked in the build loop** by `.claude/settings.json` (it spends credits) |

**If a tool is unavailable:** do the task without it and record it in `STATUS.md` → `Tooling:`.

## 6. Budgets (checked by `scripts/check.sh`)

| Metric | Limit |
|---|---|
| Entry chunk `dist/assets/index-*.js`, gzipped | < 280,000 bytes |
| All `dist/assets/*.js`, gzipped | < 700,000 bytes |
| Hero 3D | lazy chunk (`React.lazy`), never in the entry chunk |
| Each photo in `src/assets/img/` | ≤ 350 KB, long edge ≤ 1600px |
| LCP (hero text) | < 2.5s on throttled mobile (checked by trace if DevTools MCP is present) |
| Hero frame rate | ≥ 30fps on a mid-range profile, else tier down (PRD §6) |

## 7. Deployment

- `npm run build` produces `dist/`. Target is Vercel.
- T6.5 deploys only if `vercel whoami` succeeds; otherwise it logs the exact command for the human.
