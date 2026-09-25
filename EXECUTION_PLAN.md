# Execution Plan — Bean 2 Brew Demo Site

**Purpose:** Build the full demo defined in `PRD.md` using the pinned stack in `TECH_STACK.md`, as a single uninterrupted loop (see `CLAUDE.md` for the loop algorithm and hard rules).

**Grain size rule:** each task is one small change — roughly one file. Never do two tasks at once. Every task has an exact **Verify** command (exit 0 = pass) and a **Done** criterion.

The scaffold (Vite 8 + React 19 + Tailwind 4 + all deps pinned + lockfile) is **already committed**. Phase 0 is verification, not setup.

---

## Phase 0 — Environment check

### T0.1 — Install dependencies and verify build
- **Files:** none (repo root)
- **Steps:**
  1. Run `npm install` (uses the committed `package-lock.json`; versions are pinned — do not change them).
  2. Run `npm run build`.
- **Verify:** `npm run build` exits 0 and prints `built in`.
- **Done:** `dist/` exists with `index.html` and `assets/`.
- **If it fails:** check `node -v` (needs 20.19+ or 22+; 22 LTS recommended). One retry. Still failing → BLOCKED with the exact error text.

### T0.2 — Verify dist output is complete
- **Files:** none
- **Steps:** inspect the build output only.
- **Verify:** `test -f dist/index.html && test -d dist/assets && test -f dist/assets/index-*.js` — write it as: `test -f dist/index.html && ls dist/assets/*.js`
- **Done:** both the HTML entry and at least one JS bundle exist in `dist/`.

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

## Phase 2 — Static skeleton (one component per task, zero animation)

### T2.1 — Header & mobile menu
- **Files:** `src/components/Header.jsx` (new), `src/App.jsx` (replace the temporary header)
- **Steps:**
  1. Build the header: `Bean 2 Brew` wordmark (font-display, links to `#top`, left), desktop nav (hidden below `lg`) with `Menu` → `#menu`, `Our Story` → `#story`, `Gallery` → `#gallery`, `Visit Us` → `#visit`, `Contact` → `#contact`, and CTA button `Visit Us Today` → `#visit`.
  2. Mobile (`< lg`): a hamburger button (`aria-label="Open menu"`, 44px+ target) that opens a full-screen overlay menu with the same five links (44px+ touch targets) and the CTA repeated at the bottom; tapping any link closes the overlay.
  3. Sticky top, transparent background over the hero, plain cream background acceptable until T4.1 adds the scroll transition.
- **Verify:** `npm run build && grep -q 'aria-label="Open menu"' src/components/Header.jsx`
- **Done:** desktop nav + working mobile overlay; scroll transition NOT yet implemented.

