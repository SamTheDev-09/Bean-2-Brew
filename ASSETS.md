# ASSETS — imagery brief and Higgsfield workflow

**Who does this:** you (the human), in a **separate Claude Code session** with the Higgsfield MCP. The build loop never generates images; it is blocked from Higgsfield by `.claude/settings.json`.

**When:** any time before Phase 6. The site works without these images: T1.5 generates on-brand SVG fallback art. Drop real images in and rebuild, and they replace the fallbacks automatically. No code change is needed.

## 1. Where files go

| Asset | Folder | Name |
|---|---|---|
| Site images | `src/assets/img/` | `<id>.webp` (preferred) or `<id>.jpg` |
| Social card | `public/` | `og-cover.jpg` (1200×630) |

**Resolution order:** `src/data/assets.js` picks **webp → jpg → jpeg → png → svg** for each id. Never delete the `.svg` fallbacks.

**Limits:** ≤ 350 KB each, long edge ≤ 1600px. Convert or compress before copying: squoosh.app works in-browser, or use `cwebp -q 80 in.png -o out.webp`.

## 2. Style suffix (append to every prompt)

> Natural morning light, warm brass and dark teak tones, shallow depth of field, documentary 35mm photograph, subtle film grain, Chennai, no text, no logos, no human faces.

## 3. Shot list

| id | Aspect / size | Prompt (then add the suffix) |
|---|---|---|
| story-counter | 4:5, 1200×1500 | A small specialty café counter at 7 am: a row of polished brass filter-coffee tumblers and dabaras on a dark teak counter, a steel coffee filter dripping, a jasmine string on a hook, light through wooden shutters |
| process-01-estate | 4:5, 1200×1500 | Ripe red coffee cherries on a branch in a shade-grown estate in Chikmagalur, silver oak trunks and morning mist behind |
| process-02-roast | 4:5, 1200×1500 | Freshly roasted coffee beans tumbling from a small drum roaster into a round cooling tray, warm workshop light |
| process-03-decoction | 4:5, 1200×1500 | Close-up of a traditional South Indian brass coffee filter, dark decoction dripping into the lower chamber, a thin wisp of steam |
| process-04-pour | 4:5, 1200×1500 | Hands pouring filter coffee from a brass tumbler held high into a dabara below, a long unbroken stream and rising froth, dark background |
| gallery-01-verandah | 4:5, 1200×1500 | Café verandah with cane chairs, red oxide floor, potted areca palms, arched openings, soft morning light |
| gallery-02-kaapi | 1:1, 1200×1200 | Top-down view of filter kaapi with thick froth in a brass tumbler set inside a dabara on a dark wooden table |
| gallery-03-croissant | 4:5, 1200×1500 | An almond croissant with flaked almonds and powdered sugar on a stoneware plate by a window |
| gallery-04-tiramisu | 1:1, 1200×1200 | Coffee tiramisu dusted with cocoa in a small glass, a brass spoon beside it, dark table |
| gallery-05-espresso-bar | 3:2, 1500×1000 | An espresso machine with brass details pulling a double shot into a ceramic cup, café bar at dawn |
| gallery-06-rose-milk | 4:5, 1200×1500 | A tall glass of pale pink rose milk with basil seeds and condensation on a marble table |
| gallery-07-kolam | 3:2, 1500×1000 | A white rice-flour kolam pattern drawn on a red oxide floor at a café entrance, morning shadows |
| gallery-08-storefront | 3:2, 1500×1000 | A small café storefront on a tree-lined Chennai residential street at dusk, warm light inside, bicycles outside, signboard not readable |
| og-cover (public/) | 1200×630 | Brass tumbler pouring a long stream of filter coffee into a dabara, froth, dark warm background, empty space on the left third |

## 4. Session recipe

1. **One-time connection:**
   ```bash
   claude mcp add --transport http --scope user higgsfield https://mcp.higgsfield.ai/mcp
   ```
   Then run `/mcp` inside Claude Code and log in.
2. **Run the generation session from a scratch folder**, not the site repo, because the repo blocks Higgsfield:
   ```bash
   mkdir ../b2b-assets && cd ../b2b-assets && claude
   ```
   Then paste:
   > Read ../bean2brew/ASSETS.md. For each row in §3, generate 2 candidates with Higgsfield's best photoreal image model at the listed aspect, using the prompt plus the §2 suffix. Save as `<id>-a` and `<id>-b` here. Don't generate anything not in the table. Stop after the table and list the files.
3. **Choose and copy:** pick the better candidate per id, convert or compress to ≤ 350 KB webp, and copy into `src/assets/img/<id>.webp`. Copy the og-cover into `public/og-cover.jpg`.
4. **Verify:** in the site repo, run `npm run build` and look at the page. The fallbacks are replaced.

## 5. Rules

- These are fictional images for a fictional café. The footer disclaimer covers them. Never use them to represent a real business.
- No generated faces (reviews stay anonymous-by-design).
- Check every image for garbled text, extra fingers and wrong vessels. The tumbler must be a straight-sided brass cup; the dabara is a wide, low bowl.
