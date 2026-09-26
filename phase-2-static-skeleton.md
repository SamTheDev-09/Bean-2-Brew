# Execution Plan — Phase 2

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-2 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-1-design-assets.md](./phase-1-design-assets.md)  
**Next:** [phase-3-hero-3d.md](./phase-3-hero-3d.md)

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