### T2.2 — Hero (static)
- **Files:** `src/components/Hero.jsx` (new), `src/App.jsx` (replace hero stub)
- **Steps:**
  1. Hero content, exactly: `<h1>Slow Mornings, Made Right.</h1>` (the page's only h1), subhead `Small-batch coffee, baked fresh daily, poured with care in the heart of Riverside Corner.`, primary CTA `See Our Menu` → `#menu`, secondary CTA `Get Directions` → `#visit`.
  2. Background: `public/img/hero-bg.*` (SVG, or `.webp` if T1.4 produced one) with a soft espresso gradient overlay so text stays readable.
  3. Scroll cue: a small bouncing down-arrow (CSS keyframes only) at the bottom.
  4. Add an empty mount point `<div id="hero-stage" aria-hidden="true" className="absolute inset-0"></div>` for Phase 3.
  5. Height: `min-h-screen`, content centered.
- **Verify:** `npm run build && grep -c "<h1" src/components/Hero.jsx`
- **Done:** hero renders with final copy; exactly one `<h1>` in the whole `src/` tree (grep to confirm).

### T2.3 — Menu data
- **Files:** `src/data/menu.js` (new)
- **Steps:**
  1. Export `CATEGORIES = ["Coffee", "Tea", "Pastries", "Seasonal"]`.
  2. Export `menuItems` — the **exact 10 items** from `PRD.md` §11 with fields `{ name, category, price, description }` (names, prices, and one-line descriptions copied verbatim).
- **Verify:** `grep -q "Cold Brew Float" src/data/menu.js && grep -q "Pumpkin Spice Cortado" src/data/menu.js && grep -q "Honey Lavender Latte" src/data/menu.js && npm run build`
- **Done:** 10 items, 4 categories, verbatim PRD data.

### T2.4 — MenuSection with client-side filtering
- **Files:** `src/components/MenuSection.jsx` (new), `src/App.jsx` (replace menu stub)
- **Steps:**
  1. Section heading `What We're Pouring` (h2) + subhead `A few favorites — the full menu's even bigger in person.`
  2. Filter row: buttons `All`, `Coffee`, `Tea`, `Pastries`, `Seasonal`; default `All`. Clicking sets React state; the grid re-filters with no page reload. Active button is visually distinct (terracotta).
  3. Item card: name, price, one-line description, and a small 40px circular badge showing the item's first letter in its category color.
  4. Footnote under the grid: `Menu is seasonal and subject to change — see us in person for the full lineup.`
  5. Data comes from `src/data/menu.js` — do not hardcode items here.
- **Verify:** `npm run build && grep -q "What We're Pouring" src/components/MenuSection.jsx && grep -q "menuItems" src/components/MenuSection.jsx`
- **Done:** all 5 filter states work; default shows all 10 items.

### T2.5 — StorySection
- **Files:** `src/components/StorySection.jsx` (new), `src/App.jsx` (replace story stub)
- **Steps:**
  1. h2 `Why We Started Pouring`.
  2. The two body paragraphs from `PRD.md` §12, verbatim.
  3. Supporting image: `public/img/story-space.*` with `alt="The Bean 2 Brew space in Riverside Corner"`.
  4. Stat row: `Est. 2019` · `Locally Roasted` · `Family Owned`.
- **Verify:** `npm run build && grep -q "Why We Started Pouring" src/components/StorySection.jsx && grep -q "neighborhood spot first" src/components/StorySection.jsx`
- **Done:** final copy + image + stat row render.

### T2.6 — GallerySection (grid only, no lightbox yet)
- **Files:** `src/components/GallerySection.jsx` (new), `src/App.jsx` (replace gallery stub)
- **Steps:**
  1. h2 `A Look Inside`.
  2. Grid of the 6 gallery images (`gallery-01` … `gallery-06`, `.webp` if T1.4 produced them else `.svg`), responsive: 1 col mobile / 2 cols `md` / 3 cols `lg`.
  3. Every image gets a specific `alt` describing what the placeholder depicts (interior, latte, pastry, pouring, exterior, window seat).
  4. No lightbox in this task (that is T4.4).
- **Verify:** `npm run build && grep -c "gallery-0" src/components/GallerySection.jsx`
- **Done:** 6 images with alt text in a responsive grid.

### T2.7 — VisitUs (map, hours, directions)
- **Files:** `src/components/VisitUs.jsx` (new), `src/App.jsx` (replace visit stub)
- **Steps:**
  1. h2 `Come Say Hi`.
  2. Address: `142 Maple Street, Riverside Corner, Springfield, IL 62704`.
  3. Phone displayed as `(555) 201-2837`, wrapped in `<a href="tel:+15552012837">`.
  4. Hours: `Mon–Fri 7:00am–7:00pm · Sat–Sun 8:00am–8:00pm`.
  5. Map: `<iframe>` with **exactly** this src (OpenStreetMap, no key): `https://www.openstreetmap.org/export/embed.html?bbox=-89.6551%2C39.7767%2C-89.6451%2C39.7867&layer=mapnik&marker=39.7817%2C-89.6501` with `title="Map to Bean 2 Brew"`, height ~360, rounded corners.
  6. CTA `Get Directions` → `https://www.google.com/maps/search/?api=1&query=142%20Maple%20Street%2C%20Riverside%20Corner%2C%20Springfield%2C%20IL%2062704` (`target="_blank" rel="noopener"`).
- **Verify:** `npm run build && grep -q "openstreetmap.org/export/embed.html" src/components/VisitUs.jsx && grep -q "tel:+15552012837" src/components/VisitUs.jsx`
- **Done:** full contact block + no-key map + directions CTA render.

### T2.8 — Newsletter section
- **Files:** `src/components/Newsletter.jsx` (new), `src/App.jsx` (replace newsletter stub)
- **Steps:**
  1. h2 `Stay in the Loop`, subhead `First look at seasonal drinks, pop-up events, and the occasional free-pastry day.`
  2. Form: email input (`type="email"`, `required`, visible label) + button `Subscribe`.
  3. On submit: `e.preventDefault()`, validate, then set local state to show the inline success line `You're on the list — see you at the counter.` No page reload, **no network call** (R9).
- **Verify:** `npm run build && grep -q "Stay in the Loop" src/components/Newsletter.jsx && grep -q "preventDefault" src/components/Newsletter.jsx`
- **Done:** validation + inline success work locally.

### T2.9 — Contact mini-section
- **Files:** `src/components/ContactSection.jsx` (new), `src/App.jsx` (replace contact stub)
- **Steps:**
  1. h2 `Say Hello` + one-line intro: `Questions, private events, or just to say hi — write to us.`
  2. Form: Name (required), Email (required, format-validated), Message (required textarea), Submit button `Send Message`.
  3. Inline errors under each field on submit attempt; on valid submit show inline success `Thanks — we'll be in touch. (Demo form: nothing is actually sent.)` No page reload, **no network call** (R9).
- **Verify:** `npm run build && grep -q "Say Hello" src/components/ContactSection.jsx && grep -q "preventDefault" src/components/ContactSection.jsx`
- **Done:** all three fields validate; success state is local only.

### T2.10 — Footer
- **Files:** `src/components/Footer.jsx` (new), `src/App.jsx` (replace the temporary footer)
- **Steps:**
  1. Four columns per `PRD.md` §16: **Brand** (wordmark + tagline `Slow mornings, made right.` + address) · **Quick Links** (Menu, Our Story, Gallery, Visit Us, Contact anchors) · **Contact** (phone `tel:`, email `mailto:hello@bean2brew.com`, hours summary) · **Social** (Instagram `https://instagram.com/bean2brew`, Facebook `https://facebook.com/bean2brew`, TikTok `https://tiktok.com/@bean2brew` — all `target="_blank" rel="noopener"` with `aria-label`s).
  2. Bottom bar: `© 2026 Bean 2 Brew. All rights reserved.` + `Site design by Brewworks Studio` (store the studio name in one constant `STUDIO` at the top of the file).
  3. Background espresso, text cream (contrast rule R-pinned).
- **Verify:** `npm run build && grep -q "Brewworks Studio" src/components/Footer.jsx && grep -q "mailto:hello@bean2brew.com" src/components/Footer.jsx`
- **Done:** all four columns + bottom bar render.

### T2.11 — Compose the full page
- **Files:** `src/App.jsx`
- **Steps:**
  1. Mount, in order: `Header`, then `<main>` with `Hero`, `MenuSection`, `StorySection`, `GallerySection`, `VisitUs`, `Newsletter`, `ContactSection`, then `Footer`.
  2. Give every section `className="scroll-mt-20"` (or equivalent) so the sticky header doesn't cover section tops after anchor jumps.
- **Verify:** `npm run build && for id in hero menu story gallery visit newsletter contact; do grep -q "id=\"$id\"" src/App.jsx || exit 1; done`
- **Done:** every nav anchor resolves to a real section.

### T2.12 — Responsive audit (code level)
- **Files:** any component with a gap found
- **Steps:**
  1. For each of the 9 components (Header, Hero, MenuSection, StorySection, GallerySection, VisitUs, Newsletter, ContactSection, Footer): confirm it has intentional mobile → `md` (≥768) → `lg` (≥1024) handling — no fixed pixel widths, no overflow on a 375px viewport (check for long unbreakable strings, wide images without `max-w-full`).
  2. Fix what you find. Append a one-line checklist to `STATUS.md` (e.g. `Responsive audit: 9/9 components pass, fixed GallerySection image width`).
- **Verify:** `npm run build`
- **Done:** STATUS.md has the audit line.

### T2.13 — Phase 2 checkpoint
- **Files:** `STATUS.md`
- **Steps:** run the build once more; set the Section-by-section rows for Header/Hero/Menu/Story/Gallery/Visit Us/Newsletter/Contact/Footer to `Done` in `STATUS.md` (or `Needs review` where you are unsure); commit (the loop auto-commits after the task).
- **Verify:** `npm run build`
- **Done:** Phase 2 is the safe fallback checkpoint — a complete static site, per `PRD.md`.

---

## Phase 3 — Hero 3D (highest-risk item; de-risked by T3.5)

### T3.1 — HeroStage component (isolated)
- **Files:** `src/components/hero/HeroStage.jsx` (new)
- **Steps:**
  1. Export `HeroStage`: an R3F `<Canvas dpr={[1, 1.75]}>` (fixed camera, no OrbitControls) rendering a **procedural steam field**: one `<points>` object with 600 particles (400 when `window.innerWidth < 768`).
  2. Particle texture: a soft circular sprite **generated in code** (canvas → `THREE.CanvasTexture`), additive blending, warm-white/terracotta colors at low opacity. No external files, no glTF, no lights (basic/points material).
  3. Motion in `useFrame`: slow upward drift + gentle sinusoidal sway; particles wrap back to the bottom when they exit the top.
  4. Also export `HeroStaticFallback` from the same file: a div with a radial espresso→terracotta gradient and two slow CSS steam blobs (keyframes defined here).
- **Verify:** `npm run build && grep -q "CanvasTexture" src/components/hero/HeroStage.jsx && grep -q "HeroStaticFallback" src/components/hero/HeroStage.jsx`
- **Done:** self-contained component compiles; zero external 3D assets.

### T3.2 — Mount hero 3D with reduced-motion gate
- **Files:** `src/components/Hero.jsx`
- **Steps:**
  1. Import `HeroStage` and `HeroStaticFallback`.
  2. Track `window.matchMedia('(prefers-reduced-motion: reduce)')` (listen for changes; guard for non-browser environments).
  3. Reduced motion → render `HeroStaticFallback` inside `#hero-stage`. Otherwise render `<HeroStage />`.
- **Verify:** `npm run build && grep -q "prefers-reduced-motion" src/components/Hero.jsx`
- **Done:** both modes render; layout identical in both.

### T3.3 — WebGL / low-power guard
- **Files:** `src/components/hero/HeroStage.jsx`
- **Steps:**
  1. Before mounting the Canvas, check WebGL support: `const c = document.createElement('canvas'); c.getContext('webgl2') || c.getContext('webgl')`. If `null` → render `HeroStaticFallback` instead.
  2. Keep the dpr cap from T3.1 (1.75).
- **Verify:** `npm run build && grep -q "getContext" src/components/hero/HeroStage.jsx`
- **Done:** no-WebGL browsers get the static fallback, no crash.

### T3.4 — Performance check & fallback decision
- **Files:** `src/components/hero/HeroStage.jsx`
- **Steps:**
  1. Start the dev server (per R10 pattern), open the page, watch the hero: if it is under ~30 fps or glitches, halve the particle count and re-check.
  2. **Decision point (max 2 attempts total):** if the effect still doesn't look right (banding, flicker, ugly, slow), replace the hero visual with `HeroStaticFallback` only, and record in `STATUS.md`: `Hero 3D deferred (static fallback in use)` with the one-line reason. The hero remains complete and on-brand.
- **Verify:** `npm run build`
- **Done:** STATUS.md records either `Hero 3D: <N> particles, stable` or the deferral note.

### T3.5 — Phase 3 checkpoint
- **Files:** `STATUS.md`
- **Steps:** set the Hero row appropriately (`Done` or `Needs review — static fallback`); commit.
- **Verify:** `npm run build`
- **Done:** hero is stable in whatever mode it ended in.

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

## Phase 6 — Polish & pitch readiness

### T6.1 — Copy audit
- **Files:** any file with placeholder copy
- **Steps:**
  1. Run: `grep -rni "lorem\|tbd\|placeholder\|fixme\|xxx\|scaffold ok" src/ index.html`
  2. Fix **every** hit. Allowed exceptions: the `ANALYTICS SLOT` comment in `index.html` and the demo-form disclaimer string in `ContactSection.jsx`.
  3. Confirm all visible copy matches `PRD.md` exactly.
- **Verify:** `! grep -rni "lorem\|tbd\|fixme\|scaffold ok" src/ index.html && npm run build`
- **Done:** zero visible placeholder copy.

### T6.2 — Forms final verification
- **Files:** `src/components/Newsletter.jsx`, `src/components/ContactSection.jsx` (only if a fix is needed)
- **Steps:**
  1. Confirm: required fields enforced, email format validated, inline errors, inline success, no page reload.
  2. Confirm zero network calls anywhere: `grep -rn "fetch(\|XMLHttpRequest\|axios\|http://\|https://" src/components/Newsletter.jsx src/components/ContactSection.jsx` must show nothing except the `mailto:`/`tel:` in Footer (different file).
- **Verify:** `npm run build && ! grep -rn "fetch(" src/`
- **Done:** both forms are demo-safe per `PRD.md` §17.

### T6.3 — Full final verification
- **Files:** none
- **Steps + Verify (run all, all must pass):**
  ```bash
  npm run build \
  && test -f dist/index.html \
  && for id in hero menu story gallery visit newsletter contact; do grep -q "id=\"$id\"" src/App.jsx || exit 1; done \
  && grep -q "Springfield" src/components/VisitUs.jsx \
  && test $(for f in dist/assets/*.js; do gzip -c "$f"; done | wc -c) -lt 400000
  ```
- **Done:** every PRD section present, budget met, demo data intact. Record the result in `STATUS.md`.

### T6.4 — Deploy (conditional, never blocks)
- **Files:** none
- **Steps:**
  1. Check the CLI: `command -v vercel || npx --no-install vercel --version` — and auth: `vercel whoami`.
  2. **If both pass:** run `npx vercel --yes --prod` from the repo root (Vite is auto-detected; build command `npm run build`; output `dist`). Capture the URL.
  3. **If not:** do NOT try to authenticate interactively. Append to `STATUS.md`: `Deploy: pending — Vercel CLI not authenticated (run: vercel login, then npx vercel --yes --prod)`.
- **Verify:** either a deployment URL was printed, or the STATUS note exists.
- **Done:** site is deployed, or the exact human follow-up is recorded.

### T6.5 — Final commit & report
- **Files:** `STATUS.md`
- **Steps:**
  1. Write `## Final report` in `STATUS.md`: Done list, BLOCKED list, bundle size, deployment URL or pending note, any caveats.
  2. `git add -A && git commit -m "Final: pitch-ready build"`.
  3. Print a summary of **at most 10 lines**. Stop (stop condition met).

---

## Working agreement (carried from the original plan)

- `STATUS.md` is updated at the end of every task — it is the only durable memory between loops.
- When a task takes materially longer than expected, stop, re-scope down (simpler = acceptable), record the reason in `STATUS.md`.
- Do not remove a required PRD section to save time. Scope changes are out of loop authority.
- Prefer small, reversible commits over large multi-file changes.
