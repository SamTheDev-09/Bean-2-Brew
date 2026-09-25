# Product Requirements Document — Bean 2 Brew Demo Site

**Positioning:** Premium small-business web package (~$2,000 tier). This document defines what “premium” means for the demo so scope is explicit and nothing is quietly cut during the build.

> **Refinement note (2026-09-25):** the open questions that previously lived in §7, §10, §14, §16 and §20 are now **resolved** (marked `DECIDED`). The build agent must not re-open them; changes require a human edit to this file.

## 1. Purpose

Build a complete, production-quality single-site demo for a fictional cafe, **Bean 2 Brew**, to pitch local cafes/restaurants on a premium web package. Every section below should be built as if a real client were paying for it: no lorem ipsum, no visible “TBD” placeholders in the final pitch version, and no section that feels like an unfinished stub.

## 2. What “premium, $2,000” means here

A $2,000 small-business site is not a template with a new logo. It commits to:

* **Custom-built sections:** every section below is bespoke to this brand’s content and layout.
* **A real signature interaction:** the 3D/fluid hero is a meaningful design moment, not just a stock hero image.
* **Working business essentials:** navigation, contact flow, hours/location, menu, social proof, newsletter capture, SEO basics, and an analytics-ready structure.
* **Responsive design at all breakpoints:** the mobile experience should look intentionally designed, not merely compressed.
* **Fast, accessible, and SEO-sound delivery:** a premium site should not be slow, inaccessible, or difficult for search engines to understand.
* **No dead ends:** every link, button, and form either performs its intended demo action or is clearly identified as a demo stand-in (see Section 8 and Section 17).

## 3. Audience

* **Primary:** local cafe/restaurant owners evaluating whether to commission a website.
* **Secondary:** anyone the demo is forwarded to.

## 4. Goals

* Create a “wow” moment within 3 seconds via the hero.
* Make the $2,000 value visible through concrete details such as the menu experience, contact flow, mobile navigation, and polish — not only through the 3D effect.
* Perform well on a mid-range phone.
* Remain fully self-contained and demo-safe: no real payments and no real personal-data collection.

## 5. Non-Goals

* No real ordering, payment, or reservation backend.
* No CMS/admin panel; content is hardcoded for the demo.
* No multi-location support or user accounts.

## 6. Brand Brief — “Bean 2 Brew”

* **Vibe:** warm, artisanal, a little playful.
* **Palette (DECIDED — locked to these values):** cream `#F5EDE2`, espresso brown `#3B2A20`, terracotta `#C97C4B`, muted sage `#7C8B6F` as a secondary accent.
* **Typography (DECIDED — locked):** Fraunces (display serif for headlines) + Inter (humanist sans for body/UI), self-hosted via `@fontsource`.
* **Voice:** warm, sensory, never salesy. Short sentences. First-person plural (“we”) for the cafe’s own voice.
* **Contrast rule (locked):** body text is espresso-on-cream only; terracotta is for large text/graphics only; sage is decorative/large only; the footer is cream text on espresso.

## 7. Sitemap — DECIDED

Single-page scroll site with anchor-linked sections:

```text
Header (sticky)
 ├─ Hero (#hero)
 ├─ Menu (#menu)
 ├─ Our Story (#story)
 ├─ Gallery (#gallery)
 ├─ Visit Us (#visit)
 ├─ Contact (#contact)        ← dedicated mini-section, NOT a modal
 └─ Newsletter / Community (#newsletter)
Footer (site-wide)
```

The header includes a **Contact** navigation item. **DECIDED:** Contact is implemented as its own dedicated mini-section (`#contact`, spec in §17) placed between Visit Us and Newsletter — simpler and more robust than a modal for this build.

## 8. Fictional business content

All business information below is fictional demo data and is used site-wide. The build agent copies it verbatim and invents nothing new.

* **Business name:** Bean 2 Brew
* **Tagline:** “Slow mornings, made right.”
* **Address:** 142 Maple Street, Riverside Corner, Springfield, IL 62704
* **Phone:** (555) 201-2837 (tel link: `tel:+15552012837`)
* **Email:** hello@bean2brew.com
* **Hours:** Mon–Fri 7:00am–7:00pm · Sat–Sun 8:00am–8:00pm
* **Social handles (demo/placeholder):** @bean2brew (Instagram `https://instagram.com/bean2brew`, TikTok `https://tiktok.com/@bean2brew`), `https://facebook.com/bean2brew`
* Contact and newsletter submissions must remain demo-safe: mock/no-op handler, inline success, **zero network calls**. No relay service is used in this demo build.

## 9. Header / Navigation — full spec

