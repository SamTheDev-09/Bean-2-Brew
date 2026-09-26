# Execution Plan — Phase 3

> Part of `EXECUTION_PLAN.md`. Read only this file for phase-3 tasks — do not open
> the other phase files or re-read the index unless a task explicitly points you
> elsewhere. Rules, loop algorithm, and stop conditions live in `CLAUDE.md`; read
> those once per session, not once per task.

**Previous:** [phase-2-static-skeleton.md](./phase-2-static-skeleton.md)  
**Next:** [phase-4-motion-interaction.md](./phase-4-motion-interaction.md)

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

