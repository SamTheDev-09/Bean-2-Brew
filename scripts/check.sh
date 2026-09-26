#!/usr/bin/env bash
# Bean 2 Brew — task checks. READ-ONLY for the build agent.
# Usage: bash scripts/check.sh <task-id>     e.g. bash scripts/check.sh T2.8
#        bash scripts/check.sh final         (everything that must hold at the end)
# Exit 0 = PASS. Non-zero = FAIL with a reason on the last line.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
T="${1:-}"
[ -n "$T" ] || { echo "usage: bash scripts/check.sh <task-id|final>"; exit 2; }

fail(){ echo "FAIL [$T]: $*"; exit 1; }
pass(){ echo "PASS [$T]"; exit 0; }
exists(){ local p; for p in "$@"; do [ -e "$p" ] || fail "missing file: $p"; done; }
has(){ [ -f "$1" ] || fail "missing file: $1"; grep -q -- "$2" "$1" || fail "\"$2\" not found in $1"; }
hasE(){ [ -f "$1" ] || fail "missing file: $1"; grep -qE -- "$2" "$1" || fail "pattern /$2/ not found in $1"; }
insrc(){ grep -rq -- "$1" src/ 2>/dev/null || fail "\"$1\" not found anywhere in src/"; }
lacks(){ local pat="$1"; shift; if grep -rnE -- "$pat" "$@" 2>/dev/null; then fail "forbidden pattern /$pat/ found (lines above)"; fi; }
lacksi(){ local pat="$1"; shift; if grep -rniE -- "$pat" "$@" 2>/dev/null; then fail "forbidden pattern /$pat/ found (lines above)"; fi; }
build(){
  [ -n "${B2B_BUILT:-}" ] && return 0
  npm run build >.check-build.log 2>&1 || { tail -40 .check-build.log; fail "npm run build failed (see log above)"; }
}
node_mod(){ # $1 = module path, $2 = JS body using `m`; throw to fail
  node --input-type=module -e "import {pathToFileURL} from 'node:url'; const m = await import(pathToFileURL('$1').href); $2" \
    || fail "module assertions failed for $1 (see error above)"
}
gzsum(){ local t=0 f; for f in "$@"; do [ -f "$f" ] || continue; t=$(( t + $(gzip -c "$f" | wc -c) )); done; echo "$t"; }
one_h1(){ local n; n=$(grep -ro "<h1" src/ 2>/dev/null | wc -l | tr -d ' '); [ "$n" -eq 1 ] || fail "expected exactly one <h1 in src/, found $n"; }
IDS="hero menu process story gallery reviews reserve visit newsletter"
ids(){ local id; for id in $IDS; do grep -rq "id=\"$id\"" src/ || fail "section id=\"$id\" not found in src/"; done; }
IMG_IDS="story-counter process-01-estate process-02-roast process-03-decoction process-04-pour gallery-01-verandah gallery-02-kaapi gallery-03-croissant gallery-04-tiramisu gallery-05-espresso-bar gallery-06-rose-milk gallery-07-kolam gallery-08-storefront"
img_ids(){ local id; for id in $IMG_IDS; do ls src/assets/img/"$id".* >/dev/null 2>&1 || fail "no image file for $id in src/assets/img/"; done; }
budget(){
  build
  local total entry
  total=$(gzsum dist/assets/*.js); entry=$(gzsum dist/assets/index-*.js)
  echo "JS gzip: entry=$entry total=$total (limits 280000 / 700000)"
  [ "$entry" -gt 0 ] || fail "no entry chunk dist/assets/index-*.js"
  [ "$entry" -lt 280000 ] || fail "entry chunk $entry >= 280000 bytes gz"
  [ "$total" -lt 700000 ] || fail "total JS $total >= 700000 bytes gz"
  if grep -q "LatheGeometry" dist/assets/index-*.js; then fail "three.js is in the entry chunk; PourScene must be lazy"; fi
}
qa(){ exists qa/REPORT.md; grep -q "^## $T" qa/REPORT.md || fail "qa/REPORT.md has no '## $T' section"; }
status_re(){ grep -qE -- "$1" STATUS.md || fail "STATUS.md does not match /$1/"; }
order(){
  local prev=0 c n
  for c in Header Hero MenuSection ProcessSection StorySection GallerySection ReviewsSection ReserveSection VisitSection Footer; do
    n=$(grep -nE "<$c( |/|>)" src/App.jsx | head -1 | cut -d: -f1)
    [ -n "$n" ] || fail "<$c> not rendered in src/App.jsx"
    [ "$n" -gt "$prev" ] || fail "<$c> is out of order in src/App.jsx (PRD §4)"
    prev=$n
  done
}
NET='fetch\(|XMLHttpRequest|axios|sendBeacon|WebSocket|EventSource'

case "$T" in
# ---------------- Phase 0 ----------------
T0.1)
  exists package.json index.html vite.config.js src/main.jsx src/App.jsx src/index.css .gitignore qa/REPORT.md
  node -e "const p=require('./package.json'); if(p.type!=='module'||!p.scripts||p.scripts.build!=='vite build') process.exit(1)" || fail "package.json needs type=module and scripts.build='vite build'"
  has index.html 'id="root"'; has vite.config.js 'tailwindcss'; has src/index.css '@import "tailwindcss"'; has .gitignore 'node_modules'
  pass;;
T0.2)
  node -e "
    const p=require('./package.json'); const all={...p.dependencies,...p.devDependencies};
    const pins={react:'19.3.0','react-dom':'19.3.0',three:'0.186.1','@react-three/fiber':'9.8.1','@react-three/drei':'10.7.9',gsap:'3.15.0','framer-motion':'13.4.4','yet-another-react-lightbox':'3.32.2',vite:'8.3.1','@vitejs/plugin-react':'6.1.1',tailwindcss:'4.3.3','@tailwindcss/vite':'4.3.3'};
    for (const [k,v] of Object.entries(pins)) if (all[k]!==v) { console.error('pin mismatch: '+k+'='+all[k]+' expected '+v); process.exit(1); }
    for (const [k,v] of Object.entries(all)) if (!/^\d/.test(v)) { console.error('not exact: '+k+'='+v); process.exit(1); }
    if (!all.lenis) { console.error('lenis missing'); process.exit(1); }
    const display = all['@fontsource/rozha-one']||all['@fontsource/fraunces']; const body = all['@fontsource/hind-madurai']||all['@fontsource/inter'];
    if (!display||!body) { console.error('font packages missing'); process.exit(1); }
    if (all.motion) { console.error('the motion package must not be installed'); process.exit(1); }
  " || fail "dependency pins (see message above)"
  exists package-lock.json
  status_re '\*\*Resolved versions:\*\* [^(]'
  build; pass;;
T0.3) status_re '\*\*Tooling:\*\* playwright=(yes|no)'; pass;;
# ---------------- Phase 1 ----------------
T1.1)
  for s in '#1F130D' '#3A2418' '#F3EDE1' '#E8DCC4' '#C9A24A' '#B3372F' '--font-display' '--font-sans' '--ease-pour' 'focus-visible' 'prefers-reduced-motion' '@theme'; do has src/index.css "$s"; done
  has src/main.jsx '@fontsource'; build; pass;;
T1.2)
  has src/data/site.js 'openstreetmap.org/export/embed.html'
  node_mod src/data/site.js "if(m.SITE.name!=='Bean 2 Brew') throw new Error('name'); if(!m.STUDIO) throw new Error('STUDIO'); if(!m.SITE.addressOneLine.includes('Besant Nagar')) throw new Error('address'); if(m.SITE.phoneHref!=='tel:+914400000000') throw new Error('phoneHref'); if(!m.SITE.directionsUrl.startsWith('https://www.google.com/maps/search/')) throw new Error('directions'); if(!m.SITE.social||!m.SITE.social.instagram) throw new Error('social');"
  pass;;
T1.3)
  node_mod src/data/menu.js "const t=m.MENU_TABS, it=m.menuItems; if(!Array.isArray(t)||t.length!==5||t[0]!=='All') throw new Error('MENU_TABS'); if(it.length!==13) throw new Error('need 13 items, got '+it.length); for(const i of it){ if(!i.id||!i.name||!i.description||typeof i.price!=='number'||!t.includes(i.tab)||i.tab==='All') throw new Error('bad item '+JSON.stringify(i)); } if(!it.some(i=>i.name==='Madras filter kaapi'&&i.price===90)) throw new Error('filter kaapi'); if(!it.some(i=>i.tag==='Seasonal')) throw new Error('seasonal tag');"
  pass;;
T1.4)
  node_mod src/data/process.js "if(m.processSteps.length!==4) throw new Error('4 steps'); m.processSteps.forEach((s,i)=>{ if(s.n!==i+1||!s.title||!s.body||!s.imageId) throw new Error('step '+i); });"
  node_mod src/data/reviews.js "if(m.reviews.length!==3) throw new Error('3 reviews'); for(const r of m.reviews) if(!r.quote||!r.name||!r.area) throw new Error('review');"
  pass;;
T1.5) img_ids; pass;;
T1.6)
  has src/data/assets.js 'import.meta.glob'; has src/data/assets.js 'getImage'
  for id in $IMG_IDS; do has src/data/assets.js "$id"; done
  build; pass;;
T1.7)
  node_mod src/lib/env.js "for(const f of ['prefersReducedMotion','usePrefersReducedMotion','hasWebGL','isLowPowerDevice']) if(typeof m[f]!=='function') throw new Error('missing '+f); if(m.hasWebGL()!==false||m.prefersReducedMotion()!==false||m.isLowPowerDevice()!==false) throw new Error('helpers must return false outside a browser');"
  pass;;
T1.8) ids; build; pass;;
# ---------------- Phase 2 ----------------
T2.1)
  F=src/components/Header.jsx
  has $F 'Open menu'; has $F 'Close menu'; has $F 'aria-label="Main"'; has $F 'Skip to content'; has $F '#reserve'; has $F 'Reserve a table'; has $F 'aria-expanded'
  build; pass;;
T2.2)
  F=src/components/Hero.jsx
  has $F 'Filter kaapi, pulled a metre high.'; has $F 'id="hero-stage"'; has $F 'காபி'; has $F '#reserve'; has $F '#menu'; has $F 'See the menu'
  one_h1; build; pass;;
T2.3)
  F=src/components/MenuSection.jsx
  has $F 'The board'; has $F 'role="tablist"'; has $F 'aria-selected'; has $F 'menuItems'; has $F 'MENU_TABS'; has $F 'Prices include GST'; has $F '₹'
  build; pass;;
T2.4) F=src/components/ProcessSection.jsx; has $F 'From estate to dabara'; has $F 'processSteps'; has $F 'data-process-track'; has $F '<ol'; build; pass;;
T2.5) F=src/components/StorySection.jsx; has $F 'Why we pour it long'; has $F 'Baba Budangiri'; hasE $F 'getImage|IMAGES'; build; pass;;
T2.6) F=src/components/GallerySection.jsx; has $F 'A look inside'; has $F 'Open image'; hasE $F 'getImage|IMAGES'; build; pass;;
T2.7) F=src/components/ReviewsSection.jsx; has $F 'What regulars say'; has $F 'reviews'; has $F 'blockquote'; build; pass;;
T2.8)
  read -r -d '' JS <<'JSEOF'
const {getSlots,isValidMobile,isValidEmail,validateDetails,validateWhen,makeRef,buildIcs,formatTime,formatDate,dateBounds,toISODate}=m;
for (const f of [getSlots,isValidMobile,isValidEmail,validateDetails,validateWhen,makeRef,buildIcs,formatTime,formatDate,dateBounds,toISODate]) if (typeof f!=='function') throw new Error('missing export');
const s=getSlots('2099-01-01', new Date(2098,11,31,10,0));
if(s.length!==30||s[0]!=='07:00'||s[29]!=='21:30') throw new Error('slots '+s.length+' '+s[0]+' '+s[29]);
const today=getSlots(toISODate(new Date(2030,0,5,12,10)), new Date(2030,0,5,12,10));
if(today[0]!=='13:00') throw new Error('today cutoff: first slot should be 13:00, got '+today[0]);
for (const [v,e] of [['9840012345',true],['98400 12345',true],['+91 98400 12345',true],['919840012345',true],['09840012345',true],['98400-12345',true],['5840012345',false],['12345',false],['98400123456',false]]) if (isValidMobile(v)!==e) throw new Error('isValidMobile('+v+') should be '+e);
if(!isValidEmail('a@b.co')||isValidEmail('x')) throw new Error('isValidEmail');
const bad=validateDetails({name:' ',mobile:'1',email:'x'}); if(!bad.name||!bad.mobile||!bad.email) throw new Error('validateDetails should flag all three');
if(bad.mobile!=='Enter a 10-digit mobile number starting with 6, 7, 8 or 9.') throw new Error('mobile message must match CONTENT §12');
const good=validateDetails({name:'Asha',mobile:'9840012345',email:''}); if(Object.keys(good).length) throw new Error('validateDetails good case returned '+JSON.stringify(good));
const w=validateWhen({date:'',time:'',party:0}, new Date()); if(!w.date||!w.time||!w.party) throw new Error('validateWhen');
const w2=validateWhen({date:toISODate(new Date()),time:'21:30',party:9}, new Date()); if(!w2.party) throw new Error('party 9 must fail');
if(!/^B2B-[A-HJ-NP-Z2-9]{4}$/.test(makeRef())) throw new Error('makeRef format');
const ics=buildIcs({date:'2099-01-01',time:'07:00',party:2,name:'Asha',ref:'B2B-AB12'});
for (const k of ['BEGIN:VCALENDAR','BEGIN:VEVENT','DTSTART:20990101T013000Z','DTEND:20990101T030000Z','UID:B2B-AB12@bean2brew.demo','END:VEVENT','END:VCALENDAR']) if(!ics.includes(k)) throw new Error('ics missing '+k);
if(!ics.includes('\r\n')) throw new Error('ics must use CRLF');
if(formatTime('07:00')!=='7:00 am'||formatTime('21:30')!=='9:30 pm'||formatTime('12:00')!=='12:00 pm') throw new Error('formatTime');
const b=dateBounds(new Date(2026,8,26,10,0)); if(b.min!=='2026-09-26'||b.max!=='2026-10-26') throw new Error('dateBounds '+JSON.stringify(b));
if(typeof formatDate('2026-09-27')!=='string'||!formatDate('2026-09-27').includes('27')) throw new Error('formatDate');
JSEOF
  node_mod src/lib/reservation.js "$JS"
  lacks "$NET" src/lib/reservation.js
  pass;;
T2.9)
  F=src/components/reserve/ReserveSection.jsx
  for s in 'id="reserve"' 'Reserve a table' 'Confirm reservation' 'Continue' 'Add to calendar' 'Make another reservation' 'aria-live' 'aria-pressed' 'aria-describedby' 'buildIcs' 'makeRef' 'getSlots' 'createObjectURL' 'revokeObjectURL' 'This is a demo booking'; do has $F "$s"; done
  lacks "$NET" $F; build; pass;;
T2.10)
  V=src/components/VisitSection.jsx; C=src/components/ContactForm.jsx
  has $V 'Find us on 3rd Avenue'; has $V 'mapEmbedUrl'; has $V 'directionsUrl'; has $V 'rel="noopener"'; has $V 'Map showing Bean 2 Brew'; has $V 'Get directions'
  has $C 'Write to us'; has $C 'Send message'; has $C 'preventDefault'; has $C 'aria-live'
  lacks "$NET" $C; build; pass;;
T2.11)
  F=src/components/Footer.jsx; N=src/components/Newsletter.jsx
  has $F 'fictional café'; has $F 'STUDIO'; has $F 'mailto:'; has $F '© 2026 Bean 2 Brew.'
  has $N 'id="newsletter"'; has $N 'Roast notes'; has $N 'Subscribe'; has $N 'preventDefault'; has $N 'aria-live'
  lacks "$NET" $N; build; pass;;
T2.12) F=src/components/MobileReserveBar.jsx; has $F '#reserve'; has $F 'md:hidden'; has $F 'IntersectionObserver'; build; pass;;
T2.13) order; ids; one_h1; has src/App.jsx 'id="main"'; build; pass;;
T2.14) qa; build; pass;;
# ---------------- Phase 3 ----------------
T3.1)
  F=src/components/hero/PourScene.jsx
  grep -qi 'lathegeometry' $F || fail "no latheGeometry in $F"
  has $F 'Lightformer'; has $F 'Environment'; has $F 'export default'; has $F 'dpr'; has $F 'progressRef'
  lacks 'https?://|\.glb|\.gltf|\.hdr|useGLTF|preset=' $F
  build; pass;;
T3.2)
  F=src/components/hero/PourScene.jsx
  grep -qi 'shadermaterial' $F || fail "no shaderMaterial (stream) in $F"
  has $F 'CanvasTexture'; has $F '<points'; has $F 'uTime'
  lacks 'https?://|\.glb|\.gltf|\.hdr|useGLTF|preset=|TextureLoader' $F
  build; pass;;
T3.3) F=src/components/hero/PourScene.jsx; has $F 'pointer'; has $F 'frameloop'; has $F 'IntersectionObserver'; build; pass;;
T3.4)
  exists src/components/hero/HeroFallback.jsx
  F=src/components/Hero.jsx
  has $F 'lazy('; has $F 'Suspense'; has $F 'hasWebGL'; has $F 'HeroFallback'; hasE $F 'usePrefersReducedMotion|prefersReducedMotion'
  build
  if grep -q "LatheGeometry" dist/assets/index-*.js; then fail "three.js is in the entry chunk; PourScene must be lazy"; fi
  pass;;
T3.5) status_re '\*\*Hero 3D:\*\* Tier [ABC]'; qa; build; pass;;
T3.6) qa; build; pass;;
# ---------------- Phase 4 ----------------
T4.1)
  F=src/lib/motion.js
  grep -qi 'lenis' $F || fail "Lenis not used in $F"
  has $F 'ScrollTrigger'; has $F 'ticker'; has $F 'lagSmoothing'; has $F 'initSmoothScroll'; has $F 'scrollTo'
  has src/App.jsx 'initSmoothScroll'; build; pass;;
T4.2) exists src/components/Preloader.jsx; has src/components/Preloader.jsx 'sessionStorage'; has src/components/Preloader.jsx 'b2b-seen'; insrc 'SplitText'; insrc '<Preloader'; build; pass;;
T4.3) F=src/components/Hero.jsx; has $F 'scrub'; has $F 'pin'; has $F 'matchMedia'; has $F 'progressRef'; build; pass;;
T4.4) F=src/components/ProcessSection.jsx; has $F 'matchMedia'; has $F 'pin'; has $F 'scrub'; has $F 'invalidateOnRefresh'; build; pass;;
T4.5) F=src/components/Header.jsx; has $F 'IntersectionObserver'; has $F 'aria-current'; has $F 'AnimatePresence'; build; pass;;
T4.6) F=src/components/MenuSection.jsx; has $F 'layoutId'; has $F 'AnimatePresence'; has $F 'popLayout'; build; pass;;
T4.7) F=src/components/reserve/ReserveSection.jsx; has $F 'AnimatePresence'; has $F 'custom'; lacks "$NET" $F; build; pass;;
T4.8) insrc 'yet-another-react-lightbox'; insrc 'yet-another-react-lightbox/styles.css'; build; pass;;
T4.9) has src/App.jsx 'MotionConfig'; has src/App.jsx 'reducedMotion="user"'; has src/index.css 'prefers-reduced-motion'; has src/lib/motion.js 'prefersReducedMotion'; build; pass;;
T4.10) budget; status_re '\*\*Bundle:\*\* [^(]'; qa; pass;;
# ---------------- Phase 5 ----------------
T5.1)
  one_h1; has src/index.css 'focus-visible'; has src/components/Header.jsx 'aria-label="Main"'
  insrc 'aria-live'; insrc 'aria-describedby'; insrc 'aria-invalid'; insrc 'aria-labelledby'; insrc 'htmlFor'; has src/App.jsx 'id="main"'
  build; pass;;
T5.2) qa; build; pass;;
T5.3)
  F=index.html
  for s in '<title>Bean 2 Brew | Filter kaapi' 'name="description"' 'og:title' 'og:description' 'og:image' 'og:locale' 'twitter:card' 'application/ld+json' 'CafeOrCoffeeShop' 'favicon.svg' 'theme-color'; do has $F "$s"; done
  exists public/favicon.svg
  [ -f public/og-cover.jpg ] || grep -q "og-cover.jpg not supplied" STATUS.md || fail "public/og-cover.jpg missing and not logged as an Open issue in STATUS.md"
  build; pass;;
T5.4) has index.html 'ANALYTICS SLOT'; lacksi '<script[^>]+(googletagmanager|plausible)' index.html; pass;;
T5.5) insrc 'loading="lazy"'; insrc 'decoding="async"'; build; pass;;
T5.6) budget; status_re '\*\*Bundle:\*\* [^(]'; pass;;
T5.7) qa; build; pass;;
# ---------------- Phase 6 ----------------
T6.1)
  lacksi 'lorem|todo|tbd|fixme|placeholder' src/ index.html
  lacks 'uppercase' src/
  lacks '→' src/
  lacks ' · ' src/
  build; pass;;
T6.2)
  lacks "$NET" src/
  lacks 'https?://' src/components/reserve/ReserveSection.jsx src/components/ContactForm.jsx src/components/Newsletter.jsx
  lacks 'import\.meta\.env\.VITE_' src/
  insrc 'revokeObjectURL'
  build; pass;;
T6.3|final)
  build; export B2B_BUILT=1
  for t in T0.2 T1.2 T1.3 T1.4 T1.5 T1.6 T1.7 T2.8 T2.9 T2.10 T2.11 T2.13 T3.4 T4.9 T5.1 T5.3 T5.4 T5.5 T6.1 T6.2; do
    out=$(bash "$0" "$t" 2>&1) || { echo "$out"; fail "sub-check $t failed"; }
  done
  ids; one_h1; img_ids; budget
  pass;;
T6.4) qa; pass;;
T6.5) status_re '\*\*Deploy:\*\* [^(]'; pass;;
T6.6) grep -q '^## Final report' STATUS.md || fail "STATUS.md has no '## Final report'"; build; pass;;
*) echo "unknown task id: $T"; exit 2;;
esac