* **Logo:** “Bean 2 Brew” wordmark (text-based, left-aligned), linking to the top of the page.
* **Desktop nav items:** Menu · Our Story · Gallery · Visit Us · Contact
* **Primary CTA:** “Visit Us Today” → scrolls to Visit Us.
* **Behavior:**
  * Transparent/overlaid on the hero.
  * Transitions to a solid background + drop shadow on scroll (task T4.1).
  * Remains sticky during subsequent scrolling.
  * Active-section highlighting (IntersectionObserver, `aria-current`) — included, not just nice-to-have.
* **Mobile:** hamburger icon → full-screen menu with the same destinations, large touch targets (minimum 44px), and the CTA repeated at the bottom.

## 10. Hero Section — full spec

* **Headline:** “Slow Mornings, Made Right.” (the page’s only `<h1>`)
* **Subheadline:** “Small-batch coffee, baked fresh daily, poured with care in the heart of Riverside Corner.”
* **Primary CTA:** “See Our Menu” → scrolls to Menu.
* **Secondary CTA:** “Get Directions” → scrolls to Visit Us.
* **Signature interaction (DECIDED):** **ambient particle/steam field** — a procedural R3F points cloud with a code-generated soft sprite, slow upward drift. No external 3D model, no glTF, no lights. This candidate was chosen over the liquid-pour shader and the rotating cup because it has no asset pipeline, is cheap on a mid-tier phone, and degrades to a static gradient+CSS-steam fallback cleanly.
  * **Fallback (required):** `prefers-reduced-motion` or missing WebGL → static hero (gradient + CSS steam), same layout.
  * **De-risk rule:** if the effect is not stable after 2 attempts, ship the static fallback and record the deferral in `STATUS.md` (task T3.4).
* **Scroll cue:** small animated down-arrow at the bottom of the hero.

## 11. Menu Section — full spec

**Section intro:** “What We’re Pouring”

**Subhead:** “A few favorites — the full menu’s even bigger in person.”

Categories: **Coffee · Tea · Pastries · Seasonal** (filter row adds an “All” default)

| Item                             | Category | Price | One-line description                         |
| -------------------------------- | -------- | ----: | -------------------------------------------- |
| House Drip                       | Coffee   | $3.25 | Rotating single-origin, brewed fresh all day |
| Vanilla Bean Latte               | Coffee   | $4.75 | Espresso, steamed milk, real vanilla bean    |
| Maple Cortado                    | Coffee   | $4.25 | Equal parts espresso and milk, local maple   |
| Cold Brew Float                  | Coffee   | $5.50 | 24-hour cold brew, vanilla bean ice cream    |
| Honey Lavender Latte             | Coffee   | $5.25 | Espresso, local honey, house lavender syrup  |
| Chai Tea Latte                   | Tea      | $4.50 | House-spiced chai, steamed milk              |
| Iced Matcha                      | Tea      | $4.75 | Ceremonial-grade matcha, oat milk option     |
| Almond Croissant                 | Pastries | $3.75 | Baked fresh each morning                     |
| Cinnamon Sourdough Toast         | Pastries | $4.00 | House sourdough, brown butter cinnamon sugar |
| Pumpkin Spice Cortado (Seasonal) | Seasonal | $4.75 | Fall-only, real pumpkin, house spice blend   |

Each item card contains the name, price, one-line description, and a small circular badge (item initial in category color).

Category filtering must work client-side with no page reload.

Note under the grid:

> “Menu is seasonal and subject to change — see us in person for the full lineup.”

## 12. Our Story Section — full spec

* **Heading:** “Why We Started Pouring”
* **Body copy:**

  1. “Bean 2 Brew started with a simple idea: mornings should feel slower, even in a fast town. We roast in small batches, bake before sunrise, and pour every cup like it’s the only one we’re making that day.”
  2. “We’re a neighborhood spot first — regulars know their order before they reach the counter, and we like it that way. Come sit for a while.”
* **Supporting visual:** `public/img/story-space.*` (SVG placeholder or image-worker output — tracked as swappable content in `STATUS.md`).
* **Stat row:** “Est. 2019” · “Locally Roasted” · “Family Owned”

## 13. Gallery Section — full spec

* **Heading:** “A Look Inside”
* 6-image grid covering interior, drinks, pastries, pouring, exterior, and window seating.
* Lightbox (task T4.4, `yet-another-react-lightbox` default controls): enlarge, arrow navigation, close on Esc or click-outside.
* Images are placeholders for the demo; they are tracked as swappable content in `STATUS.md` and must not be presented as real photos of a real business.

## 14. Visit Us Section — full spec

