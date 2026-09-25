# Status — Bean 2 Brew Demo Site

> Update this file at the end of every task. Keep entries short and factual — this is a tracker, not a journal. The build agent reads it at the start of every loop iteration.

**Last updated:** 2026-09-25 (docs refined + scaffold committed by the planning agent)

**Overall phase:** Phase 0 — awaiting T0.1 (`npm install` + build check)

## Section-by-section status

| Section | Status | Notes |
|---|---|---|
| Design direction (palette, type, mood) | Done | Locked per `PRD.md` §6; tokens committed in `src/index.css` |
| Project scaffold (Vite/React/Tailwind) | Done | Committed: Vite 8.3.1 / React 19.3.0 / Tailwind 4.3.3 + all deps pinned + lockfile; `npm run build` verified |
| Header / Navigation | Not started | T2.1 (menu), T4.1 (scroll transition + active section) |
| Hero (3D/fluid centerpiece) | Not started | Effect decided: ambient steam field (T3.x); static fallback required |
| Menu (filterable, 10 items across 4 categories) | Not started | Content locked in `PRD.md` §11 (T2.3/T2.4) |
| Our Story | Not started | Copy locked in `PRD.md` §12 (T2.5) |
| Gallery (lightbox) | Not started | 6 images (T2.6) + lightbox (T4.4) |
| Visit Us (address, hours, map) | Not started | Map decided: OpenStreetMap iframe (T2.7) |
| Newsletter / Community | Not started | Mock/no-op submission (T2.8) |
| Contact form | Not started | Decided: dedicated mini-section (T2.9) |
| Footer (4-column + bottom bar) | Not started | Studio credit: Brewworks Studio (T2.10) |
| Reduced-motion / low-power fallback | Not started | Must cover hero (T3.2) and all motion (T4.5) |
| SEO meta tags (title/description/OG) | Not started | T5.2 |
| Analytics placeholder hook | Not started | T5.3 |
| Mobile performance pass | Not started | T2.12 + T4.6 + T5.4/T5.5 |
| Deployment (Vercel/Netlify) | Not started | T6.4 (conditional on authenticated CLI) |
| Images (SVG placeholder set) | In progress | T1.3 creates 8 SVGs; T1.4 optional image-worker upgrade (model TBD) |

## Status legend

* **Not started** — no implementation work completed.
* **In progress** — actively being built.
* **Needs review** — implemented, but requires review before being treated as complete.
* **Done** — matches the relevant PRD specification.
* **Blocked** — work cannot proceed until the issue in Notes/Open Issues is resolved.

## Open issues / blockers log

*(The build agent appends `T#.# BLOCKED: <reason>` lines here. Do not delete resolved issues; mark them resolved.)*

* None yet.

## Decisions made along the way

*(Record decisions not already locked in `PRD.md`/`TECH_STACK.md`.)*

* 2026-09-25 — Docs refined from `PRD.txt`/`TECH_STACK.txt`/`EXECUTION_PLAN.txt`/`STATUS.txt`; the four `.txt` files are superseded by the `.md` versions.
* 2026-09-25 — Scaffold committed with pinned versions (verified 2026-09-25 against npm registry). Phase 0 is now verification-only.
* 2026-09-25 — Pinned decisions table added to `CLAUDE.md` (map, contact destination, hero effect, palette, fonts, forms, studio credit, image fallback).

## Images / swappable content

* Default image set: 8 hand-written SVGs in `public/img/` (created in T1.3), palette-only, cohesive.
* Upgrade path: `tools/gen_image.sh` (image model **TBD** — see `tools/README.md`). Used only if `--selftest` exits 0 (T1.4).
* All imagery is placeholder/demo content; never present as real photos of a real business.

## Demo-data reminder

All business information on this site — address, phone, email, hours, menu, and social handles — is fictional demo content defined in `PRD.md` §§8 and 11. Do not replace it with a real client's information.
