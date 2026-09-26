# Phase 1 — Foundations

**Previous:** [phase-0-scaffold.md](./phase-0-scaffold.md) · **Next:** [phase-2-sections.md](./phase-2-sections.md)

### T1.1 — Tokens, fonts, base CSS
- **Files:** `src/index.css`, `src/main.jsx`
- **Read:** DESIGN §2, §3, §4 (first four bullets), §5 (easing/durations, reduced motion)
- **Tools:** frontend-design, Context7 (Tailwind v4 `@theme`)
- **Steps:**
  1. In `src/index.css`, after `@import "tailwindcss";`, add an `@theme` block with:
     - `--color-decoction/roast/jasmine/kraft/brass/kumkum` (exact hex values)
     - `--font-display`, `--font-sans` (stacks from DESIGN §3)
     - `--ease-pour`
  2. Base layer:
     - `html { scroll-padding-top: 5rem; }`
     - `body` with decoction background, jasmine text, `font-sans`, 1.0625rem/1.65, antialiased
     - `::selection` with brass background and decoction text
     - `:focus-visible { outline: 2px solid var(--color-brass); outline-offset: 3px; }`
     - utility classes for the h1/h2 fluid sizes (e.g. `.text-h1`, `.text-h2`)
  3. Add a `@media (prefers-reduced-motion: reduce)` rule that makes animations and transitions effectively instant and sets `scroll-behavior: auto`.
  4. In `src/main.jsx`, import `@fontsource/rozha-one/400.css` and `@fontsource/hind-madurai/400.css`, `500.css`, `600.css` (or the Fraunces/Inter fallbacks if T0.2 logged them).
- **Check:** `bash scripts/check.sh T1.1`
- **Done:** tokens, fonts, focus ring and reduced-motion rule are in place.

### T1.2 — `src/data/site.js`
- **Files:** `src/data/site.js`
- **Read:** CONTENT §1
- **Tools:** none
- **Steps:** export `SITE` with every key from CONTENT §1 (`social: { instagram, facebook }`), plus `export const STUDIO = "Aroha Rudran Group"`. Values verbatim.
- **Check:** `bash scripts/check.sh T1.2`
- **Done:** business data importable.

### T1.3 — `src/data/menu.js`
- **Files:** `src/data/menu.js`
- **Read:** CONTENT §3
- **Tools:** none
- **Steps:**
  1. Export `MENU_TABS` (5 entries).
  2. Export `menuItems`: 13 objects `{ id, name, tab, price, description, tag }`.
     - `price` is a number
     - `tag` is a string or `null`
     - `id` is the kebab-case name
- **Check:** `bash scripts/check.sh T1.3`
- **Done:** 13 items, verbatim.

### T1.4 — `src/data/process.js` and `src/data/reviews.js`
- **Files:** `src/data/process.js`, `src/data/reviews.js`
- **Read:** CONTENT §4, §7
- **Tools:** none
- **Steps:**
  1. Export `processSteps`: 4 objects `{ n, imageId, title, body }`.
  2. Export `reviews`: 3 objects `{ quote, name, area }`.
- **Check:** `bash scripts/check.sh T1.4`
- **Done:** both data files exist, verbatim.

### T1.5 — Fallback art
- **Files:** `src/assets/img/*.svg` (generated)
- **Read:** ASSETS §1
- **Tools:** none
- **Steps:**
  1. Run `node scripts/make-fallback-art.mjs`. It writes an SVG for every image id that has no real photo yet, and never overwrites a `.webp`/`.jpg`.
  2. Do not hand-edit the script.
- **Check:** `bash scripts/check.sh T1.5`
- **Done:** every image id resolves to a file.

### T1.6 — `src/data/assets.js` (image manifest)
- **Files:** `src/data/assets.js`
- **Read:** ASSETS §1, §3 (aspect column), CONTENT §6
- **Tools:** Context7 (Vite `import.meta.glob`)
- **Steps:**
  1. Load every image eagerly as URLs:
     ```js
     const files = import.meta.glob('../assets/img/*.{webp,jpg,jpeg,png,svg}', { eager: true, query: '?url', import: 'default' })
     ```
  2. For each of the 13 ids, pick by priority webp → jpg → jpeg → png → svg.
  3. Export `IMAGES`: `{ [id]: { src, alt, width, height, isFallback } }`.
     - `width`/`height` come from the ASSETS §3 size column.
     - `alt` comes from CONTENT §6.
  4. Export `getImage(id)`, which throws on an unknown id.
- **Check:** `bash scripts/check.sh T1.6`
- **Done:** components never hard-code image paths.

### T1.7 — `src/lib/env.js`
- **Files:** `src/lib/env.js`
- **Read:** PRD §16 (reduced motion), DESIGN §6 (low-power heuristic)
- **Tools:** none
- **Steps:** export these, each safe to call where `window`/`document` are undefined (then return `false`):
  1. `prefersReducedMotion()`: a boolean via `matchMedia`.
  2. `usePrefersReducedMotion()`: a React hook using `useSyncExternalStore` that subscribes to the media query change event.
  3. `hasWebGL()`: creates a canvas and tries `webgl2` then `webgl`.
  4. `isLowPowerDevice()`: `navigator.hardwareConcurrency <= 4 || navigator.deviceMemory <= 4`.
- **Check:** `bash scripts/check.sh T1.7`
- **Done:** helpers import cleanly in Node (the check imports them).

### T1.8 — Page shell
- **Files:** `src/App.jsx`
- **Read:** PRD §4, CONTENT h2 lines
- **Tools:** none
- **Steps:**
  1. Render:
     - a `<header>` with the wordmark text
     - `<main id="main">` with sections, in order: `id="hero"` (no heading yet), `menu`, `process`, `story`, `gallery`, `reviews`, `reserve`, `visit`, each with its CONTENT h2
     - `<footer>` containing `<section id="newsletter"><h2>Roast notes</h2></section>`
  2. No styling beyond tokens.
- **Check:** `bash scripts/check.sh T1.8`
- **Done:** all 9 ids exist in order.
