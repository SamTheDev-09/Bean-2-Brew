# DESIGN — look, motion and 3D art direction

## 1. Concept: "Brass and the long pour"

The site is built from the Madras filter-kaapi ritual:
- brass tumbler and dabara
- dark decoction
- the metre-high pour that makes the froth
- kraft coffee bags
- kumkum red
- the Tamil word on the signboard

**The one memorable thing is the hero pour.** Everything around it stays quiet and disciplined. Spend boldness there, and let the menu board and the reservation token be the only other "characterful" moments.

**Why these choices are not template defaults:**
- **No cream background with a terracotta accent.** That is the #1 AI-site tell. The page is dark decoction, and light kraft appears only as paper objects: the menu board and the booking token.
- **Brass is the accent** because the tumbler is brass. It is a warm metallic gold, not an acid-bright single accent.
- **Type is an Indian fat-face display (Rozha One)**, the look of hand-painted South Indian signboards, paired with Hind Madurai, which covers Tamil.

## 2. Palette (DECIDED)

| Token | Hex | Role |
|---|---|---|
| `decoction` | `#1F130D` | Page background, text on kraft |
| `roast` | `#3A2418` | Raised dark surfaces (panels, inputs, footer band) |
| `jasmine` | `#F3EDE1` | Body text and headings on dark |
| `kraft` | `#E8DCC4` | Paper objects only: menu board, booking token |
| `brass` | `#C9A24A` | Accent: primary buttons, active tab indicator, focus ring, 3D metal, rules |
| `kumkum` | `#B3372F` | Tiny accents only: seasonal tag, error marks, confirmation stamp |

**Allowed text/background pairs (WCAG AA verified):**

| Pair | Ratio | Allowed use |
|---|---|---|
| jasmine on decoction | ~15:1 | Any text |
| jasmine on roast | ~11:1 | Any text |
| brass on decoction | ~7.5:1 | Any text |
| decoction on brass | ~7.5:1 | Button labels |
| decoction on kraft | ~12:1 | Any text |
| kumkum on kraft | ~4.9:1 | Tags and stamp text |

**Never:**
- brass on kraft
- kumkum on decoction or roast for text (use it only for icons, borders and marks there)
- jasmine at reduced opacity for body text

## 3. Type (DECIDED)

- **Display:** `Rozha One` 400 (`@fontsource/rozha-one`). Used for h1, h2, step numbers, menu prices, review quotes.
- **Body/UI:** `Hind Madurai` 400/500/600 (`@fontsource/hind-madurai`). Also renders the Tamil glyph.
- **Fallback if either package fails to install (T0.2):** `Fraunces` 600 + `Inter` 400/500/600 at `@fontsource/*@5.3.0`. Log it in STATUS.
- **CSS stacks:**
  - `--font-display: "Rozha One", "Fraunces", Georgia, serif;`
  - `--font-sans: "Hind Madurai", "Inter", system-ui, sans-serif;`

**Scale (fluid):**

| Role | Size | Line height / tracking |
|---|---|---|
| h1 | `clamp(3.25rem, 8.5vw, 8rem)` | 0.95 line height, tracking -0.01em |
| h2 | `clamp(2.25rem, 5vw, 4.25rem)` | 1.0 |
| h3 | `1.5rem` | 1.2, Hind Madurai 600 |
| Body | `1.0625rem` | 1.65 |
| Small | `0.875rem` | 1.5 |
| Tamil glyph | `clamp(10rem, 28vw, 26rem)` | Hind Madurai 600, jasmine at 5% opacity, behind hero text |

**Rules:**
- Measure ≤ 68ch for body text.
- Sentence case everywhere.
- **No** `uppercase`, no letter-spaced eyebrow labels above headings, no single-word colour or italic accents inside headlines.

## 4. Layout

- **Container:** max-width 1320px, horizontal padding `clamp(1.25rem, 4vw, 3rem)`. 12-column grid on lg.
- **Alignment:** left-aligned throughout. Nothing centred except the preloader and the confirmation stamp.
- **Section rhythm:** vertical padding `clamp(5rem, 10vw, 9rem)`; `scroll-margin-top: 5rem` on every section.
- **Radii:**
  - Buttons and the tab indicator are pills (999px).
  - Panels are 4px.
  - Images have 0 radius, except the story image, which has an **arched top** (`border-radius: 50% 50% 0 0 / 22% 22% 0 0`), like the verandah arches.
- **Shadows:** none, except the header when solid (`0 1px 0 rgba(201,162,74,.25)` hairline).

