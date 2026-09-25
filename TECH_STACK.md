# Tech Stack — Bean 2 Brew Demo Site

**Scope:** Supports the full-scope premium $2,000-tier PRD. See `PRD.md` for requirements and `EXECUTION_PLAN.md` for implementation order.

## Guiding principle

Pick the smallest stack that satisfies every functional requirement in the PRD — not the biggest possible stack. Every extra library adds context overhead for the local model and another surface area for breakage.

**The stack below is pinned and already committed** (`package.json` + `package-lock.json` + working scaffold). The build agent must not change versions, add dependencies, or re-scaffold.

## Environment

| Item | Requirement |
|---|---|
| Node.js | **22 LTS** (Vite 8 requires `^20.19.0 || >=22.12.0`). Check: `node -v` |
| Git | any recent version |
| Language | **JavaScript (`.jsx`) — not TypeScript.** Do not add `.ts`/`.tsx` files. |

## Core stack (pinned — verified 2026-09-25)

| Layer | Package | Pinned version | Notes |
|---|---|---|---|
| Build tool | `vite` | **8.3.1** | dev server + static build |
| React plugin | `@vitejs/plugin-react` | **6.1.1** | pairs with Vite 8 |
| UI framework | `react` / `react-dom` | **19.3.0** | R3F 9.x requires React 19 |
| Styling | `tailwindcss` + `@tailwindcss/vite` | **4.3.3** | v4 is CSS-first: tokens live in the `@theme` block in `src/index.css` (already committed). There is **no** `tailwind.config.js`. |
| 3D | `three` | **0.186.1** | used only for the hero steam field |
| 3D React | `@react-three/fiber` | **9.8.1** | declarative R3F |
| 3D helpers | `@react-three/drei` | **10.7.9** | installed for availability; the hero uses raw R3F + a code-generated texture — do not pull in drei helpers that fetch external assets |
| Scroll animation | `gsap` | **3.15.0** | + built-in `ScrollTrigger` plugin (no separate package) |
| Micro-interactions | `framer-motion` | **13.4.4** | import from `framer-motion`. **Do not install the `motion` package** — that is a different package name for a different workflow and would break imports. |
| Lightbox | `yet-another-react-lightbox` | **3.32.2** | default controls already include arrows, Esc, click-outside close |
| Fonts | `@fontsource/fraunces` / `@fontsource/inter` | **5.3.0** | self-hosted; already imported in `src/main.jsx`. No Google Fonts `<link>` — do not add one. |

## Functional-requirement choices

| Requirement | Choice | Notes |
|---|---|---|
| Menu category filtering | Plain React state | small dataset; no filter library |
| Gallery lightbox | `yet-another-react-lightbox` | default controls = arrows + Esc + outside-click |
| Map embed | **OpenStreetMap iframe, no API key** | exact URL is in task T2.7. Google Maps Embed API is the only alternative and is **not** used (it needs a key). |
| Contact + newsletter handling | Mock/no-op handlers, inline success | **No Formspree, no endpoint, no fetch — ever** for this demo. |
| Form validation | Native HTML5 + React state | no form library |
| SEO meta tags | Hand-written in `index.html` | single page; no `react-helmet-async` |
| Analytics-ready hook | Commented `<!-- ANALYTICS SLOT -->` in `index.html` `<head>` | not live |
| Reduced motion | shared `prefersReducedMotion()` in `src/lib/motion.js` | must gate R3F, GSAP, Framer Motion **and** CSS animations (see tasks T3.2, T4.2, T4.3, T4.5) |

## Explicitly not used

- **Babylon.js / PlayCanvas** — overkill for one hero moment.
- **Spline / Rive / Lottie** — external asset pipelines; not needed.
- **Locomotive Scroll** — only if native scroll + ScrollTrigger proves insufficient (it won't).
- **CMS / backend / payment** — outside PRD scope; content is hardcoded fictional data.
- **Formik / React Hook Form** — forms are tiny.
- **TypeScript** — deliberate choice to minimize failure surface for the 9B build agent.

## Claude Code plugins (skills) to install

The marketplace is `freshtechbro/claudedesignskills` (verified to exist; 26 plugins). Install **before** the loop, on the human machine — the build agent never installs anything:

```bash
claude plugin marketplace add freshtechbro/claudedesignskills
claude plugin install threejs-webgl@claudedesignskills
claude plugin install react-three-fiber@claudedesignskills
claude plugin install gsap-scrolltrigger@claudedesignskills
claude plugin install motion-framer@claudedesignskills
claude plugin install lightweight-3d-effects@claudedesignskills
```

All five names above were verified to exist in the marketplace. `lightweight-3d-effects` is only consulted if the hero is deferred to a lighter technique (T3.4); `locomotive-scroll@claudedesignskills` is **not** installed.

Keep the installed set at these five. Each installed skill adds context overhead for the local model — do not add more.

## Performance budget — non-negotiable

- **Total JS payload:** < **400 KB gzipped** across all of `dist/assets/*.js`. Measure: `for f in dist/assets/*.js; do gzip -c "$f"; done | wc -c`
- **3D:** procedural only — no glTF/Draco assets at all (the hero is a points cloud with a code-generated sprite texture). 60fps target on a mid-tier phone; dpr capped at 1.75.
- **Images:** SVG (default set) or WebP (if the image worker is configured). Every `<img>` gets explicit dimensions.
- **Motion fallback:** `prefers-reduced-motion` → static hero + no reveals; content must never be invisible or broken in that mode.

## Local LLM operating notes

Claude Code runs against a **9B local model**. Keep this in mind every loop:

- One task = one small change = one commit (see `EXECUTION_PLAN.md`).
- Read only the files a task lists. Do not re-read whole docs every iteration.
- If a task produces broken output two times, mark it BLOCKED and move on — the loop must never stall.
- If the model repeatedly emits broken tool calls, the human operator may switch that step to a hosted model (add a provider/route in the `claude-code-router` config) and resume the loop from `STATUS.md`.

## Deployment

Static build: `npm run build` → `dist/`.
Deploy target: **Vercel** free tier (or Netlify). Task T6.4 runs `npx vercel --yes --prod` only if the CLI is already authenticated on the machine; otherwise it records the exact follow-up in `STATUS.md`.

## Image pipeline (sub-agent) — model TBD

The image worker is a **pluggable component**: fixed interface, model not yet chosen.

- Contract: `tools/gen_image.sh <prompt> [reference_image] <output_path>` (exit 0 = success; 3 = not configured).
- Details, VRAM strategies, and the 8 prompt list: `tools/README.md`.
- The build loop uses it **only** if `tools/gen_image.sh --selftest` exits 0 (task T1.4); otherwise the committed SVG placeholders are the final image set. Nothing in the plan depends on the image worker.

## Source-of-truth rules

- `PRD.md` defines **what must exist**.
- `TECH_STACK.md` defines **how it is built** — versions pinned; no deviations in-loop.
- `EXECUTION_PLAN.md` defines **when and in what order**.
- `STATUS.md` defines **what is actually done / blocked**.
- `CLAUDE.md` defines **how the agent works**.

When documents appear to conflict: do not silently change scope. Record the conflict in `STATUS.md` (Open issues) and follow the file listed above that owns the topic.
