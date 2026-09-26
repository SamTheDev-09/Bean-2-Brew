# PRD — Bean 2 Brew, Chennai (premium demo site)

**Positioning:** sales demo for a **$5,000-tier** café/restaurant website package.
**Business:** Bean 2 Brew, a fictional specialty café on 3rd Avenue, Besant Nagar, Chennai.
**Status:** every item marked `DECIDED` is locked. The build agent never re-opens a DECIDED item. Changing one requires a human edit to this file.

Companion docs:
- `CONTENT.md` holds every word and number on the site. It is used verbatim.
- `DESIGN.md` covers look, motion and 3D art direction.
- `TECH_STACK.md` covers packages and budgets.
- `ASSETS.md` covers imagery.

---

## 1. Purpose

This is a complete, production-grade single-page site for a fictional café. It is used to show local café and restaurant owners what $5,000 buys. It is built as if a real client paid for it:
- no lorem ipsum
- no stubs
- no dead links
- no fake functionality presented as real

## 2. What "$5,000" commits to

| Commitment | Where |
|---|---|
| A signature 3D moment tied to the business: the Madras "metre pour" of filter kaapi between a brass tumbler and dabara, driven by scroll | §6 |
| Two scroll-driven set pieces (hero pour, estate-to-dabara process) plus smooth scrolling | §6, §8 |
| A working reservation flow: date, time slots, party size, details, review, confirmation, calendar file | §12 |
| A menu that feels like the café's board, with animated filtering | §7 |
| Mobile designed on purpose: full-screen menu, sticky "Reserve a table" bar, simplified set pieces | §5, §16 |
| Local SEO: CafeOrCoffeeShop structured data, OG/Twitter cards, bilingual touch (Tamil) | §16 |
| Accessible and fast: reduced-motion path, keyboard-complete, JS budget met | §16 |
| Honest demo: fictional business, forms that send nothing, labelled clearly | §15, §17 |

## 3. Audience, goals, non-goals

**Audience:**
- **Primary:** café and restaurant owners in Chennai and other Indian metros.
- **Secondary:** anyone the link is forwarded to.

**Goals:**
- Create a wow moment in the first 3 seconds.
- An owner can name at least three concrete features they don't have today.
- The site runs smoothly on a mid-range Android phone.

**Non-goals (DECIDED):**
- No real bookings, payments, CMS, backend, accounts or multi-page routing.
- No real customer data leaves the browser.

## 4. Sitemap (DECIDED)

Single page. Sections in this exact order, with these exact ids:

```
Header (sticky)                       skip link → #main
<main id="main">
  #hero      Hero: the metre pour (3D)
  #menu      The board (menu)
  #process   From estate to dabara (4 steps)
  #story     Why we pour it long
  #gallery   A look inside (lightbox)
  #reviews   What regulars say
  #reserve   Reserve a table (3-step flow)
  #visit     Find us (map, hours, contact form)
</main>
Footer, containing #newsletter (Roast notes)
MobileReserveBar (mobile only)
Preloader (first visit per session)
```

