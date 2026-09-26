# Phase 2 — Sections (static, fully functional, no GSAP/Lenis/3D)

**Previous:** [phase-1-foundations.md](./phase-1-foundations.md) · **Next:** [phase-3-hero-3d.md](./phase-3-hero-3d.md)

**Rules for every task in this phase:**
- Section copy goes inline in the component's JSX, verbatim from CONTENT.
- Data comes from `src/data/*`. Images come via `getImage(id)`.
- Use Tailwind with the tokens. No framer-motion or GSAP yet (Phase 4).

### T2.1 — Header, mobile menu, skip link
- **Files:** `src/components/Header.jsx`, `src/App.jsx`
- **Read:** PRD §5, CONTENT §2, DESIGN §4 (container) + §7 (buttons)
- **Tools:** frontend-design
- **Steps:**
  1. Skip link "Skip to content" → `#main`, visually hidden until focused.
  2. Wordmark (display font) → `#top`.
  3. `<nav aria-label="Main">` with the 5 links, hidden below lg.
  4. CTA "Reserve a table" → `#reserve` (primary button).
  5. Below lg: a button with `aria-label="Open menu"`, `aria-expanded`, `aria-controls`.
     - It opens a full-screen overlay (`role="dialog"`, `aria-modal="true"`) with the 5 links and the CTA at the bottom. Targets are ≥ 44px.
     - The overlay's close button has `aria-label="Close menu"`.
     - Esc and any link close it.
     - Focus moves to the first link on open and returns to the toggle on close.
     - Body scroll is locked while it's open.
  6. Header is `position: sticky; top: 0` and transparent (the scroll states come in T4.5).
  7. Put `<div id="top" />` at the top of App.
- **Check:** `bash scripts/check.sh T2.1`
- **Done:** desktop nav, mobile overlay and skip link all work.

### T2.2 — Hero (static)
- **Files:** `src/components/Hero.jsx`, `src/App.jsx`
- **Read:** PRD §6 (layout only), CONTENT §2, DESIGN §3 (h1, Tamil glyph) + §4 hero wireframe
- **Tools:** frontend-design
- **Steps:**
  1. `<section id="hero" aria-label="Welcome">` at `min-h-[100svh]`.
  2. The h1 is **one text string** in JSX: `Filter kaapi, pulled a metre high.` (SplitText splits it at runtime in T4.2). It is the only `<h1>` in `src/`.
  3. Add the subhead and two CTAs: "Reserve a table" → `#reserve` (primary), "See the menu" → `#menu` (secondary).
  4. Tamil glyph `காபி`: `aria-hidden="true"`, positioned behind the text (DESIGN §3).
  5. Stage box: `<div id="hero-stage" aria-hidden="true">`.
     - It occupies the right 6 of 12 columns on lg, and 55svh below the text on mobile.
     - It is empty for now.
  6. "Scroll to pour" hint at the bottom (small, `aria-hidden`, static).
  7. Background: a decoction → roast radial gradient.
- **Check:** `bash scripts/check.sh T2.2`
- **Done:** final hero copy and layout, stage box reserved.

### T2.3 — Menu board with tabs
- **Files:** `src/components/MenuSection.jsx`, `src/App.jsx`
- **Read:** PRD §7, CONTENT §3, DESIGN §4 (menu board) + §7 (tags)
- **Tools:** frontend-design
- **Steps:**
  1. h2 "The board" and the subhead.
  2. `role="tablist"` with 5 `role="tab"` buttons (`aria-selected`, `aria-controls`, roving `tabIndex`, Left/Right/Home/End keys).
     - Active tab: jasmine text plus a brass pill behind it (static for now).
  3. `role="tabpanel"`: a kraft board.
     - Items filtered by the active tab; "All" shows 13.
     - Each item has an h3 name, a dotted leader, the price `₹{price}` in display font, and the description below.
     - Tags use DESIGN §7 tag styles.
  4. Footnote under the board.
  5. Import `menuItems` and `MENU_TABS`; no hard-coded items.
