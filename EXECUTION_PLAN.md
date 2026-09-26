# EXECUTION PLAN — index

**Running everything in one session?** See `SINGLE_LOOP.md`. The phases and tasks below are identical; only the session handling differs.

The task bodies live in `plan/`, one file per phase. Open only the phase that holds the first `[ ]` task in `STATUS.md`.

Every task follows the same shape:
- **Files:** what you may touch
- **Read:** the doc sections to read
- **Tools:** plugins, MCPs or bundled commands to use
- **Steps:** what to do
- **Check:** `bash scripts/check.sh <id>`
- **Done:** the finish line

## Phases

| Phase | Tasks | File | Outcome | Suggested model |
|---|---|---|---|---|
| 0 | T0.1–T0.3 | `plan/phase-0-scaffold.md` | Fresh Vite/React/Tailwind project, pinned deps, tooling inventory | Sonnet |
| 1 | T1.1–T1.8 | `plan/phase-1-foundations.md` | Tokens, fonts, all data files, fallback art, image manifest, env helpers, page shell | Sonnet |
| 2 | T2.1–T2.14 | `plan/phase-2-sections.md` | Every section built and working, static (no GSAP/Lenis/3D) | Sonnet |
| 3 | T3.1–T3.6 | `plan/phase-3-hero-3d.md` | The metre-pour scene, tiers, fallback, perf | **Opus** |
| 4 | T4.1–T4.10 | `plan/phase-4-motion.md` | Lenis, preloader + SplitText intro, hero pin, process scroll, UI transitions, lightbox | **Opus** |
| 5 | T5.1–T5.7 | `plan/phase-5-a11y-seo-perf.md` | Accessibility, keyboard QA, SEO + JSON-LD, images, budget | Sonnet |
| 6 | T6.1–T6.6 | `plan/phase-6-ship.md` | Copy/design audit, security, final checks, visual QA, deploy, report | Sonnet |

## Tool map (quick view)

| Tasks | Tools |
|---|---|
| All UI tasks in phases 2 and 4 | `frontend-design` skill |
| Any task using R3F, drei, GSAP, Lenis, framer-motion, the lightbox or Tailwind APIs | Context7 |
| T2.14, T3.5, T4.10, T5.2, T6.4 | Playwright MCP |
| T3.5, T4.10 | Chrome DevTools MCP (optional perf trace) |
| T2.14, T3.6, T4.10, T5.7 | `/code-review` (diff since the previous checkpoint) |
| T5.6 | `/simplify` |
| T6.2 | `/security-review` |
| Any failed task | `/debug` (one attempt) |

## File map (final state)

```
index.html                       SEO, JSON-LD, analytics slot
vite.config.js
public/favicon.svg               brass tumbler mark (T5.3)
public/og-cover.jpg              human-supplied (ASSETS.md)
scripts/check.sh                 task checks (read-only)
scripts/make-fallback-art.mjs    SVG fallback generator (read-only)
qa/REPORT.md                     browser QA log
src/main.jsx  src/App.jsx  src/index.css
src/data/site.js                 business data + STUDIO
src/data/menu.js                 MENU_TABS, menuItems
src/data/process.js              processSteps
src/data/reviews.js              reviews
src/data/assets.js               IMAGES, getImage(id) via import.meta.glob
src/lib/env.js                   prefersReducedMotion, usePrefersReducedMotion, hasWebGL, isLowPowerDevice
src/lib/reservation.js           pure booking logic (+ .ics)
src/lib/motion.js                Lenis + GSAP setup
src/assets/img/*                 photos (webp/jpg) or fallback svgs
src/components/Header.jsx  Preloader.jsx  Hero.jsx
src/components/hero/PourScene.jsx  hero/HeroFallback.jsx
src/components/MenuSection.jsx  ProcessSection.jsx  StorySection.jsx
src/components/GallerySection.jsx  ReviewsSection.jsx
src/components/reserve/ReserveSection.jsx
src/components/VisitSection.jsx  ContactForm.jsx
src/components/Newsletter.jsx  Footer.jsx  MobileReserveBar.jsx
```
