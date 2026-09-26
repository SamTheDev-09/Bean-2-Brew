# Execution Plan — Phase 1

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-1 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-0-environment.md](./phase-0-environment.md)  
**Next:** [phase-2-static-skeleton.md](./phase-2-static-skeleton.md)

---

## Phase 1 — Design system & assets

### T1.1 — Confirm design tokens
- **Files:** `src/index.css` (edit only if something is missing)
- **Steps:**
  1. Confirm `src/index.css` contains the `@theme` block with `--color-cream: #F5EDE2`, `--color-espresso: #3B2A20`, `--color-terracotta: #C97C4B`, `--color-sage: #7C8B6F`, `--font-display` (Fraunces) and `--font-sans` (Inter). It was committed with the scaffold — verify, and restore exactly from `PRD.md` §6 if anything is missing.
  2. Confirm fonts are imported in `src/main.jsx` (`@fontsource/inter/400.css`, `500`, `600`; `@fontsource/fraunces/500.css`, `600`).
- **Verify:** `grep -q "F5EDE2" src/index.css && grep -q "C97C4B" src/index.css && grep -q "@fontsource/fraunces/500.css" src/main.jsx && npm run build`
- **Done:** tokens and font imports present; build passes.

### T1.2 — Page shell with section stubs
- **Files:** `src/App.jsx`
- **Steps:**
  1. Replace the placeholder `App` with a plain shell: a top `<div id="top">` anchor, a temporary `<header>` containing only the text `Header (T2.1)`, a `<main>` containing seven `<section>` elements in sitemap order — `id="hero"`, `id="menu"`, `id="story"`, `id="gallery"`, `id="visit"`, `id="newsletter"`, `id="contact"` — each containing only its final `<h2>` heading from the PRD (hero gets no h2; the hero h1 is added in T2.2), and a temporary `<footer>` containing only the text `Footer (T2.10)`.
  2. No styling beyond token colors. No behavior.
- **Verify:** `npm run build && for id in hero menu story gallery visit newsletter contact; do grep -q "id=\"$id\"" src/App.jsx || exit 1; done`
- **Done:** all seven section ids exist in `src/App.jsx` in sitemap order.

### T1.3 — Create the 8 SVG placeholder images
- **Files:** `public/img/hero-bg.svg`, `public/img/story-space.svg`, `public/img/gallery-01.svg` … `public/img/gallery-06.svg` (8 files total)
- **Steps:**
  1. Create each as a hand-written SVG: `hero-bg.svg` is 1600×900, the other seven 1200×800.
  2. Style, all of them: warm gradient background drawn only from the palette (espresso → terracotta, or cream → sage, variants), one simple geometric line-art motif per image (coffee cup, latte swirl, croissant, storefront awning, steam lines, window with plants, pastry case), and a tiny `Bean 2 Brew` wordmark text in the bottom corner in the palette's espresso/cream.
  3. Keep each file under 4 KB. No external assets, no filters with heavy blur.
- **Verify:** `[ $(ls public/img/*.svg | wc -l) -eq 8 ] && [ $(find public/img -size +4k | wc -l) -eq 0 ] && npm run build`
- **Done:** 8 cohesive, palette-only SVGs exist.

### T1.4 — Image worker (conditional upgrade)
- **Files:** `public/img/*` (overwrite only)
- **Steps:**
  1. Run `tools/gen_image.sh --selftest`.
  2. **If exit ≠ 0:** do nothing further; append to `STATUS.md`: `Images: SVG placeholders (image worker not configured)`.
  3. **If exit 0:** for each of the 8 prompts in `tools/README.md` §Prompt list, run `tools/gen_image.sh "<prompt>" "" <target path>` where the target keeps the existing filename (`public/img/hero-bg.svg` stays the name pattern — write generated files as `.webp` next to the SVG, then update T1.3's file references in later tasks to the `.webp` when present). Keep the 8 filenames stable (e.g. `hero-bg.webp`, `story-space.webp`, `gallery-01.webp` …).
- **Verify:** `tools/gen_image.sh --selftest || true; npm run build` (build must pass on both paths)
- **Done:** either 8 generated images exist, or STATUS.md records the fallback. The loop continues either way.

---