- **Check:** `bash scripts/check.sh T2.3`
- **Done:** filtering works in all 5 states; keyboard tabs work.

### T2.4 — Process (vertical)
- **Files:** `src/components/ProcessSection.jsx`, `src/App.jsx`
- **Read:** PRD §8, CONTENT §4, DESIGN §4 (process)
- **Tools:** frontend-design
- **Steps:**
  1. h2 "From estate to dabara" and the subhead.
  2. Render the 4 `processSteps` as `<ol>` items:
     - image (4:5 wrapper, `getImage`)
     - large display-font number
     - h3 title and body
  3. Wrap the list in `<div data-process-track>` (the horizontal scroll hooks in here in T4.4). Vertical layout for now.
- **Check:** `bash scripts/check.sh T2.4`
- **Done:** 4 steps render in order.

### T2.5 — Story
- **Files:** `src/components/StorySection.jsx`, `src/App.jsx`
- **Read:** CONTENT §5, DESIGN §4 (story + arched radius)
- **Tools:** frontend-design
- **Steps:**
  1. h2 and the three paragraphs, verbatim.
  2. Arched-top `story-counter` image.
  3. Fact line as three separate items (no dot separators).
- **Check:** `bash scripts/check.sh T2.5`
- **Done:** story renders with the arched image.

### T2.6 — Gallery grid
- **Files:** `src/components/GallerySection.jsx`, `src/App.jsx`
- **Read:** PRD §10, CONTENT §6, DESIGN §4 (gallery)
- **Tools:** frontend-design
- **Steps:**
  1. h2 "A look inside" and the subhead.
  2. The 8 `gallery-*` images from `IMAGES` in id order, each inside a `<button type="button" aria-label="Open image N of 8">` (the click handler arrives in T4.8).
  3. Use aspect-ratio wrappers (4:5 tiles span 2 rows, 3:2 and 1:1 span 1). Grid: 1 column on mobile, 2 at md, 3 at lg.
- **Check:** `bash scripts/check.sh T2.6`
- **Done:** 8 images with alt text in a responsive grid.

### T2.7 — Reviews
- **Files:** `src/components/ReviewsSection.jsx`, `src/App.jsx`
- **Read:** CONTENT §7, DESIGN §4 (reviews)
- **Tools:** frontend-design
- **Steps:**
  1. h2 "What regulars say".
  2. Map `reviews` into `<figure><blockquote>` quote, with `<figcaption>` "Name, Area".
  3. No cards, avatars or star ratings.
- **Check:** `bash scripts/check.sh T2.7`
- **Done:** 3 quotes render.

### T2.8 — `src/lib/reservation.js` (pure logic)
- **Files:** `src/lib/reservation.js`
- **Read:** PRD §12, CONTENT §8 + §12
- **Tools:** none
- **Steps:** export exactly these. No React, no DOM.
  1. `SLOT_START = "07:00"`, `SLOT_END = "21:30"`, `MAX_PARTY = 8`, `DAYS_AHEAD = 30`.
  2. `toISODate(date)`: returns `YYYY-MM-DD` in local time.
  3. `dateBounds(now = new Date())`: returns `{ min, max }`, where `min` is today and `max` is today + 30 days, both local ISO dates.
  4. `getSlots(dateISO, now = new Date())`: returns 30 `"HH:MM"` strings from 07:00 to 21:30 in 30-minute steps. If `dateISO` is today (local), drop slots earlier than now + 30 minutes.
  5. `formatTime("19:30")` returns `"7:30 pm"`; `formatTime("07:00")` returns `"7:00 am"`.
  6. `formatDate(dateISO)`: `Intl.DateTimeFormat('en-IN', { weekday: 'short', day: 'numeric', month: 'short' })` of the local date.
  7. `isValidMobile(s)`:
     - Strip spaces and dashes.
     - Remove a leading `+91`, `91` (only if 12 digits) or `0` (only if 11 digits).
     - Test `/^[6-9]\d{9}$/`.
  8. `isValidEmail(s)`: a simple `local@domain.tld` regex.
  9. `validateWhen({ date, time, party }, now)`: returns an error object using CONTENT §12 messages for `date` (missing or out of bounds), `time` (missing) and `party` (not an integer 1–8).
  10. `validateDetails({ name, mobile, email })`: returns errors for `name` (< 2 chars after trim), `mobile` (invalid) and `email` (only if non-empty and invalid).
  11. `makeRef(rand = Math.random)`: returns `"B2B-"` plus 4 characters from `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`.
  12. `buildIcs({ date, time, party, name, ref })`: returns an RFC 5545 string with CRLF line endings.
      - Structure: `BEGIN:VCALENDAR`, `VERSION:2.0`, `PRODID:-//Bean 2 Brew//Demo//EN`, one `VEVENT`, `END:VCALENDAR`.
      - The VEVENT contains:
        - `UID:{ref}@bean2brew.demo`
        - `DTSTAMP` (now, UTC)
        - `DTSTART`/`DTEND` in UTC: the local time is IST, so subtract 5h30. Duration 90 minutes. Format `YYYYMMDDTHHMMSSZ`.
        - `SUMMARY`, `LOCATION`, `DESCRIPTION` per CONTENT §8, with commas escaped as `\,`.
