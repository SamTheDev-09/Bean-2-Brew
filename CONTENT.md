# CONTENT — every word and number on the site

**Rules for using this file:**
- Use it verbatim. Section copy goes inline in its component's JSX. Business data goes in `src/data/*`.
- If a visible string you need is not here, write the minimum neutral string and log it in `STATUS.md` → Decisions as `Copy added: "<text>" in <file>`.
- Sentence case everywhere. No all-caps and no arrows in links or buttons.

---

## 1. Business data → `src/data/site.js`

| Key | Value |
|---|---|
| name | Bean 2 Brew |
| tagline | Pulled a metre high. |
| addressLines | `["No. 27, 3rd Avenue", "Besant Nagar, Chennai 600090", "Tamil Nadu"]` |
| addressOneLine | No. 27, 3rd Avenue, Besant Nagar, Chennai 600090 |
| phoneDisplay | 044 0000 0000 |
| phoneHref | tel:+914400000000 |
| email | hello@bean2brew.in |
| hours | Open every day, 7:00 am to 10:30 pm. |
| lastSeating | Last seating 9:30 pm. |
| established | 2019 |
| mapEmbedUrl | `https://www.openstreetmap.org/export/embed.html?bbox=80.2615%2C12.9958%2C80.2715%2C13.0058&layer=mapnik&marker=13.0008%2C80.2665` |
| directionsUrl | `https://www.google.com/maps/search/?api=1&query=3rd%20Avenue%2C%20Besant%20Nagar%2C%20Chennai%20600090` |
| geo | `{ lat: 13.0008, lon: 80.2665 }` |
| social | Instagram `https://www.instagram.com/bean2brew.chennai` · Facebook `https://www.facebook.com/bean2brew.chennai` |

**Also export** `STUDIO = "Aroha Rudran Group"`. This is the one line a human edits to change the credit.

**Notes on the data:**
- The phone number is deliberately non-dialable.
- The door number is fictional.
- The map coordinates are approximate for 3rd Avenue, Besant Nagar. T2.14 visually confirms the pin sits in Besant Nagar.

## 2. Header and hero

- **Wordmark:** Bean 2 Brew
- **Nav:** Menu · The pour · Story · Gallery · Visit. These are separate links; the dots are not rendered.
- **Header CTA:** Reserve a table
- **Mobile toggle aria-labels:** Open menu / Close menu
- **Skip link:** Skip to content
- **h1 (one string in JSX, split into lines at runtime):** Filter kaapi, pulled a metre high.
- **Subhead:** Small-batch roasts, slow-dripped decoction and pastries out of the oven by seven. On 3rd Avenue, Besant Nagar.
- **Primary CTA:** Reserve a table → #reserve
- **Secondary CTA:** See the menu → #menu
- **Decorative Tamil glyph (aria-hidden):** காபி
- **Scroll hint (visually small, aria-hidden):** Scroll to pour

## 3. Menu → `src/data/menu.js`

- **h2:** The board
- **Subhead:** What's on today. Ask at the counter for this week's roast.
- **Tabs (`MENU_TABS`):** `["All", "Kaapi", "Espresso bar", "Chai and coolers", "Bakes"]`

| name | tab | price (₹, number) | description | tag |
|---|---|---:|---|---|
| Madras filter kaapi | Kaapi | 90 | Chicory-blend decoction and boiling milk, pulled between tumbler and dabara. | |
| Karupatti kaapi | Kaapi | 120 | Filter kaapi sweetened with palm jaggery instead of sugar. | |
| Jaggery cold brew | Kaapi | 220 | Eighteen-hour cold brew over ice with a spoon of jaggery syrup. | |
| Cappuccino | Espresso bar | 200 | A double shot of the house espresso with velvet-textured milk. | |
| Flat white | Espresso bar | 220 | Shorter and stronger, with a thin layer of microfoam. | |
| Honey cardamom latte | Espresso bar | 240 | Espresso, wild forest honey and freshly crushed green cardamom. | |
| Masala chai | Chai and coolers | 110 | Assam leaf boiled with ginger, cardamom and black pepper. | |
| Iced matcha | Chai and coolers | 260 | Ceremonial-grade matcha whisked to order. Oat milk on request. | Vegan option |
| Rose milk | Chai and coolers | 140 | Chilled milk, house rose syrup and soaked basil seeds. | |
| Almond croissant | Bakes | 180 | Twice-baked and filled with almond cream. Out of the oven at seven. | |
| Filter kaapi tiramisu | Bakes | 260 | Savoiardi soaked in our decoction, mascarpone and cocoa. | |
| Banana walnut bread | Bakes | 150 | Made with Nendran bananas and served warm with salted butter. | |
| Mango cheesecake | Bakes | 280 | Alphonso pulp over a baked cheesecake. April to June only. | Seasonal |

