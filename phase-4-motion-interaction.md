# Execution Plan — Phase 4

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-4 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-3-hero-3d.md](./phase-3-hero-3d.md)  
**Next:** [phase-5-a11y-seo-perf.md](./phase-5-a11y-seo-perf.md)

---

## Phase 4 — Motion & interaction

### T4.1 — Header scroll transition + active section
- **Files:** `src/components/Header.jsx`
- **Steps:**
  1. `useEffect` with a passive `scroll` listener: when `window.scrollY > 24`, add solid background (cream at 95% + slight blur) and a drop shadow; remove below.
  2. Active-section highlighting: `IntersectionObserver` over the 7 sections; the matching nav link gets `aria-current="true"` and terracotta color.
- **Verify:** `npm run build && grep -q "IntersectionObserver" src/components/Header.jsx && grep -q "scroll" src/components/Header.jsx`
- **Done:** header transitions on scroll; active link tracks the viewport.

### T4.2 — Scroll reveals (GSAP)
- **Files:** `src/lib/motion.js` (new), `src/App.jsx`, section components (add `data-reveal` to inner wrappers)
- **Steps:**
  1. `src/lib/motion.js`: export `prefersReducedMotion()` (same matchMedia logic, shared) and `initReveals()` — `gsap.registerPlugin(ScrollTrigger)`, then for each `[data-reveal]` element create a tween: `y: 24 → 0`, `opacity: 0 → 1`, `once: true`, trigger `top 85%`, and set the element's initial hidden state with GSAP (`gsap.fromTo` or `gsap.set` so content is never invisible if JS fails late — keep it simple).
  2. Call `initReveals()` from `App` in a `useEffect`, **only if** `!prefersReducedMotion()`.
  3. Add `data-reveal` to the inner content wrappers of MenuSection, StorySection, GallerySection, VisitUs, Newsletter, ContactSection.
- **Verify:** `npm run build && grep -q "ScrollTrigger" src/lib/motion.js && grep -rq "data-reveal" src/components/`
- **Done:** sections reveal on scroll; with reduced motion the site is fully visible with no animation.

### T4.3 — Micro-interactions (Framer Motion)
- **Files:** `src/components/Hero.jsx`, `src/components/MenuSection.jsx`
- **Steps:**
  1. Wrap the two hero CTAs in `motion.a` with `whileHover={{ scale: 1.02 }}` / `whileTap={{ scale: 0.98 }}`.
  2. Menu cards: `whileHover={{ y: -4 }}`.
  3. Gate: skip the motion props when `prefersReducedMotion()` (pass a plain element instead).
- **Verify:** `npm run build && grep -q "framer-motion" src/components/Hero.jsx`
- **Done:** hover/tap feedback on CTAs and cards; reduced-motion safe.

### T4.4 — Gallery lightbox
- **Files:** `src/components/GallerySection.jsx`
- **Steps:**
  1. `import Lightbox from 'yet-another-react-lightbox'`.
  2. State: `open` (bool) + `index` (number). Grid items get `onClick={() => { setIndex(i); setOpen(true) }}` and are keyboard-focusable buttons with `aria-label` ("Open image N of 6").
  3. `<Lightbox open={open} close={() => setOpen(false)} index={index} slides={...} />` where slides map the 6 images to `{ src, title: altText }`. The library's default controls already provide arrow navigation, Esc, and click-outside close — do not add your own.
- **Verify:** `npm run build && grep -q "yet-another-react-lightbox" src/components/GallerySection.jsx`
- **Done:** open / arrows / Esc / outside-click all work.

### T4.5 — Reduced-motion global verification
- **Files:** any file with an ungated animation
- **Steps:**
  1. Grep every animation entry point in `src/`: `gsap`, `ScrollTrigger`, `framer-motion`, `@keyframes`, `transition`, `<points>`, `useFrame`.
  2. Confirm each is gated by the reduced-motion check (hero: T3.2; reveals: T4.2; framer: T4.3; CSS scroll cue + steam blobs: hide via a `.reduce-motion` class on `<html>` set by `prefersReducedMotion()` in `App`).
  3. Fix anything ungated.
- **Verify:** `npm run build && grep -rq "prefersReducedMotion\|prefers-reduced-motion" src/lib/motion.js src/components/hero/Hero.jsx src/App.jsx`
- **Done:** with reduced motion on, the entire page renders fully with zero animation.

### T4.6 — Bundle budget check
- **Files:** `src/components/Hero.jsx` (only if splitting is needed)
- **Steps:**
  1. `npm run build`, then measure: `for f in dist/assets/*.js; do gzip -c "$f"; done | wc -c`.
  2. Budget: **< 400000** bytes total gzipped (TECH_STACK.md). Record the number in `STATUS.md`.
  3. If over: make the hero 3D a lazy chunk — `const HeroStage = React.lazy(() => import('./hero/HeroStage.jsx'))` wrapped in `<Suspense fallback={<HeroStaticFallback/>}>`. Re-measure.
- **Verify:** `npm run build && test $(for f in dist/assets/*.js; do gzip -c "$f"; done | wc -c) -lt 400000`
- **Done:** STATUS.md has the measured number under budget.

### T4.7 — Phase 4 checkpoint
- **Files:** `STATUS.md`
- **Steps:** update the motion/reduced-motion/lightbox rows; commit.
- **Verify:** `npm run build`
- **Done:** all interactive behavior from `PRD.md` §9–§13 works.

---