- **Check:** `bash scripts/check.sh T2.8` (runs unit assertions in Node)
- **Done:** all assertions pass.

### T2.9 — Reserve flow UI
- **Files:** `src/components/reserve/ReserveSection.jsx`, `src/App.jsx`
- **Read:** PRD §12, CONTENT §8 + §12, DESIGN §4 (reserve wireframe) + §7 (inputs)
- **Tools:** frontend-design
- **Steps:**
  1. `<section id="reserve">`: h2 and subhead, then a two-column layout on lg (token + form panel), with the mobile summary bar.
  2. State: `step` (1–3 or `"done"`), `when { date, time, party: 2, seating: "Indoor" }`, `who { name, mobile, email, occasion, notes }`, `errors`, `ref`.
  3. **Step 1:**
     - Date is `<input type="date">` with min/max from `dateBounds()`.
     - Slot grid from `getSlots(date)` as `aria-pressed` buttons. Show the "No tables left today" message when the list is empty.
     - People stepper with the two aria-labels and the "bigger groups" note at 8.
     - Seating as a radio group.
  4. **Step 2:** the fields with `<label>`s, helper text, and a notes counter.
  5. **Step 3:** summary with "Edit" buttons that jump to a step.
  6. Continue validates the current step (`validateWhen` / `validateDetails`):
     - Show errors under the fields, with `aria-invalid` and `aria-describedby`.
     - Focus the first invalid field.
     - On a step change, focus the step h3 (`tabIndex={-1}`).
  7. "Confirm reservation" does the following:
     - sets `ref = makeRef()` and `step = "done"`
     - shows the confirmation inside an `aria-live="polite"` region
     - shows the demo notice
     - "Add to calendar" builds `buildIcs(...)` into a `Blob` (`text/calendar`) and triggers a download named `bean2brew-{ref}.ics` via an object URL (revoke it after)
     - "Make another reservation" resets everything
  8. Token mirrors the live values; empty values show `—`. After confirm it shows the reference and the "Confirmed" stamp (kumkum on kraft).
  9. `<form noValidate onSubmit={e => e.preventDefault()}>`. No network calls.
- **Check:** `bash scripts/check.sh T2.9`
- **Done:** a booking can be completed with keyboard only and the .ics downloads.