* **Heading:** “Come Say Hi”
* **Address:** 142 Maple Street, Riverside Corner, Springfield, IL 62704
* **Phone:** (555) 201-2837; `tel:` link.
* **Hours:** Mon–Fri 7:00am–7:00pm · Sat–Sun 8:00am–8:00pm
* **Map (DECIDED):** **OpenStreetMap iframe embed** — no API key, no paid dependency. Exact embed URL is pinned in task T2.7.
* **Directions CTA:** “Get Directions” → opens the address in Google Maps (keyless search URL, pinned in T2.7), new tab.

## 15. Newsletter / Community Section — full spec

* **Heading:** “Stay in the Loop”
* **Subhead:** “First look at seasonal drinks, pop-up events, and the occasional free-pastry day.”
* **Form fields:** Email (required and validated), Submit button labeled “Subscribe”.
* **Success state:** inline confirmation `You're on the list — see you at the counter.` with no page reload.
* **Demo behavior:** mock/no-op handler. No email is stored or forwarded. No relay service is used in this demo build.

## 16. Footer — full spec

Site-wide footer:

* **Column 1 — Brand:** “Bean 2 Brew” wordmark + tagline + address.
* **Column 2 — Quick Links:** Menu · Our Story · Gallery · Visit Us · Contact.
* **Column 3 — Contact:** phone (`tel:`), email (`mailto:hello@bean2brew.com`), hours summary.
* **Column 4 — Social:** Instagram, Facebook, TikTok icons/links to the demo handles in §8.
* **Bottom bar:** “© 2026 Bean 2 Brew. All rights reserved.” + “Site design by **Brewworks Studio**” (DECIDED: fictional studio name, stored as one constant in `Footer.jsx` so a human can swap it in one line before a real pitch).

## 17. Contact & Forms — functional requirements

* **Contact destination (DECIDED):** dedicated mini-section `#contact` (spec in §7), heading “Say Hello”, fields Name, Email, Message, Submit.
* Client-side validation: required fields, valid email format, inline error messages.
* **Newsletter form:** as specified in Section 15.
* **Demo data handling rule (locked):** neither form may send data to a real inbox, database, or third-party list. No `fetch(`, no XHR, no third-party endpoint — the success state is local React state. This is non-negotiable for the demo build; if a live pitch later requires delivery, a human adds a disposable relay explicitly (never a real client inbox).
* Contact success line: “Thanks — we'll be in touch. (Demo form: nothing is actually sent.)”

## 18. Non-functional requirements

* **Performance:** first meaningful content visible in <2.5s on throttled mobile; JS budget per `TECH_STACK.md` (<400KB gzipped).
* **Responsive breakpoints:** mobile (base), tablet (≥768px), desktop (≥1024px), large desktop (≥1440px). Every section checked at all four (task T2.12).
* **Accessibility:** semantic HTML landmarks, alt text on all images, visible focus states, correct heading order (one `<h1>`), WCAG AA contrast for body text, reduced-motion fallbacks for the hero and all animations (tasks T3.2, T4.5, T5.1).
* **SEO basics:** unique `<title>`, meta description, Open Graph tags (title/description/image), one `<h1>` (the hero headline), semantic heading order (task T5.2).
* **Analytics-ready:** one commented insertion point `<!-- ANALYTICS SLOT -->` in `index.html` `<head>`; nothing live (task T5.3).
* **Browser support:** current Chrome, Safari, Firefox, Edge. No IE/legacy support.

## 19. Success Criteria

* A cafe owner can point to at least three specific elements (for example, the hero, menu filter, or mobile nav) and identify visible value versus a basic small-business site.
* Every section in this document is present, functional, and populated with real (if fictional) content in the pitch version; zero visible placeholder copy remains.
* The site meets the performance and accessibility requirements in Section 18.
* Both forms validate, display success states, and remain isolated from real customer/client data.

## 20. Risks / Open Questions — RESOLVED

| Original open question | Resolution | Where |
|---|---|---|
| Hero 3D effect | Ambient particle/steam field (procedural R3F), static fallback required | §10, tasks T3.1–T3.5 |
| Map provider | OpenStreetMap iframe (no key) | §14, task T2.7 |
| Contact destination | Dedicated mini-section `#contact` | §7, §17, task T2.9 |
| Photography | SVG placeholder set committed (cohesive, palette-only); image-worker upgrade path via `tools/gen_image.sh` if configured | tasks T1.3–T1.4 |
| Palette/typography | Locked to §6 values | §6 |

Remaining risk, owned by the plan: the 9B build agent may need the BLOCKED-and-continue protocol (see `CLAUDE.md`) — the plan is designed so any single blocked task never stops the loop.
