// Verifikasi import semua paket motion-studio/js
// Jalankan: node verify.mjs
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);

const pkgs = [
  { name: 'animejs', test: async () => { const m = await import('animejs'); return typeof m.animate === 'function' ? 'animate() ok' : 'loaded, animate missing'; } },
  { name: 'react-spring', test: async () => { const m = await import('react-spring'); return typeof m.animated !== 'undefined' ? 'animated ok' : 'loaded'; } },
  { name: 'pixi.js', test: async () => { const m = await import('pixi.js'); return 'PIXI v' + (m.VERSION || m.Application ? (m.VERSION || '?') : '?'); } },
  { name: 'p5', test: async () => { const m = await import('p5'); return typeof m.default === 'function' ? 'p5 constructor ok' : 'loaded'; } },
  { name: 'matter-js', test: async () => { const m = await import('matter-js'); const M = m.default || m; return typeof M.Engine?.create === 'function' ? 'Engine.create ok' : 'loaded'; } },
  { name: 'd3', test: async () => { const m = await import('d3'); return typeof m.select === 'function' ? 'select() ok' : 'loaded'; } },
  { name: 'three', test: async () => { const m = await import('three'); return 'REVISION ' + (m.REVISION || '?'); } },
  { name: 'lottie-web', test: async () => { const m = await import('lottie-web'); const l = m.default || m; return typeof l.loadAnimation === 'function' ? 'loadAnimation ok' : 'loaded'; } },
  { name: 'tone', test: async () => { const m = await import('tone'); return 'Tone v' + (m.version || m.default?.version || '?'); } },
  { name: '@motion-canvas/core', test: async () => { const m = await import('@motion-canvas/core'); return typeof m.makeScene2D === 'function' ? 'makeScene2D ok' : 'loaded'; } },
  { name: '@motion-canvas/ffmpeg', test: async () => { const m = await import('@motion-canvas/ffmpeg'); return typeof m.makeVideo === 'function' ? 'makeVideo ok' : 'loaded'; } },
  { name: 'remotion', test: async () => { const m = await import('remotion'); return typeof m.interpolate === 'function' ? 'interpolate() ok' : 'loaded'; } },
  { name: '@remotion/cli', test: async () => { const m = await import('@remotion/cli'); return 'loaded (' + Object.keys(m).slice(0, 3).join(',') + ')'; } },
  { name: '@remotion/media', test: async () => { const m = await import('@remotion/media'); return typeof m.Video !== 'undefined' || typeof m.Img !== 'undefined' ? 'Video/Img ok' : 'loaded'; } },
  { name: '@remotion/captions', test: async () => { const m = await import('@remotion/captions'); return typeof m.createTikTokStyleCaptions !== 'undefined' || Object.keys(m).length > 0 ? 'loaded (' + Object.keys(m).slice(0, 3).join(',') + ')' : 'loaded'; } },
];

let pass = 0, fail = 0;
for (const p of pkgs) {
  let ver = '?';
  try { ver = require(p.name + '/package.json').version; } catch { /* scoped subpath may fail */ try { ver = require(p.name + '/package.json').version; } catch { ver = '?'; } }
  try {
    const note = await p.test();
    console.log(`PASS  ${p.name}@${ver} — ${note}`);
    pass++;
  } catch (e) {
    console.log(`FAIL  ${p.name}@${ver} — ${e.message.split('\n')[0]}`);
    fail++;
  }
}
console.log(`\n${pass} PASS, ${fail} FAIL dari ${pkgs.length} paket`);