### T2.10 — Visit and contact form
- **Files:** `src/components/VisitSection.jsx`, `src/components/ContactForm.jsx`, `src/App.jsx`
- **Read:** PRD §13, CONTENT §1 + §9 + §12, DESIGN §4 (visit)
- **Tools:** frontend-design
- **Steps:**
  1. `<section id="visit">`: h2 and subhead, then an `<address>` block (addressLines), hours plus last seating, phone (`SITE.phoneHref`), email (`mailto:`).
  2. "Get directions" → `SITE.directionsUrl`, `target="_blank" rel="noopener"`.
  3. `<iframe src={SITE.mapEmbedUrl} title="Map showing Bean 2 Brew in Besant Nagar, Chennai" loading="lazy">` inside a 4:3 wrapper.
  4. `ContactForm`:
     - h3 "Write to us" and the intro.
     - Name, Email and Message, all required, errors per CONTENT §12.
     - "Send message".
     - On success: inline message in `aria-live`, then reset the fields.
     - `preventDefault`, no network.
- **Check:** `bash scripts/check.sh T2.10`
- **Done:** map, details, directions and a validated form all work.

### T2.11 — Footer and newsletter
- **Files:** `src/components/Footer.jsx`, `src/components/Newsletter.jsx`, `src/App.jsx`
- **Read:** PRD §14 + §17, CONTENT §10
- **Tools:** frontend-design
- **Steps:**
  1. `Newsletter`: `<section id="newsletter">` with h2 "Roast notes", subhead, labelled email field, "Subscribe", inline success in `aria-live`, `preventDefault`, no network.
  2. `Footer`: renders Newsletter (roast band) and the 4 groups per CONTENT §10.
  3. Bottom bar: `© 2026 Bean 2 Brew.` and `Bean 2 Brew is a fictional café. Site designed and built by {STUDIO} as a demo.` (import `STUDIO`).
- **Check:** `bash scripts/check.sh T2.11`
- **Done:** footer and newsletter complete; disclaimer visible.

### T2.12 — Mobile reserve bar
- **Files:** `src/components/MobileReserveBar.jsx`, `src/App.jsx`
- **Read:** PRD §5
- **Tools:** frontend-design
- **Steps:**
  1. A fixed bottom bar, `md:hidden`, containing the "Reserve a table" link → `#reserve`. Respect `env(safe-area-inset-bottom)`.
  2. Hide it (`hidden` plus `aria-hidden`) while `#hero` or `#reserve` intersects the viewport, using IntersectionObserver.
  3. Add bottom padding to `<footer>` on mobile so the bar never covers content.
- **Check:** `bash scripts/check.sh T2.12`
- **Done:** the bar appears only mid-page on mobile.

### T2.13 — Compose page
- **Files:** `src/App.jsx`
- **Read:** PRD §4
- **Tools:** none
- **Steps:**
  1. Final order: `<Header/>`, then `<main id="main">` containing `<Hero/> <MenuSection/> <ProcessSection/> <StorySection/> <GallerySection/> <ReviewsSection/> <ReserveSection/> <VisitSection/>`, then `<Footer/>` and `<MobileReserveBar/>`.
  2. Remove shell leftovers from T1.8.
  3. Every section has `scroll-mt-20` (or equivalent).
- **Check:** `bash scripts/check.sh T2.13`
- **Done:** the page is complete and static.

### T2.14 — Phase 2 checkpoint (browser QA and review)
- **Files:** any component with a defect, `qa/REPORT.md`, `STATUS.md`
- **Read:** CLAUDE.md → Browser QA
- **Tools:** Playwright MCP, `/code-review`
- **Steps:**
  1. Serve the build. At 375, 768, 1024 and 1440:
     - check there is no horizontal overflow
     - review every section's layout against the DESIGN §4 wireframes
  2. Test functionality:
     - menu tabs (click and keyboard)
     - mobile menu (open, Esc, link)
     - a full reservation on 375px, including validation errors
     - contact and newsletter success
  3. Screenshot the map and confirm the marker sits in Besant Nagar near Elliot's Beach. If not, log it as an Open issue for the human (do not change CONTENT).
  4. Run `/code-review` on the diff since T1.8 and fix real issues.
  5. Write `## T2.14` in `qa/REPORT.md` and set the Phase 2 section rows in STATUS.
- **Check:** `bash scripts/check.sh T2.14`
- **Done:** a complete, working static site. This is the safe fallback checkpoint.
