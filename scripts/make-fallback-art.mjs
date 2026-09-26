// Bean 2 Brew — generates on-brand SVG fallback art for every image id that has
// no real photo yet. READ-ONLY for the build agent. Run: node scripts/make-fallback-art.mjs
// Never overwrites .webp/.jpg/.jpeg/.png; only (re)writes .svg.
import { mkdirSync, existsSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const DIR = 'src/assets/img';
const C = { decoction: '#1F130D', roast: '#3A2418', jasmine: '#F3EDE1', brass: '#C9A24A' };

// id, width, height, motif, caption
const ART = [
  ['story-counter', 1200, 1500, 'tumbler', 'The counter at seven'],
  ['process-01-estate', 1200, 1500, 'leaf', 'The estate'],
  ['process-02-roast', 1200, 1500, 'bean', 'The roast'],
  ['process-03-decoction', 1200, 1500, 'drop', 'The decoction'],
  ['process-04-pour', 1200, 1500, 'pour', 'The pour'],
  ['gallery-01-verandah', 1200, 1500, 'arch', 'Verandah seating'],
  ['gallery-02-kaapi', 1200, 1200, 'pour', 'Filter kaapi'],
  ['gallery-03-croissant', 1200, 1500, 'crescent', 'Almond croissant'],
  ['gallery-04-tiramisu', 1200, 1200, 'glass', 'Kaapi tiramisu'],
  ['gallery-05-espresso-bar', 1500, 1000, 'tumbler', 'The espresso bar'],
  ['gallery-06-rose-milk', 1200, 1500, 'glass', 'Rose milk'],
  ['gallery-07-kolam', 1500, 1000, 'kolam', 'Kolam at the door'],
  ['gallery-08-storefront', 1500, 1000, 'arch', 'Evening on 3rd Avenue'],
];

// Motifs drawn in a 200x200 box centred on (0,0); stroke only.
const MOTIF = {
  tumbler: 'M-45 -80 L45 -80 L35 80 L-35 80 Z M-45 -80 Q0 -70 45 -80',
  pour: 'M-30 -95 L30 -95 L24 -35 L-24 -35 Z M4 -35 L4 45 M-70 45 Q0 95 70 45 Z',
  leaf: 'M0 90 L0 -20 M0 -20 C-70 -40 -60 -110 0 -95 C60 -110 70 -40 0 -20',
  bean: 'M0 -85 C60 -85 60 85 0 85 C-60 85 -60 -85 0 -85 Z M0 -85 C-25 -30 25 30 0 85',
  drop: 'M0 -90 C35 -30 60 5 60 35 A60 60 0 0 1 -60 35 C-60 5 -35 -30 0 -90 Z',
  arch: 'M-70 90 L-70 -20 A70 70 0 0 1 70 -20 L70 90 Z M-70 30 L70 30 M0 -90 L0 90',
  crescent: 'M-85 20 C-60 -70 60 -70 85 20 C45 -10 -45 -10 -85 20 Z M-40 -30 L-25 5 M0 -42 L0 -5 M40 -30 L25 5',
  glass: 'M-40 -90 L40 -90 L28 90 L-28 90 Z M-38 -40 L38 -40',
  kolam: 'M0 -80 L80 0 L0 80 L-80 0 Z M0 -40 L40 0 L0 40 L-40 0 Z M-80 -80 m0 0',
};

const hasReal = (id) => ['webp', 'jpg', 'jpeg', 'png'].some((e) => existsSync(join(DIR, `${id}.${e}`)));

function svg([id, w, h, motif, caption]) {
  const s = Math.min(w, h) / 420; // motif scale
  const cx = w / 2, cy = h * 0.44;
  const dots = [-1, 0, 1].map((i) => `<circle cx="${cx + i * 26 * s}" cy="${cy + 130 * s}" r="${3 * s}" fill="${C.brass}"/>`).join('');
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${w} ${h}" width="${w}" height="${h}" role="img" aria-label="${caption}">
<defs><radialGradient id="g" cx="50%" cy="40%" r="75%"><stop offset="0" stop-color="${C.roast}"/><stop offset="1" stop-color="${C.decoction}"/></radialGradient></defs>
<rect width="${w}" height="${h}" fill="url(#g)"/>
<g transform="translate(${cx} ${cy}) scale(${s})" fill="none" stroke="${C.brass}" stroke-width="3" stroke-linejoin="round" stroke-linecap="round"><path d="${MOTIF[motif]}"/></g>
${dots}
<text x="${cx}" y="${cy + 190 * s}" fill="${C.jasmine}" font-family="Georgia, serif" font-size="${Math.round(30 * s)}" text-anchor="middle">${caption}</text>
<text x="${w * 0.05}" y="${h * 0.95}" fill="${C.jasmine}" fill-opacity="0.55" font-family="Georgia, serif" font-size="${Math.round(18 * s)}">Bean 2 Brew</text>
</svg>
`;
}

mkdirSync(DIR, { recursive: true });
let written = 0, skipped = 0;
for (const a of ART) {
  if (hasReal(a[0])) { skipped++; continue; }
  writeFileSync(join(DIR, `${a[0]}.svg`), svg(a));
  written++;
}
console.log(`fallback art: ${written} svg written, ${skipped} skipped (real photo present)`);
