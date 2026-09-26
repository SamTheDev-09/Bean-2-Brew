# Phase 3 — Hero 3D: the metre pour

**Previous:** [phase-2-sections.md](./phase-2-sections.md) · **Next:** [phase-4-motion.md](./phase-4-motion.md)

**Recommended model:** Opus. Use Context7 for every R3F/drei/three API you touch.
**De-risk:** PRD §6 tiers. The site is already complete from Phase 2; nothing here may break it.

### T3.1 — PourScene: vessels and lighting
- **Files:** `src/components/hero/PourScene.jsx`
- **Read:** DESIGN §6 (scene, lighting, brass, lathe profiles, composition)
- **Tools:** Context7 (`@react-three/fiber` Canvas, drei `Environment` + `Lightformer`, three `LatheGeometry`)
- **Steps:**
  1. Default-export `PourScene({ progressRef, lowPower })`.
     - `progressRef` is a React ref whose `.current` is a number from 0 to 1. The scene reads it inside `useFrame`, so there is no React re-render per frame.
  2. Canvas setup:
     - camera and gl per DESIGN §6
     - `dpr={lowPower ? [1, 1.25] : [1, 1.75]}`
     - transparent background
  3. `<Environment resolution={256}>` with the three Lightformers from DESIGN §6, plus the ambient light. **No `preset`.**
  4. Build the tumbler and dabara with `<latheGeometry args={[points, 64]}>`.
     - Points are the DESIGN §6 profile arrays mapped to `new THREE.Vector2(r, y)`.
     - Use `useMemo` for the geometry.
     - Brass `meshStandardMaterial`.
  5. Position per composition. Tumbler `y` = `lerp(-0.2, 1.35, progressRef.current)`, updated in `useFrame`.
- **Check:** `bash scripts/check.sh T3.1`
- **Done:** two lit brass vessels render in the stage (verified in T3.5).

### T3.2 — Stream, froth, steam, progress
- **Files:** `src/components/hero/PourScene.jsx`
- **Read:** DESIGN §6 (stream, froth, steam, idle)
- **Tools:** Context7 (R3F `shaderMaterial` / `points`, `THREE.CanvasTexture`)
- **Steps:**
  1. **Stream:**
     - A unit cylinder (radiusTop 0.028, radiusBottom 0.014, 12 radial segments, 32 height segments).
     - Each frame, position it between the tumbler lip (compute the world position of a lip point on the tilted tumbler) and the dabara surface (`y ≈ -0.95`). Scale y to the distance and orient with `quaternion.setFromUnitVectors`.
     - `shaderMaterial` with `uTime` and scrolling 2D value noise along the length, mixing `#3B1F12` → `#8A5A32`, opacity 0.95, transparent.
  2. **Froth:**
     - A `points` disc (380, or 180 if `lowPower`) at the dabara surface, colour `#D9C3A0`.
     - Point size and y jitter scale with `progressRef.current`.
  3. **Steam:**
     - A `points` field (260 / 120) using a soft round sprite generated with a 64×64 canvas radial gradient → `THREE.CanvasTexture`.
     - Additive blending, jasmine colour, opacity 0.10.
     - Rises with a sinusoidal sway and wraps to the bottom.
  4. **Idle:** the tumbler bobs ±0.02 and the stream shader always animates.
  5. No external files of any kind.
- **Check:** `bash scripts/check.sh T3.2`
- **Done:** the pour reads clearly at progress 0 and 1.

### T3.3 — Pointer parallax and offscreen pause
- **Files:** `src/components/hero/PourScene.jsx`
- **Read:** DESIGN §6 (pointer, performance)
- **Tools:** Context7
- **Steps:**
  1. **Pointer (desktop only, skipped on coarse pointers):** group rotation eases toward `pointer.x * 0.25` / `pointer.y * 0.08` with damping 0.08.
  2. **Offscreen pause:**
     - IntersectionObserver on the canvas's parent.
     - Keep `frameloop` in state: `"always"` in view, `"never"` out of view.
     - Pass it to `<Canvas frameloop={...}>`.
- **Check:** `bash scripts/check.sh T3.3`
- **Done:** parallax on desktop; zero GPU work when the hero is off-screen.

### T3.4 — Fallback and gated lazy mount
- **Files:** `src/components/hero/HeroFallback.jsx`, `src/components/Hero.jsx`
- **Read:** PRD §6 (tiers), DESIGN §6 (HeroFallback)
- **Tools:** frontend-design
- **Steps:**
  1. **`HeroFallback({ animate })`:**
     - Inline SVG line art of a tumbler above a dabara, brass 2px stroke, sized to fill the stage.
     - Two CSS steam wisps whose keyframes are defined in the component's CSS or `index.css`. They are rendered only when `animate` is true.
  2. **In `Hero.jsx`:**
     - `const PourScene = lazy(() => import('./hero/PourScene.jsx'))`
     - Keep a `progressRef = useRef(1)`. It stays at 1 until T4.3 wires scroll.
  3. **Gate:**
     - `usePrefersReducedMotion()` or `!hasWebGL()` → `<HeroFallback animate={false} />` or `<HeroFallback animate />` respectively.
     - Otherwise → `<Suspense fallback={<HeroFallback animate />}><PourScene progressRef={progressRef} lowPower={isLowPowerDevice()} /></Suspense>`.
  4. Wrap the scene in a small error boundary class that renders `HeroFallback` if the canvas throws.
- **Check:** `bash scripts/check.sh T3.4`
- **Done:** every environment gets a hero; the 3D code is a separate chunk.

### T3.5 — Performance and tier decision
- **Files:** `src/components/hero/PourScene.jsx`, `STATUS.md`, `qa/REPORT.md`
- **Read:** PRD §6 (tiers), TECH_STACK §6
- **Tools:** Playwright MCP; Chrome DevTools MCP if available (performance trace with 4× CPU throttle)
- **Steps:**
  1. Serve the build and screenshot the hero at 1440 and 375.
     - Check visually: brass reads as metal (not black), the stream connects the tumbler lip to the dabara, there is no flicker or banding, and text contrast is intact.
  2. Measure fps. Use the DevTools trace, or in the page run a 3-second `requestAnimationFrame` counter via Playwright evaluate.
  3. **If it looks wrong or runs under 30fps:**
     - **Attempt 1:** halve the particles, disable froth jitter, cap dpr at 1.25.
     - **Attempt 2:** ship **Tier B**. Remove the stream and froth and keep the vessels and steam; `progress` still raises the tumbler.
     - **If Tier B is still broken:** Tier C. `Hero.jsx` renders only `HeroFallback`.
  4. Write `**Hero 3D:** Tier A|B|C — <particle counts>, <fps>, <reason if not A>` in STATUS, plus `## T3.5` in the QA report.
- **Check:** `bash scripts/check.sh T3.5`
- **Done:** a stable hero at a recorded tier.

### T3.6 — Phase 3 checkpoint
- **Files:** `STATUS.md`, `qa/REPORT.md`
- **Read:** —
- **Tools:** `/code-review` (diff since T2.14)
- **Steps:** review, fix real issues, set the Hero row, and write `## T3.6`.
- **Check:** `bash scripts/check.sh T3.6`
- **Done:** hero is stable and reviewed.
