// Verifikasi import 6 pustaka JS baru (27 Nov 2026, dari post @yepzXBT).
// Hanya cek import + API permukaan; konstruksi yang butuh DOM/WebGL tidak diuji di Node.
const results = [];
async function check(name, fn) {
  try {
    const out = await fn();
    console.log(`OK  ${name}: ${out}`);
    results.push(true);
  } catch (e) {
    console.log(`FAIL ${name}: ${e.message.split('\n')[0]}`);
    results.push(false);
  }
}

await check('motion', async () => {
  const { animate } = await import('motion');
  if (typeof animate !== 'function') throw new Error('animate bukan function');
  return 'animate() function';
});

await check('gsap', async () => {
  const { gsap } = await import('gsap');
  if (typeof gsap.to !== 'function') throw new Error('gsap.to bukan function');
  return `gsap v${gsap.version}, gsap.to() function`;
});

await check('tweakpane', async () => {
  const tp = await import('tweakpane');
  if (typeof tp.Pane !== 'function') throw new Error('Pane bukan function');
  return 'Pane class tersedia (konstruksi butuh DOM, tidak diuji di Node)';
});

await check('@react-three/rapier', async () => {
  const r = await import('@react-three/rapier');
  for (const k of ['Physics', 'RigidBody', 'CuboidCollider']) {
    if (!r[k]) throw new Error(`export ${k} tidak ada`);
  }
  return 'Physics, RigidBody, CuboidCollider tersedia';
});

await check('@react-three/postprocessing', async () => {
  const r = await import('@react-three/postprocessing');
  for (const k of ['EffectComposer', 'Bloom', 'Vignette']) {
    if (!r[k]) throw new Error(`export ${k} tidak ada`);
  }
  return 'EffectComposer, Bloom, Vignette tersedia';
});

await check('three.quarks', async () => {
  const q = await import('three.quarks');
  for (const k of ['ParticleSystem', 'ParticleEmitter', 'BatchedRenderer']) {
    if (!q[k]) throw new Error(`export ${k} tidak ada`);
  }
  return 'ParticleSystem, ParticleEmitter, BatchedRenderer tersedia';
});

console.log(results.every(Boolean) ? 'SEMUA OK (6/6)' : 'ADA YANG FAIL');
process.exit(results.every(Boolean) ? 0 : 1);
