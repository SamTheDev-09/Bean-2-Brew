# Phase 5 — Accessibility, SEO and performance

**Previous:** [phase-4-motion.md](./phase-4-motion.md) · **Next:** [phase-6-ship.md](./phase-6-ship.md)

### T5.1 — Accessibility pass
- **Files:** any component, `src/index.css`
- **Read:** PRD §16 (accessibility), DESIGN §2 (allowed pairs)
- **Tools:** frontend-design
- **Steps:**
  1. **Landmarks:**
     - `header`, `nav aria-label="Main"`, `main id="main"`, `footer`
     - every section has an `aria-labelledby` pointing at its h2 (hero: `aria-label="Welcome"`)
  2. **Headings:** one h1; one h2 per section; h3 for menu item names, process step titles, reservation step titles and "Write to us".
  3. **Every `<img>`:** has `alt` from `IMAGES`. Decorative SVGs are `aria-hidden`.
  4. **Forms:**
     - every input has a `<label htmlFor>`
     - errors are linked with `aria-describedby`; invalid fields get `aria-invalid`
     - success messages sit in `aria-live="polite"`
  5. **Colour:** only DESIGN §2 allowed pairs. Remove any reduced-opacity body text.
  6. **Targets and focus:** touch targets ≥ 44px on mobile; focus is visible on every interactive element (including the lightbox tiles and slot buttons).
- **Check:** `bash scripts/check.sh T5.1`
- **Done:** PRD §16 accessibility is satisfied in code.

### T5.2 — Keyboard and screen-reader QA
- **Files:** fixes, `qa/REPORT.md`
- **Read:** CLAUDE.md → Browser QA
- **Tools:** Playwright MCP (keyboard presses plus accessibility snapshot)
- **Steps:**
  1. At 1440, using only Tab, Shift+Tab, Enter, Space, the arrow keys and Esc:
     - skip link → main
     - nav links
     - menu tabs (arrows)
     - the whole reservation, including the error path and "Add to calendar"
     - gallery tile → lightbox → Esc returns focus to the tile
     - contact form
     - newsletter
  2. At 375: the mobile menu focus trap and return.
  3. In the accessibility snapshot, look for unnamed buttons/links/images and fix them.
  4. Write `## T5.2`.
- **Check:** `bash scripts/check.sh T5.2`
- **Done:** a full keyboard path with no unnamed controls.

### T5.3 — SEO, OG, JSON-LD, favicon
- **Files:** `index.html`, `public/favicon.svg`
- **Read:** CONTENT §11
- **Tools:** none
- **Steps:**
  1. In `index.html` `<head>`:
     - the title
     - meta description
     - `theme-color` `#1F130D`
     - OG tags
     - the Twitter card
     - `<link rel="icon" href="/favicon.svg" type="image/svg+xml">`
     - the `CafeOrCoffeeShop` JSON-LD from CONTENT §11 in `<script type="application/ld+json">`, with `<!-- demo data -->` above it
  2. `public/favicon.svg`: a minimal brass tumbler silhouette on decoction, under 1 KB.
  3. **If `public/og-cover.jpg` is missing:** keep the tag and add an Open issue: "og-cover.jpg not supplied (ASSETS.md)".
- **Check:** `bash scripts/check.sh T5.3`
- **Done:** complete head metadata.

### T5.4 — Analytics slot
- **Files:** `index.html`
- **Read:** PRD §16
- **Tools:** none
- **Steps:** before `</head>`, add exactly `<!-- ANALYTICS SLOT: add Plausible or GA4 here after the client signs. Not live in the demo. -->`
- **Check:** `bash scripts/check.sh T5.4`
- **Done:** an insertion point exists and nothing is live.

### T5.5 — Images and CLS
- **Files:** components that render images
- **Read:** TECH_STACK §6, DESIGN §8
- **Tools:** none
- **Steps:**
  1. **Every `<img>`:**
     - `width` and `height` from `IMAGES`
     - `decoding="async"`
     - `loading="lazy"`, except images visible in the first viewport
     - `object-cover` inside an aspect-ratio wrapper
  2. **Photos:** list any real photo in `src/assets/img/` over 350 KB as an Open issue for the human. Do not recompress with new tools.
- **Check:** `bash scripts/check.sh T5.5`
- **Done:** no layout shift sources.

### T5.6 — Budget and simplify
- **Files:** any
- **Read:** TECH_STACK §6
- **Tools:** `/simplify`
- **Steps:**
  1. Run `/simplify` on the codebase. Accept only behaviour-preserving changes.
  2. Remove dead files from failed attempts.
  3. Record the budget line in STATUS `**Bundle:**`.
- **Check:** `bash scripts/check.sh T5.6`
- **Done:** clean code, budget met.

### T5.7 — Phase 5 checkpoint
- **Files:** `STATUS.md`, `qa/REPORT.md`
- **Read:** —
- **Tools:** `/code-review` (diff since T4.10)
- **Steps:** review, fix, update the SEO and accessibility rows, and write `## T5.7`.
- **Check:** `bash scripts/check.sh T5.7`
- **Done:** hardening complete.