- **Price display:** `₹90` (no decimals).
- **Footnote:** Prices include GST. The menu changes with the season.

## 4. Process → `src/data/process.js`

- **h2:** From estate to dabara
- **Subhead:** Every tumbler takes four steps and about a week.

| # | image id | title | body |
|---|---|---|---|
| 1 | process-01-estate | The estate | Arabica and robusta from shade-grown estates in Chikmagalur, picked ripe and sun-dried. |
| 2 | process-02-roast | The roast | Roasted in 5 kg batches twice a week. A shade darker for the filter blend, lighter for the espresso bar. |
| 3 | process-03-decoction | The decoction | Ground fine with one part chicory to four of coffee, packed into a brass filter and left to drip slowly. |
| 4 | process-04-pour | The pour | Decoction meets boiling milk, then the long pour between tumbler and dabara until the froth stands up. |

## 5. Story

- **h2:** Why we pour it long
- **Paragraph 1:** Bean 2 Brew began in 2019 as a four-table room on 3rd Avenue and one brass filter that never went cold. We wanted the kaapi we grew up on, made with the patience of a specialty roaster.
- **Paragraph 2:** Our beans come from two estates in Chikmagalur and Baba Budangiri. We roast every Tuesday and Friday, brew decoction through the night, and bake before the first walkers come back from Elliot's Beach.
- **Paragraph 3:** Regulars find their tumbler waiting before they sit down. Stay as long as you like.
- **Fact line:** three separate items, not joined by dots: Since 2019 / Roasted twice a week / Two estates, one blend

## 6. Image alt text → `src/data/assets.js`

| id | alt |
|---|---|
| story-counter | Brass tumblers and dabaras lined up on a dark teak counter at Bean 2 Brew |
| process-01-estate | Ripe red coffee cherries on a branch in a shaded Chikmagalur estate |
| process-02-roast | Freshly roasted beans pouring from a small drum roaster into a cooling tray |
| process-03-decoction | Decoction dripping through a traditional brass coffee filter |
| process-04-pour | Filter kaapi poured in a long stream from a tumbler into a dabara |
| gallery-01-verandah | Cane chairs and potted palms on the café's verandah |
| gallery-02-kaapi | Filter kaapi with thick froth in a brass tumbler and dabara, seen from above |
| gallery-03-croissant | An almond croissant on a stoneware plate by the window |
| gallery-04-tiramisu | Filter kaapi tiramisu in a small glass with a brass spoon |
| gallery-05-espresso-bar | The espresso machine pulling a double shot at the bar |
| gallery-06-rose-milk | A tall glass of rose milk with basil seeds |
| gallery-07-kolam | A rice-flour kolam drawn on the floor by the café entrance |
| gallery-08-storefront | The café storefront on 3rd Avenue at dusk |

- **Gallery h2:** A look inside
- **Gallery subhead:** Mornings on 3rd Avenue.
- **Tile aria-label pattern:** Open image {n} of 8

## 7. Reviews → `src/data/reviews.js`

- **h2:** What regulars say

| quote | name | area |
|---|---|---|
| The filter kaapi tastes like my grandmother's, and the croissants beat anything I had in Pondicherry. | Meera | Adyar |
| I come for the verandah seats on Sunday mornings and always stay for a second tumbler. | Arjun | Thiruvanmiyur |
| I booked a table for my mother's birthday. They remembered she takes her kaapi without sugar. | Fathima | Kotturpuram |

**Attribution format:** `Meera, Adyar`

## 8. Reservation

**Headings and step titles:**
- **h2:** Reserve a table
- **Subhead:** Tables for up to 8 people. For bigger groups, call us.
- **Step indicator:** Step {n} of 3
- **Step titles (h3):** When / Who / Check and confirm

**Step 1 labels:**
- Date
- Time
- People (stepper buttons aria-labels: Fewer people / More people)
- Seating, with options Indoor / Verandah
- **At 8 people:** For bigger groups, call us. (the phone number is a tel: link)
- **No slots left today:** No tables left today. Choose another date.

