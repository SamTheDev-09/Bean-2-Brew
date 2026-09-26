# Phase 0 — Scaffold

**Next:** [phase-1-foundations.md](./phase-1-foundations.md)

### T0.1 — Hand-written scaffold
- **Files:** `package.json`, `index.html`, `vite.config.js`, `src/main.jsx`, `src/App.jsx`, `src/index.css`, `.gitignore`, `qa/REPORT.md`
- **Read:** TECH_STACK §1–2
- **Tools:** none
- **Steps:**
  1. Confirm this is a fresh repo. If `package.json` already exists, BLOCKED: "not a fresh repo". Never overwrite an old project.
  2. `package.json`:
     ```json
     { "name": "bean2brew", "private": true, "version": "1.0.0", "type": "module",
       "scripts": { "dev": "vite", "build": "vite build", "preview": "vite preview" } }
     ```
  3. `vite.config.js`:
     ```js
     import { defineConfig } from 'vite'
     import react from '@vitejs/plugin-react'
     import tailwindcss from '@tailwindcss/vite'
     export default defineConfig({ plugins: [react(), tailwindcss()] })
     ```
  4. `index.html`:
     - `lang="en"`, UTF-8 meta, viewport meta, `<title>Bean 2 Brew</title>`
     - `<div id="root"></div>`
     - `<script type="module" src="/src/main.jsx"></script>`
  5. `src/main.jsx`:
     - `createRoot(document.getElementById('root')).render(<StrictMode><App/></StrictMode>)`
     - `import './index.css'`
  6. `src/App.jsx`: returns `<main>Bean 2 Brew</main>`.
  7. `src/index.css`: `@import "tailwindcss";`
  8. `.gitignore`: `node_modules/`, `dist/`, `.env`, `.check-build.log`, `qa/*.png`
  9. `qa/REPORT.md`: `# QA report`
- **Check:** `bash scripts/check.sh T0.1`
- **Done:** scaffold files exist.

### T0.2 — Install pinned dependencies
- **Files:** `package.json`, `package-lock.json`, `STATUS.md`
- **Read:** TECH_STACK §2–3
- **Tools:** none
- **Steps:**
  1. Install runtime dependencies:
     ```bash
     npm install --save-exact react@19.3.0 react-dom@19.3.0 three@0.186.1 @react-three/fiber@9.8.1 @react-three/drei@10.7.9 gsap@3.15.0 framer-motion@13.4.4 yet-another-react-lightbox@3.32.2 lenis @fontsource/rozha-one @fontsource/hind-madurai
     ```
  2. Install dev dependencies:
     ```bash
     npm install --save-exact -D vite@8.3.1 @vitejs/plugin-react@6.1.1 tailwindcss@4.3.3 @tailwindcss/vite@4.3.3
     ```
  3. **If a pinned version fails with ETARGET:** BLOCKED with the exact error. Do not substitute versions.
  4. **If only a font package fails:** install the TECH_STACK §3 fallback (`@fontsource/fraunces@5.3.0` / `@fontsource/inter@5.3.0`, `--save-exact`) and log `Fonts: fallback Fraunces/Inter` under Decisions.
  5. Fill `STATUS.md → Resolved versions:` with the exact resolved lenis and font versions.
  6. `npm run build`
- **Check:** `bash scripts/check.sh T0.2`
- **Done:** every dependency is an exact version and the build passes.

### T0.3 — Tooling inventory
- **Files:** `STATUS.md`
- **Read:** TECH_STACK §5
- **Tools:** inspect your own tool list
- **Steps:**
  1. Check which of these are available to you:
     - Playwright MCP (tools named `mcp__playwright__*`)
     - Context7 (tools containing `context7`)
     - `frontend-design` skill
     - Chrome DevTools MCP
  2. Replace the `**Tooling:**` line with `**Tooling:** playwright=yes|no, context7=yes|no, frontend-design=yes|no, devtools=yes|no`.
- **Check:** `bash scripts/check.sh T0.3`
- **Done:** STATUS records the tooling.