**Hero (lg):**
```
┌────────────────────────────────────────────────────────────────────────┐
│ Bean 2 Brew        Menu  The pour  Story  Gallery  Visit  (Reserve a table) │
│                                                       ╭──╮  tumbler (rises) │
│  Filter kaapi,                                        ╰┬─╯                  │
│  pulled a metre                                        │   stream           │
│  high.                                                 │                    │
│  Small-batch roasts, slow-dripped…                     │                    │
│  (Reserve a table)  (See the menu)                 ╰───────╯ dabara + froth │
│ காபி  ← huge, 5% jasmine, bottom-left, behind text        Scroll to pour     │
└────────────────────────────────────────────────────────────────────────┘
```
- Text sits in columns 1–6 and the 3D stage in 6–12.
- On mobile: text first, then the stage at 55svh below it; the h1 stays readable.

**Menu board:**
- A kraft panel with decoction text. Two item columns on lg, one on mobile.
- Each line reads `Name ········· ₹90` (a dotted leader built with a flex spacer and a dotted `border-bottom`), with the description underneath at small size.
- Tabs sit above the panel as text buttons on the dark page, with a brass pill indicator that slides (`layoutId`).

**Process:**
- lg: a pinned horizontal track of 4 panels, each 80vw with max 1100px. Image (4:5) left; display-face step number, title and body right.
- Mobile: a vertical stack.

**Story:** arched image in columns 1–5, text in 7–12, fact line under the text as three plain items with space between.

**Gallery:**
- Grid: 2 columns at md, 3 at lg, with 4:5 tiles spanning two rows and 3:2 tiles spanning one. Gap 12px.
- Hover/focus shows a 1px brass inset outline. No scaling.

**Reviews:** three quotes stacked, display face at `clamp(1.5rem, 2.6vw, 2.25rem)`, with the attribution in small body text below. There are no cards.

**Reserve (lg):**
```
┌──────────── token (kraft) ────────────┐  ┌──── form panel (roast) ────────────┐
│ Bean 2 Brew                  No. ____ │  │ Step 1 of 3   ▬ ▭ ▭                │
│ Date      Sat, 27 Sep                 │  │ When                               │
│ Time      7:30 pm                     │  │ [date] [time slots grid]           │
│ People    2                           │  │ People  (−) 2 (+)   Seating ◉ ◯    │
│ Seating   Verandah                    │  │                    (Back) (Continue)│
│ ┄┄┄┄┄┄┄┄ perforation ┄┄┄┄┄┄┄┄┄┄┄┄┄┄  │  └────────────────────────────────────┘
│ Reference —            [stamp here]   │
└───────────────────────────────────────┘
```
- The perforation is a row of small radial-gradient cut-outs via CSS mask.
- Time slots are a grid of pill toggles (`aria-pressed`). Disabled slots use jasmine at 35% and are not focusable.
- On mobile the token collapses to a one-line summary bar above the form.

**Visit:** map (4:3, `filter: sepia(.25) saturate(.8)`) on the left; details and the "Get directions" button on the right; the contact form below at full width with a max of 720px.

**Footer:** roast newsletter band on top, then four groups on decoction, then the bottom bar.

## 5. Motion (DECIDED budget)

**Easing:** `--ease-pour: cubic-bezier(0.22, 1, 0.36, 1)`.
**Durations:** 200ms (press), 400ms (UI), 700ms (reveals), 1200ms (preloader fill).

**Allowed (the complete list):**
1. **Page load (the only non-user-triggered intro):**
   - The preloader fills the tumbler outline with decoction (clip-path), shows the wordmark, and wipes up.
   - Then the hero h1 lines rise from a mask (GSAP SplitText `type: "lines"`, `yPercent: 100 → 0`, stagger 0.08).
   - Then the subhead and CTAs fade in (opacity only).
2. **Scroll set piece 1:** hero pinned for `+=100%` (desktop) / `+=60%` (mobile); scrub drives the pour `progress`.
3. **Scroll set piece 2:** process horizontal track (lg only).
4. **Smooth scroll:** Lenis (`lerp: 0.1`), synced to the GSAP ticker.
5. **User-triggered:**
   - header solid/hide/show
   - mobile menu open/close (AnimatePresence, 400ms)
   - menu tab indicator (`layoutId`) and item layout/exit
   - reservation step transitions (direction-aware 24px slide + fade, 400ms)
   - confirmation stamp (scale 1.4 → 1 with slight rotation, 300ms)
   - button press `scale: 0.98`
   - lightbox

**Banned** (these read as template sites):
- fade-up on every section
- hover lift on cards
- custom cursor
- parallax on every image
- marquee tickers
- typewriter text
- animated gradients
- scroll-linked colour changes

**Reduced motion:**
- None of 1–4 happen.
- Transitions are instant (`MotionConfig reducedMotion="user"` plus the CSS media rule).
- The hero shows Tier C, static.
- All content is visible without JS-driven reveals.

## 6. 3D art direction (hero)

