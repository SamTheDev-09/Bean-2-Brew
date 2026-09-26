# Phase 4 — Motion system

**Previous:** [phase-3-hero-3d.md](./phase-3-hero-3d.md) · **Next:** [phase-5-a11y-seo-perf.md](./phase-5-a11y-seo-perf.md)

**Recommended model:** Opus.

**Budget:** DESIGN §5 is the complete list of allowed motion. Anything else is a bug.

**Reduced motion:** every task must leave the site fully usable and fully visible with reduced motion on.

### T4.1 — Lenis and GSAP setup
- **Files:** `src/lib/motion.js`, `src/App.jsx`
- **Read:** DESIGN §5 (smooth scroll), PRD §5
- **Tools:** Context7 (lenis, gsap ScrollTrigger)
- **Steps:**
  1. `motion.js`:
     - `gsap.registerPlugin(ScrollTrigger, SplitText)`
     - re-export `prefersReducedMotion` from `env.js`
     - `export function initSmoothScroll()`:
       - if reduced motion, return a no-op cleanup
       - else create `new Lenis({ lerp: 0.1 })`
       - `lenis.on('scroll', ScrollTrigger.update)`
       - `gsap.ticker.add(t => lenis.raf(t * 1000))`
       - `gsap.ticker.lagSmoothing(0)`
       - intercept clicks on `a[href^="#"]` to call `lenis.scrollTo(target, { offset: -72 })`
       - return a cleanup that destroys everything
     - `export function getLenis()` for other modules
  2. In `App`: call `initSmoothScroll()` in a `useEffect` with cleanup.
- **Check:** `bash scripts/check.sh T4.1`
- **Done:** smooth scrolling with correct anchor offsets; native scroll under reduced motion.

### T4.2 — Preloader and hero intro
- **Files:** `src/components/Preloader.jsx`, `src/components/Hero.jsx`, `src/App.jsx`
- **Read:** DESIGN §5 (page load), PRD §5 (preloader)
- **Tools:** Context7 (gsap SplitText), frontend-design
- **Steps:**
  1. **`Preloader`:**
     - Fixed full-screen decoction, `aria-hidden="true"`, `pointer-events: none` once it starts exiting.
     - Centred brass-outline tumbler SVG whose inner fill rises via clip-path over 1.2s, with the wordmark below.
     - Then a wipe-up exit (0.6s) and unmount.
     - Hard cap: fully gone by 1.8s after mount.
     - Show only if `!prefersReducedMotion()` and `sessionStorage['b2b-seen']` is not set; then set it.
     - Wrap sessionStorage in try/catch.
     - Calls `onDone()` when it finishes.
  2. **Hero intro**, run once after the preloader finishes (or immediately if the preloader was skipped and motion is allowed):
     - `SplitText.create(h1, { type: 'lines', mask: 'lines' })`
     - `gsap.from(lines, { yPercent: 100, stagger: 0.08, duration: 0.7, ease: 'power3.out' })`
     - then the subhead and CTAs `opacity 0 → 1`
     - Revert the SplitText on cleanup.
     - If the SplitText import fails, animate the whole h1 as one block and log it in Decisions.
  3. Under reduced motion there is no preloader and no intro; everything is visible at once.
- **Check:** `bash scripts/check.sh T4.2`
- **Done:** one orchestrated load moment, capped at 1.8s.

### T4.3 — Hero pin drives the pour
- **Files:** `src/components/Hero.jsx`
- **Read:** DESIGN §5 (set piece 1), PRD §6
- **Tools:** Context7 (ScrollTrigger `pin`, `scrub`, `gsap.matchMedia`)
- **Steps:**
  1. `gsap.matchMedia()`:
     - `(prefers-reduced-motion: no-preference) and (min-width: 768px)` → pin `#hero`, `end: '+=100%'`, `scrub: 0.6`
     - the no-preference, narrower query → `end: '+=60%'`
     - `onUpdate: self => { progressRef.current = self.progress }`
  2. Start `progressRef` at 0 when motion is allowed, and at 1 under reduced motion.
  3. Fade the "Scroll to pour" hint out over the first 15% of progress.
  4. Revert the matchMedia on unmount.
  5. Tier C: pin anyway (text stays) but there's nothing to drive. Skip the pin if STATUS says Tier C.
- **Check:** `bash scripts/check.sh T4.3`
- **Done:** scrolling raises the tumbler and lengthens the pour; the release into the menu is clean.

### T4.4 — Process horizontal scroll
- **Files:** `src/components/ProcessSection.jsx`
- **Read:** PRD §8, DESIGN §4 (process) + §5 (set piece 2)
- **Tools:** Context7 (ScrollTrigger horizontal pin pattern, `gsap.matchMedia`)
- **Steps:**
  1. Under `(min-width: 1024px) and (prefers-reduced-motion: no-preference)`:
     - lay the `[data-process-track]` panels out in a row (80vw each, max 1100px)
     - pin the section
     - tween the track `x` to `-(track.scrollWidth - window.innerWidth + padding)`
     - `scrub: 1`, `end: () => '+=' + distance`, `invalidateOnRefresh: true`
  2. Otherwise keep the vertical Phase 2 layout.
  3. Revert on unmount and on breakpoint change.
- **Check:** `bash scripts/check.sh T4.4`
- **Done:** desktop scrolls sideways through the 4 steps; mobile and reduced motion stay vertical.