**Navigation:**
- Nav items: Menu (#menu), The pour (#process), Story (#story), Gallery (#gallery), Visit (#visit).
- Primary CTA: "Reserve a table" (#reserve).

## 5. Global behaviour

- **Header:**
  - Transparent over the hero.
  - Solid decoction background once scrolled past 24px.
  - Hides on scroll down and shows on scroll up (after the hero).
  - The active section's nav link gets `aria-current="true"`.
- **Mobile menu (< lg):**
  - Full-screen overlay with the same links and the CTA.
  - Touch targets ≥ 44px.
  - Esc and any link close it.
  - Focus moves into the overlay and returns to the button on close.
- **MobileReserveBar (< md):**
  - Fixed bottom bar with "Reserve a table".
  - Hidden while #hero or #reserve is in view.
- **Smooth scroll:**
  - Lenis on desktop and mobile. Anchor links scroll smoothly with a header offset.
  - Disabled under reduced motion.
- **Preloader:**
  - Shown once per browser session, ≤ 1.8s, never blocks content longer.
  - Skipped under reduced motion.
- **Skip link:** "Skip to content" → #main, visible on focus.

## 6. Hero — the metre pour (DECIDED)

**Copy:** CONTENT §2. The h1 is the page's only `<h1>`.

**Signature interaction:** a procedural React Three Fiber scene.
- A brass tumbler (upper) pours filter kaapi in a long stream into a brass dabara (lower). Froth builds in the dabara and steam rises.
- Scroll drives `progress` 0 → 1 while the hero is pinned:
  - the tumbler rises
  - the stream lengthens
  - the froth peaks
- The pointer adds a subtle parallax tilt on desktop.
- Everything is procedural: lathe geometry, a code-generated sprite texture, a local Lightformer environment.
- **No** external models, HDRs or textures. Art direction is in DESIGN §6.

**Quality tiers (de-risk rule, DECIDED):**

| Tier | What renders | When |
|---|---|---|
| A | Full pour: tumbler, stream, froth, steam, scroll + pointer | Default |
| B | Tumbler + dabara composition with steam; no stream or froth; scroll still rotates the pair | Tier A still broken or < 30fps after 2 attempts (T3.5) |
| C | `HeroFallback`: SVG line art of tumbler + dabara, CSS steam (static under reduced motion) | Reduced motion, no WebGL, while the 3D chunk loads, or Tier B also fails |

The layout is identical in every tier. The tier shipped is recorded in `STATUS.md`.

## 7. Menu — "The board"

- **Data:** 13 items across 4 categories (CONTENT §3). Tabs: All (default), Kaapi, Espresso bar, Chai and coolers, Bakes.
- **Filtering:**
  - Client-side, no reload.
  - Tabs are a proper `tablist` with arrow-key navigation.
  - Items animate in and out with a layout transition.
  - The active tab has a sliding brass indicator.
- **Presentation:**
  - A café menu board, not cards: name, dotted leader, price in ₹, description below. Tags where given.
  - Footnote from CONTENT §3.

## 8. Process — "From estate to dabara"

- Four steps (CONTENT §4), each with an image, step number, title and text. Numbers are allowed because this is a true sequence.
- **≥ 1024px:** the section pins and the four panels move horizontally with scroll (scrub).
- **< 1024px or reduced motion:** a vertical stack with no pin.

## 9. Story — "Why we pour it long"

- Copy: CONTENT §5.
- An arched-top image (story-counter).
- A three-fact line.

## 10. Gallery — "A look inside"

- 8 images (ASSETS.md), mixed aspect ratios, responsive grid.
- Each tile is a button: "Open image N of 8".
- Lightbox uses `yet-another-react-lightbox` default controls: arrows, Esc, click-outside close, swipe.

## 11. Reviews — "What regulars say"

- 3 fictional quotes with first name and neighbourhood (CONTENT §7).
- No avatars or faces.
- Covered by the site-wide fictional disclaimer (§17).

## 12. Reservation — "Reserve a table" (DECIDED: demo-only, local state)

**Step 1 — When:**
- **Date:** today → today + 30 days.
- **Time:** 30-minute slots from 7:00 am to 9:30 pm (30 slots). For today, slots earlier than now + 30 minutes are disabled.
- **People:** a 1–8 stepper. At 8, show "For bigger groups, call us." with the tel link.
- **Seating:** Indoor or Verandah (default Indoor).

**Step 2 — Who:**
- **Full name:** required, ≥ 2 characters.
- **Mobile number:** required, Indian mobile. Accepts spaces, dashes and an optional +91 / 91 / 0 prefix. 10 digits starting 6–9.
- **Email:** optional, validated if present.
- **Occasion:** optional select.
- **Notes:** optional textarea, max 200 characters, with a live counter.

**Step 3 — Check and confirm:**
- Summary of every field, each with an "Edit" link back to its step.
- The "Confirm reservation" button.

**Confirmation:**
- Heading "Reservation confirmed".
- A generated reference `B2B-XXXX` (4 chars from `A–H J–N P–Z 2–9`).
- The demo notice.
- "Add to calendar": downloads a `.ics` file built in the browser (Blob). Start time is IST converted to UTC (minus 5h30), duration 90 min, location = café address.
- "Make another reservation": resets the flow.

**Live token:**
- On desktop, a kraft "token" beside the form mirrors the chosen date, time, people and seating as they change.
- On confirmation it shows the reference and a kumkum stamp.

**Validation and accessibility:**
- Errors show on Continue/Confirm attempts, inline under each field, linked with `aria-describedby`.
- Focus moves to the first invalid field.
- On each step change, focus moves to the step heading.
- The confirmation is announced via `aria-live="polite"`.

**Logic:** lives in `src/lib/reservation.js` as pure functions (see phase-2 T2.8 for the exact API). UI in `src/components/reserve/ReserveSection.jsx`.

## 13. Visit — "Find us on 3rd Avenue"

- **Details:** address, hours, phone (tel:), email (mailto:) from CONTENT §1.
- **Map (DECIDED):** OpenStreetMap iframe, no API key. The exact URL is in CONTENT §1. `title` attribute from CONTENT §9.
- **"Get directions":** Google Maps search URL (CONTENT §1), new tab, `rel="noopener"`.
- **"Write to us" contact form:**
  - Fields: Name, Email, Message (all required, email validated).
  - Inline errors; inline success with the demo notice.

## 14. Footer and newsletter

- **Footer:** four groups (CONTENT §10) plus the bottom bar, including the fictional-café disclaimer and the `STUDIO` credit.
- **Newsletter "Roast notes" (#newsletter):**
  - One email field (required, validated), "Subscribe".
  - Inline success plus the demo notice.

## 15. Forms data-handling rule (DECIDED, non-negotiable)

- No form sends data anywhere. That covers reservation, contact and newsletter.
- None of the following anywhere in `src/`:
  - `fetch(`
  - `XMLHttpRequest`
  - `axios`
  - `sendBeacon`
  - `WebSocket`
  - `EventSource`
- Success states are local React state.
- A live pitch that needs delivery is a later, human-made change and never points at a real client inbox.

## 16. Non-functional requirements

- **Performance:**
  - Hero text visible (LCP) < 2.5s on throttled 4G mid-range mobile.
  - JS budget per TECH_STACK §6.
  - 3D chunk lazy-loaded.
  - The canvas pauses when the hero is off-screen.
  - dpr ≤ 1.75 (1.25 on low-power devices).
- **Responsive:** 375, 768, 1024 and 1440 widths all look designed. No horizontal overflow at 375.
- **Accessibility:**
  - Landmarks; one h1; h2 per section; h3 for menu item names and step titles.
  - Visible focus; labelled fields; WCAG AA contrast (DESIGN §2 pairs).
  - Full keyboard path.
  - Reduced motion: no Lenis, no pins, no preloader, no SplitText, Tier C hero, instant transitions. All content visible.
- **SEO (in `index.html`):**
  - unique title and meta description
  - OG and Twitter tags
  - `CafeOrCoffeeShop` JSON-LD
  - SVG favicon
- **Analytics:** one `<!-- ANALYTICS SLOT ... -->` comment in `<head>`. Nothing live.
- **Browsers:** current Chrome, Safari (incl. iOS), Firefox, Edge.

## 17. Demo honesty rules (DECIDED)

- The footer states the café is fictional and credits `STUDIO` (CONTENT §10).
- AI-generated images are never presented as real photos of a real business. The disclaimer covers them. No generated human faces.
- Reviews are fictional (covered by the disclaimer).
- The phone number is deliberately non-dialable.
- The address uses a fictional door number on a real street. The map points at the street, not a building.

## 18. Success criteria

- Every section in §4 is present, populated from CONTENT.md, and working.
- `bash scripts/check.sh final` passes.
- A reviewer can complete a reservation on mobile with keyboard or touch and download the `.ics`.
- The hero ships at Tier A, or Tier B with the reason logged.

## 19. Decisions log

| Item | Decision |
|---|---|
| Price tier | $5,000 |
| Location | 3rd Avenue, Besant Nagar, Chennai 600090 (fictional door no.) |
| Hero | Procedural metre-pour, tiers A/B/C |
| Map | OpenStreetMap iframe |
| Reservation | 3-step demo flow + .ics, local only |
| Contact | Form inside #visit |
| Palette/type | DESIGN §2–3 |
| Studio credit | `STUDIO` constant in `src/data/site.js` |