**Scene:**
- Canvas with transparent background over a decoction → roast radial gradient.
- Camera `fov 32`, position `[0, 0.1, 5.4]`, looking at `[0, -0.1, 0]`.
- `dpr={[1, 1.75]}` (1.25 max on low-power devices).
- `gl={{ antialias: true, alpha: true, powerPreference: "high-performance" }}`.

**Lighting (local only, no downloads):**
```jsx
<Environment resolution={256}>
  <Lightformer form="rect" intensity={3} color="#FFD8A8" position={[3, 2, 3]} scale={[4, 2, 1]} />
  <Lightformer form="ring" intensity={2} color="#C9A24A" position={[-3, 1, -2]} scale={2} />
  <Lightformer form="rect" intensity={0.8} color="#F3EDE1" position={[0, -3, 2]} scale={[6, 1, 1]} />
</Environment>
<ambientLight intensity={0.15} />
```
Never use `preset=` or files.

**Brass material:** `meshStandardMaterial` with color `#C9A24A`, metalness 1, roughness 0.28, `side: DoubleSide`.

**Lathe profiles** (points are `[radius, y]`, 64 segments):
- **Tumbler** (≈1 unit tall): `[[0,0],[0.26,0],[0.27,0.02],[0.30,0.55],[0.33,0.95],[0.355,1.0],[0.345,1.02]]`
- **Dabara** (wide bowl): `[[0,0],[0.40,0],[0.42,0.03],[0.55,0.22],[0.62,0.36],[0.66,0.38],[0.65,0.40]]`

**Composition:**
- Group centred in the stage. Dabara at `y = -1.25`.
- The tumbler is tilted `rotation.z ≈ 2.3` rad so its mouth faces down towards the dabara, with x offset −0.25.
- **Tumbler height by progress:** `y = lerp(-0.2, 1.35, progress)`. At progress 1 the pour reads as "a metre".

**Stream:**
- A tapered cylinder (radius 0.028 at top → 0.014 at bottom) from the tumbler lip to the dabara surface (`y ≈ -0.95`), recomputed each frame.
- `shaderMaterial` with scrolling value noise:
  - base `#3B1F12`
  - highlight `#8A5A32`
  - speed tied to time
- Opacity 0.95.

**Froth:**
- `points`: 380 on desktop, 180 on low-power.
- A disc of radius 0.5 at the dabara surface.
- Colour `#D9C3A0`. Point size and density rise with progress.

**Steam:**
- `points`: 260 / 120.
- Uses the canvas-generated soft sprite (`THREE.CanvasTexture`), additive blending, jasmine at opacity 0.10.
- Rises from the dabara, swaying, and wraps back to the bottom.

**Idle:**
- The tumbler bobs `±0.02`.
- The stream shader always animates.
- **Pointer (desktop):** group `rotation.y = pointer.x * 0.25`, `rotation.x = pointer.y * 0.08`, damped 0.08.

**Performance:**
- Pause rendering (`frameloop="never"`) when the hero is out of view (IntersectionObserver). Resume on entry.
- Low-power heuristic: `hardwareConcurrency <= 4` or `deviceMemory <= 4`.

**HeroFallback (Tier C):**
- Inline SVG line art of a tumbler above a dabara, with a brass stroke of 2px.
- Two CSS steam wisps (blurred jasmine ellipses rising, 6s loop), removed under reduced motion.
- Same box size as the canvas.

## 7. Components

- **Primary button:** brass background, decoction text, Hind Madurai 600, padding `0.9rem 1.5rem`, pill, press `scale .98`.
- **Secondary button:** 1px jasmine border, jasmine text, transparent background.
- **Buttons generally:** no arrows or icons appended to labels.
- **Inputs:**
  - decoction background inside roast panels, 1px roast-lighter border (`#5A3A28`), jasmine text, 48px min height.
  - Label above in Hind Madurai 500 small. Helper text below.
  - Errors: a kumkum 3px left border plus jasmine error text (never kumkum text on dark).
  - **No `placeholder` attribute.** Use labels and helpers instead.
- **Tags:** kraft background with kumkum text, or a 1px brass outline with brass text on dark, small, pill.
- **Links in text:** jasmine, underline offset 3px, brass on hover.

## 8. Imagery

**Direction:**
- warm natural light, brass and dark wood, shallow depth of field
- documentary rather than stock, light film grain
- **no text in images, no human faces**; hands are fine

**Handling:**
- Images are object-cover inside fixed aspect-ratio wrappers, so there is no layout shift.
- Fallback art (auto-generated SVGs) keeps the same aspect ratios.

## 9. Anti-template audit (checked in T6.1)

**Forbidden in `src/`:**
- `uppercase`
- the `→` character
- ` · ` (middle dot with spaces)
- the strings `lorem`, `TODO`, `TBD`, `FIXME`, `placeholder`

**Also avoid (reviewed at checkpoints):**
- identical card grids
- numbered markers outside the process section
- gradient washes as decoration
- more than one orchestrated load animation
