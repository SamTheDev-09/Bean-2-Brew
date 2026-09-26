# Execution Plan — Phase 5

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-5 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-4-motion-interaction.md](./phase-4-motion-interaction.md)  
**Next:** [phase-6-polish-pitch.md](./phase-6-polish-pitch.md)

---

## Phase 5 — Accessibility, SEO & performance

### T5.1 — Accessibility pass
- **Files:** all components + `src/index.css`
- **Steps:**
  1. Alt text on every `<img>` (specific, not "image"); `title` on the map iframe (done in T2.7 — verify).
  2. Heading order: exactly one `<h1>` (Hero), one `<h2>` per section, `<h3>` for menu item names. Fix any violation.
  3. Landmarks: `header`, `nav` (with `aria-label="Main"`), `main`, `section` elements with `aria-label` matching the section name, `footer`.
  4. Focus: add to `src/index.css` → `:focus-visible { outline: 2px solid var(--color-terracotta); outline-offset: 2px; }`.
  5. Contrast (pinned rule): body text espresso-on-cream only; terracotta for large text/graphics only; sage decorative only; footer cream-on-espresso.
- **Verify:** `npm run build && [ $(grep -r "<h1" src/ | wc -l) -eq 1 ] && grep -q "focus-visible" src/index.css`
- **Done:** PRD §18 accessibility checklist satisfied; note it in `STATUS.md`.

### T5.2 — SEO tags
- **Files:** `index.html`
- **Steps:**
  1. `<title>Bean 2 Brew — Slow Mornings, Made Right | Riverside Corner, Springfield, IL</title>`.
  2. Meta description (≤160 chars): `Small-batch coffee, fresh pastries, and slow mornings at Bean 2 Brew in Riverside Corner, Springfield. Open daily.`
  3. Open Graph: `og:title`, `og:description` (same as meta), `og:type=website`, `og:site_name=Bean 2 Brew`, `og:image=/img/hero-bg.*` (placeholder; add an HTML comment: replace with absolute URL after deployment).
- **Verify:** `grep -c "og:image" index.html && grep -q "meta name=\"description\"" index.html && npm run build`
- **Done:** unique title, meta description, and OG tags present.

### T5.3 — Analytics slot
- **Files:** `index.html`
- **Steps:** before `</head>` add exactly: `<!-- ANALYTICS SLOT: add Plausible or GA4 snippet here (not live in demo) -->`
- **Verify:** `grep -q "ANALYTICS SLOT" index.html`
- **Done:** insertion point exists; nothing live.

### T5.4 — Image optimization & CLS
- **Files:** `public/img/` + components
- **Steps:**
  1. Confirm every image served by the site is SVG or WebP. If T1.4 produced PNGs/JPEGs, convert: `cwebp -q 80 input -o output.webp` (if `cwebp` missing, note in `STATUS.md` and leave them).
  2. Every `<img>` has explicit `width`/`height` (or its wrapper has a fixed `aspect-ratio`) — no layout shift.
- **Verify:** `npm run build && ! find public/img -name "*.png" -o -name "*.jpg" | grep -q .`
- **Done:** no raster images in old formats; no CLS sources.

### T5.5 — FOUC & final build hygiene
- **Files:** `src/index.css`, `index.html`
- **Steps:**
  1. Fonts are self-hosted with `font-display: swap` (fontsource default) — verify no flash of missing font in build output (fonts listed as assets).
  2. Run `npm run build`; confirm no warnings about missing exports/unused files that indicate dead code; remove any dead file you created in a failed attempt.
- **Verify:** `npm run build`
- **Done:** clean build, no dead files.

### T5.6 — Phase 5 checkpoint
- **Files:** `STATUS.md`
- **Steps:** set SEO/a11y/performance rows to `Done`; commit.
- **Verify:** `npm run build`
- **Done:** hardening complete per `PRD.md` §18.

---