### T4.5 — Header states and mobile menu motion
- **Files:** `src/components/Header.jsx`
- **Read:** PRD §5, DESIGN §5 (user-triggered)
- **Tools:** Context7 (framer-motion `AnimatePresence`)
- **Steps:**
  1. **Solid state:** past `scrollY > 24`, decoction background plus the brass hairline.
  2. **Hide/show:** after the hero, hide on scroll down (translateY -100%) and show on scroll up.
     - Read scroll from Lenis if present, else `window` (passive listener).
     - Never hide while the mobile menu is open or focus is inside the header.
  3. **Active section:** IntersectionObserver over the 8 main sections (`rootMargin: '-45% 0px -50% 0px'`) sets `aria-current="true"` plus brass text on the matching link.
  4. **Mobile overlay:** `AnimatePresence` fade plus a 24px slide (400ms, `--ease-pour`) with the links staggered by 40ms.
- **Check:** `bash scripts/check.sh T4.5`
- **Done:** the header behaves per PRD §5.

### T4.6 — Menu filter animation
- **Files:** `src/components/MenuSection.jsx`
- **Read:** DESIGN §5 (tab indicator, item layout)
- **Tools:** Context7 (framer-motion `layout`, `layoutId`, `AnimatePresence mode="popLayout"`)
- **Steps:**
  1. Active tab pill becomes `<motion.span layoutId="menu-tab-pill">`.
  2. Items become `<motion.li layout>` inside `<AnimatePresence mode="popLayout" initial={false}>`, keyed by `id`.
     - Enter: `opacity 0 → 1`, `y 8 → 0`. Exit: `opacity → 0`. 300ms.
  3. The board height animates with `layout` on its container.
- **Check:** `bash scripts/check.sh T4.6`
- **Done:** filtering glides without layout jumps.

### T4.7 — Reservation transitions
- **Files:** `src/components/reserve/ReserveSection.jsx`
- **Read:** DESIGN §5 (step transitions, stamp), PRD §12 (focus rules)
- **Tools:** Context7 (framer-motion `AnimatePresence` custom direction)
- **Steps:**
  1. Steps are wrapped in `<AnimatePresence mode="wait" custom={direction}>`.
     - Forward: enter from x 24, exit to x -24. Backward is reversed. Fade, 400ms.
  2. After each transition completes, focus the step heading (`onAnimationComplete` or effect). Keep the T2.9 focus rules.
  3. Confirmation stamp on the token: `scale 1.4 → 1`, `rotate -8deg → -4deg`, opacity 0 → 1, 300ms.
  4. Time slot toggles: brass fill transition, 200ms.
- **Check:** `bash scripts/check.sh T4.7`
- **Done:** steps feel continuous; keyboard focus is never lost.

### T4.8 — Gallery lightbox
- **Files:** `src/components/GallerySection.jsx`
- **Read:** PRD §10
- **Tools:** Context7 (yet-another-react-lightbox)
- **Steps:**
  1. `import Lightbox from 'yet-another-react-lightbox'` and `import 'yet-another-react-lightbox/styles.css'`.
  2. State: `index` (−1 means closed). Each tile button calls `setIndex(i)`.
  3. `<Lightbox open={index >= 0} index={index} close={() => setIndex(-1)} slides={images.map(i => ({ src: i.src, alt: i.alt, width: i.width, height: i.height }))} />`.
  4. Use the default controls only. Theme the backdrop to decoction via the library's CSS variables.
- **Check:** `bash scripts/check.sh T4.8`
- **Done:** open, arrows, Esc, click-outside and swipe all work.

### T4.9 — Reduced-motion audit
- **Files:** `src/App.jsx`, plus any file with ungated motion
- **Read:** DESIGN §5 (reduced motion), PRD §16
- **Tools:** Context7 (framer-motion `MotionConfig`)
- **Steps:**
  1. Wrap the app in `<MotionConfig reducedMotion="user">`.
  2. Grep `src/` for `gsap`, `ScrollTrigger`, `SplitText`, `Lenis`, `@keyframes`, `animation:`, `motion.`, `useFrame`. Confirm each is gated:
     - `matchMedia` no-preference
     - or `prefersReducedMotion()`
     - or MotionConfig
     - or the CSS media rule
  3. Fix anything ungated.
  4. Log the audit result as one line in STATUS → Decisions.
- **Check:** `bash scripts/check.sh T4.9`
- **Done:** with reduced motion, the page is complete and still.

### T4.10 — Phase 4 checkpoint (budget and QA)
- **Files:** `STATUS.md`, `qa/REPORT.md`, plus any fixes
- **Read:** TECH_STACK §6
- **Tools:** Playwright MCP, Chrome DevTools MCP (optional), `/code-review` (diff since T3.6)
- **Steps:**
  1. Build and read the budget line from the check output. Record `**Bundle:**` in STATUS.
  2. **If the entry chunk is over budget:** confirm `PourScene` is only imported lazily, and move `yet-another-react-lightbox` behind `React.lazy` in GallerySection.
  3. **Playwright at 1440 and 375:**
     - scroll through the hero pin (screenshot mid-pin) and the process track
     - check the header hide/show
     - check menu filtering
     - do a full reservation
     - open and close the lightbox
  4. Run `/code-review`, fix, and write `## T4.10`.
- **Check:** `bash scripts/check.sh T4.10`
- **Done:** all motion works, the budget is met, and it's reviewed.