**Step 2 labels:**
- Full name
- Mobile number, with helper text: 10 digits. We only use it for this booking.
- Email (optional)
- Occasion (optional), with options None / Birthday / Anniversary / Work meeting / Something else
- Anything we should know? (optional), with counter `{n}/200`

**Buttons:** Continue / Back / Edit / Confirm reservation

**Confirmation:**
- **Heading:** Reservation confirmed
- **Body:** Table for {people} on {date} at {time}. Your reference is {ref}.
  - Date format: `Sat, 27 Sep` via `Intl.DateTimeFormat('en-IN', { weekday: 'short', day: 'numeric', month: 'short' })`.
  - Time format: `7:30 pm`.
- **Demo notice:** This is a demo booking. No table has been held and nothing left this page.
- **Buttons:** Add to calendar / Make another reservation
- **.ics fields:**
  - SUMMARY: `Table at Bean 2 Brew ({people} people)`
  - LOCATION: addressOneLine
  - DESCRIPTION: `Reference {ref}. Demo booking.`

**Token (desktop):**
- **Labels:** Date / Time / People / Seating / Reference
- **Empty value:** —
- **Stamp text after confirm:** Confirmed

## 9. Visit and contact

**Visit:**
- **h2:** Find us on 3rd Avenue
- **Subhead:** Two streets back from Elliot's Beach.
- **Labels:** Address / Hours / Phone / Email
- **Hours shown as:** hours + " " + lastSeating
- **Directions button:** Get directions
- **Map iframe title:** Map showing Bean 2 Brew in Besant Nagar, Chennai

**Contact form:**
- **h3:** Write to us
- **Intro:** Private events, catering or kaapi for the office. We reply within a day.
- **Fields:** Name / Email / Message
- **Button:** Send message
- **Success:** Message sent. This is a demo form, so nothing actually left this page.

## 10. Newsletter and footer

**Newsletter (#newsletter):**
- **h2:** Roast notes
- **Subhead:** One email a month: the new roast, seasonal bakes and the odd free-croissant morning.
- **Field label:** Email address
- **Button:** Subscribe
- **Success:** Subscribed. See you at the counter. (Demo: your email was not stored.)

**Footer groups:**
1. **Brand:** wordmark, tagline, addressLines.
2. **Visit:** hours, lastSeating, phone, email.
3. **Explore:** Menu, The pour, Story, Gallery, Reserve a table (anchor links).
4. **Follow:** Instagram, Facebook. Text links with `aria-label` "Bean 2 Brew on Instagram" / "Bean 2 Brew on Facebook", `target="_blank" rel="noopener"`.

**Bottom bar:**
- `© 2026 Bean 2 Brew.`
- `Bean 2 Brew is a fictional café. Site designed and built by {STUDIO} as a demo.`

**MobileReserveBar button:** Reserve a table

## 11. SEO strings (`index.html`)

- **title:** Bean 2 Brew | Filter kaapi and specialty coffee in Besant Nagar, Chennai
- **meta description (≤160 chars):** Filter kaapi pulled a metre high, small-batch roasts and fresh bakes on 3rd Avenue, Besant Nagar. Reserve a table online.
- **og:title:** same as title
- **og:description:** same as the meta description
- **og:image:** `/og-cover.jpg`. Human-supplied per ASSETS.md. Add the comment `<!-- replace with absolute URL after deploy -->`.
- **og:locale:** en_IN
- **og:type:** website
- **og:site_name:** Bean 2 Brew
- **twitter:card:** summary_large_image
- **JSON-LD `CafeOrCoffeeShop`:**
  - name
  - address (streetAddress "No. 27, 3rd Avenue, Besant Nagar", addressLocality "Chennai", addressRegion "Tamil Nadu", postalCode "600090", addressCountry "IN")
  - geo
  - telephone "+914400000000"
  - email
  - openingHoursSpecification Mon–Sun 07:00–22:30
  - servesCuisine ["Coffee", "South Indian"]
  - priceRange "₹₹"
  - acceptsReservations "True"
  - url "/" (comment: replace after deploy)

## 12. Validation messages

| Field | Message |
|---|---|
| name | Enter your name. |
| mobile | Enter a 10-digit mobile number starting with 6, 7, 8 or 9. |
| email (any form) | Enter an email address like name@example.com. |
| date | Choose a date in the next 30 days. |
| time | Choose a time. |
| party | Choose between 1 and 8 people. |
| message | Write a message. |
