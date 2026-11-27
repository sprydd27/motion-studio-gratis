# INSTALL.md — Motion Studio (14 repo gratis)

Tanggal install: 25 Nov 2026 (dini hari WIB). Mesin: CPU-only, tanpa GPU, tanpa login, tanpa bayar.
Lingkungan saat install: disk 140 GB kosong, RAM bebas ~1,3 GB (install berurutan, tanpa paralel build berat).
Node v24.22.1, npm 10.9.4, Python 3.12.3, ffmpeg 8.1.2. `/tmp` tidak dipakai (512 MB) — pip pakai
`~/workspace/.pip-tmp`, scratch pakai `~/workspace/motion-studio/tmp/`.

## Ringkasan

| # | Repo | Status | Versi | Verifikasi yang lolos |
|---|------|--------|-------|------------------------|
| 01 | anime.js | OK | 4.5.0 | `animate()` ok (Node import langsung) |
| 02 | react-spring | OK | 10.0.4 | `animated` ok (React 19.3.1 + react-dom 19.3.1) |
| 03 | PixiJS | OK | 8.23.0 | PIXI v8.23.0 |
| 04 | p5.js | OK* | 2.4.0 | import OK dengan jsdom shim (butuh DOM) |
| 05 | matter-js | OK | 0.20.0 | `Engine.create()` ok |
| 06 | D3 | OK | 7.9.2 | `select()` ok |
| 07 | Motion Canvas | OK* | 3.17.2 (core + ffmpeg) | `makeProject()` function via esbuild bundle |
| 08 | Blender | OK | 4.0.2 | `blender --version` + `bpy` API OK |
| 09 | Three.js | OK | 0.187.0 (r187) | REVISION 187 |
| 10 | Remotion | OK | 4.0.547 | `interpolate()` ok, `createTikTokStyleCaptions` ok |
| 11 | Lottie Web | OK* | 5.13.0 | `loadAnimation()` function (jsdom + @napi-rs/canvas) |
| 12 | RIFE | OK | repo ECCV2022-RIFE + model v4 HD | inferensi 2 frame 64×64 → mid frame OK di CPU |
| 13 | MusicGen (audiocraft) | **GAGAL** | — | lihat "Yang gagal" di bawah |
| 14 | Tone.js | OK | 15.1.22 | Tone v15.1.22 |

OK* = terinstall dan terverifikasi jalan, tapi butuh runtime browser/bundler (bukan import Node polos) — itu cara pakai normal pustaka tersebut.

**Hasil: 13 dari 14 OK. 1 gagal (MusicGen).**

## Layout

```
~/workspace/motion-studio/
├── js/                  # proyek npm: semua pustaka JS (package.json + node_modules)
│   ├── verify.mjs            # script verifikasi import semua paket JS
│   ├── verify-p5-jsdom.mjs   # verifikasi p5 + jsdom
│   └── verify-lottie-jsdom.mjs
├── venv/                # venv Python (torch CPU, RIFE deps, av)
├── rife/                # clone https://github.com/hzwer/ECCV2022-RIFE
│   └── train_log/       # flownet.pkl (12 MB, model v4 HD) + RIFE_HDv3.py + IFNet_HDv3.py
└── tmp/                 # scratch: RIFE_HD_models.zip, test_rife.py, bundle esbuild
Blender: /usr/bin/blender (install via apt, sudo NOPASSWD)
```

## Detail per repo

### 01 anime.js — OK (4.5.0)
`npm install animejs`. Verifikasi: `node js/verify.mjs` → `animate() ok`.

### 02 react-spring — OK (10.0.4)
`npm install react-spring react react-dom`. Verifikasi: `animated` ok.
Catatan: npm menampilkan warning ERESOLVE overriding peer dependency (react-spring vs React 19) — tidak menghambat, install tetap jalan.

### 03 PixiJS — OK (8.23.0)
`npm install pixi.js`. Verifikasi: PIXI v8.23.0.

### 04 p5.js — OK* (2.4.0)
`npm install p5`. Import Node polos GAGAL (`Cannot read properties of undefined (reading 'then')`) karena p5 butuh DOM.
Verifikasi lolos: dengan jsdom shim (`js/verify-p5-jsdom.mjs`) → `p5 import with jsdom: OK, default is function`.
Artinya: p5 jalan normal di runtime browser (render Remotion/Hyperframes) atau Node + jsdom.

### 05 matter-js — OK (0.20.0)
`npm install matter-js`. Verifikasi: `Engine.create()` ok.

### 06 D3 — OK (7.9.2)
`npm install d3`. Verifikasi: `select()` ok.

### 07 Motion Canvas — OK* (core 3.17.2 + ffmpeg 3.17.2)
`npm install @motion-canvas/core @motion-canvas/ffmpeg`. Catatan: `@motion-canvas/ffmpeg` menarik `fluent-ffmpeg@2.1.3` (deprecated) — hanya warning.
Import Node ESM polos GAGAL: `Directory import '.../lib/meta' is not supported` — quirk packaging core 3.17.2 yang hanya Vite/bundler yang menyelesaikan (cara pakai normal Motion Canvas memang via Vite).
Verifikasi lolos: bundle esbuild `--platform=node` → `makeProject: function`, `Thread: function`, API lengkap.
`@motion-canvas/ffmpeg`: load OK via ESM + CJS; default export function (plugin), `FFmpegExporter` ada di client bundle.

### 08 Blender — OK (4.0.2)
`sudo apt-get install -y blender` (sudo NOPASSWD jalan; apt update dulu ~12 menit). Verifikasi:
`blender --version` → Blender 4.0.2; `blender -b --python-expr "import bpy"` → `BLENDER-PYTHON-OK 4.0.2`.
Tarball blender.org TIDAK diperlukan.

### 09 Three.js — OK (0.187.0 / r187)
`npm install three`. Verifikasi: REVISION 187.

### 10 Remotion — OK (4.0.547)
Sesuai skill `remotion-video` (skill menyebut v4.0.543; yang terinstall 4.0.547, lebih baru):
`npm install remotion @remotion/cli @remotion/media @remotion/captions`.
Verifikasi: `interpolate()` ok, `Video`/`Img` ok, `createTikTokStyleCaptions` ok.
Catatan: render pertama akan mengunduh `chrome-headless-shell` ke `node_modules/.remotion/` (sesuai skill).

### 11 Lottie Web — OK* (5.13.0)
`npm install lottie-web`. Import Node polos: modul ter-load tapi `loadAnimation` tidak tersedia (butuh canvas).
Verifikasi lolos: jsdom + `@napi-rs/canvas` (diinstall sebagai support) → `loadAnimation = function`.
Artinya: jalan normal di browser; di Node butuh jsdom + canvas.

### 12 RIFE — OK (model v4 HD)
Clone `https://github.com/hzwer/ECCV2022-RIFE` ke `rife/`.
Model: zip HD models dari Google Drive (ID `1APIzVeI-4ZZCEuIRE1m6WYfSCaOsi_7_`, 11,3 MB) via `gdown`,
diisi `train_log/flownet.pkl` (12 MB) + `RIFE_HDv3.py` + `IFNet_HDv3.py` — ini model **v4 HD** yang dipakai
`inference_video.py --exp=1`.
Venv: `torch 2.15.0+cpu`, `torchvision 0.29.2+cpu` (dibutuhkan `model/loss.py`), `numpy 2.5.5`,
`opencv-python-headless 5.1.0`, `tqdm`, `gdown`, `av 15.1.0`.
Verifikasi (`tmp/test_rife.py`): model load di CPU → inferensi 2 frame 64×64 → mid frame (1,3,64,64), range 0.0–1.0 → `RIFE INFERENCE OK`.
Catatan: `requirements.txt` repo mem-pin `numpy<=1.23.5` (kadaluwarsa, tidak ada wheel Python 3.12) — dipakai numpy 2.5.5, jalan.

### 13 MusicGen (audiocraft) — GAGAL
`pip install audiocraft` (v1.3.0, sdist dari PyPI) **gagal** karena pin di `requirements.txt`-nya:
- `av==11.0.0` — tidak ada wheel untuk Python 3.12 → pip mencoba build dari source → gagal.
- `torch==2.1.0` + `torchvision==0.16.0` + `torchtext==0.16.0` — pin lama, konflik dengan torch 2.15.0+cpu yang sudah terinstall.
- `av==15.1.0` wheel sudah diinstall dulu di venv (berhasil), tapi pin `==11.0.0` audiocraft tidak menerimanya.
Tambahan: saat ekstraksi sdist audiocraft untuk membaca pin-nya, hasil ekstraksi itu gagal execution-risk check,
jadi install/build/import paket audiocraft **dihentikan** dan file hasil ekstraksi sudah dihapus. **Jangan lanjutkan install
audiocraft tanpa persetujuan owner.**
Opsi ke depan (butuh keputusan owner): (a) venv Python 3.10 + torch 2.1.0 sesuai pin audiocraft (cara resmi repo),
atau (b) pakai pipeline MusicGen lewat pustaka `transformers` (`facebook/musicgen-small`, jalan di CPU torch tanpa audiocraft).

### 14 Tone.js — OK (15.1.22)
`npm install tone`. Verifikasi: Tone v15.1.22.

## Paket pendukung (bukan dari daftar 14, diinstall sebagai penunjang verifikasi)

- `jsdom` + `@napi-rs/canvas` (di `js/`) — DOM + canvas buat p5/lottie di Node.
- `gdown` (di `venv/`) — unduh model RIFE dari Google Drive.
- `av 15.1.0` (di `venv/` baru — BUKAN `clipper-venv`; pin av 15.1.0 di clipper-venv tidak disentuh).

## Yang sudah bisa dipakai malam ini

- **Semua pustaka JS** (anime, react-spring, PixiJS, p5, matter-js, D3, Three.js, Lottie, Tone.js, Motion Canvas, Remotion):
  siap dipakai di proyek Remotion / Motion Canvas (render di browser). Masuk folder `js/` dan mulai dari `verify.mjs` sebagai contoh import.
- **RIFE**: siap interpolasi frame di CPU — `cd rife && ../venv/bin/python inference_video.py --exp=1 --video=...`
  (butuh `sk-video`/`moviepy` untuk mode video penuh; inferensi frame-ke-frame sudah terbukti jalan).
- **Blender**: siap render 3D via Python — `blender -b --python skrip.py`.
- **Yang belum bisa**: MusicGen (BGM AI). Pengganti malam ini: **Tone.js** (synth/beat/SFX dari kode) + ffmpeg (sudah ada) buat suara.

## Ukuran

Total `~/workspace/motion-studio/`: ~2,3 GB (node_modules JS paling besar).

## Tambahan 27 Nov 2026: 14 repo dari @yepzXBT

Post X @yepzXBT (25 Nov 2026): "20 repo GitHub buat bikin video pakai Muse".
Dari 20 itu, 5 sudah ada di 14 pertama (Remotion Skills, Remotion, Blender,
Three.js, Lottie; FFmpeg sudah jadi tool) — sisanya 14 baru di bawah ini.
Install 27 Nov 2026, berurutan (RAM bebas ~0,4 GB saat install).
Daftar lengkap + overlap: `~/workspace/creator-playbook/motion-studio-14-repo.md`.

| # | Repo | Status | Versi | Verifikasi yang lolos |
|---|------|--------|-------|------------------------|
| 15 | Motion (motiondivision/motion) | OK | 14.14.0 | `animate()` function (`js/verify-new.mjs`) |
| 16 | GSAP (greensock/GSAP) | OK | 3.15.1 | `gsap.to()` function, `gsap.version` |
| 17 | Tweakpane (cocopon/tweakpane) | OK | 4.0.5 | `Pane` class tersedia (konstruksi butuh DOM, tidak diuji di Node) |
| 18 | react-three-rapier (pmndrs/react-three-rapier) | OK | 2.2.0 | `Physics`, `RigidBody`, `CuboidCollider` tersedia (+ @react-three/fiber 9.8.2) |
| 19 | react-postprocessing (pmndrs/react-postprocessing) | OK | 3.2.2 | `EffectComposer`, `Bloom`, `Vignette` tersedia (+ postprocessing 6.39.6) |
| 20 | three.quarks (Alchemist0823/three.quarks) | OK | 0.18.0 | `ParticleSystem`, `ParticleEmitter`, `BatchedRenderer` tersedia |
| 21 | Manim (ManimCommunity/manim) | OK | 0.22.1 | `manim --version` + render scene kecil (Circle + Text "Halo", 720p30, 2 animasi, `tmp/manim-smoke/`) |
| 22 | librosa (librosa/librosa) | OK | 1.0.1 | `import librosa` + `beat_track` pada wav sintetis 16 dtk (120 BPM): tempo 117,45, 31 beat terdeteksi |
| 23 | WhisperX (m-bain/whisperX) | OK | 3.8.6 | import OK + model tiny (CPU, int8) load + transcribe jalan (0 segmen pada audio hujan — benar, bukan speech); torch 2.8.0+cpu |
| 24 | Openverse API (WordPress/openverse) | OK (API, tanpa install server) | — | `api.openverse.org/v1/audio/?q=rain` → HTTP 200, 240 hasil; file mp3 pertama berhasil diunduh (1.379.890 byte, MP3 128 kbps 44,1 kHz, CC-BY 4.0) |
| 25 | motion-design-skill (LottieFiles/motion-design-skill) | OK (link-only) | 1.0.0 | Clone ke `upstream-skills/`; skill md-only di `skills/motion-design/SKILL.md` + director/patterns/reference |
| 26 | hairline (lucasmarkes/hairline) | OK (link-only) | — | Clone ke `upstream-skills/`; skill `skills/hairline-create/SKILL.md` + `skills/hairline-adopt/SKILL.md`; repo 12 MB (monorepo apps+packages) |
| 27 | anatomy (wheresryan22/anatomy) | OK (link-only) | — | Clone ke `upstream-skills/`; `SKILL.md` di root; repo 40 MB (examples/ 25 MB) |
| 28 | anatomy-reveal (annnguyentt/anatomy-reveal-skill) | OK (link-only) | — | Clone ke `upstream-skills/`; `SKILL.md` di root; template/ proyek lengkap |

**Hasil: 14 dari 14 sudah OK/terverifikasi (4 skill repo link-only).**

## Detail tambahan 27 Nov 2026

### 15–20 JS (motion, GSAP, Tweakpane, rapier, postprocessing, three.quarks) — OK
`npm install motion gsap tweakpane @react-three/rapier @react-three/postprocessing three.quarks`
di `js/` (27 paket baru). Verifikasi: `js/verify-new.mjs` → 6/6 OK.
Catatan: peringatan peer-dependency react-spring/zdog (sudah ada sebelumnya,
tidak menghambat). `three.quarks`: nama export yang benar `BatchedRenderer`
(bukan `BatcheRenderer`).

### 21 Manim — OK (0.22.1, venv terpisah `venv-manim/`)
System dep sudah ada (libcairo2 1.18.0 + libcairo2-dev, libpango 1.52.1,
ffmpeg 8.1.2) — tidak perlu apt install. Venv terpisah supaya pin-pinnya
tidak bentrok dengan venv utama (Manim membawa av 19.0.2 + numpy 2.5.5
sendiri). Verifikasi: render scene kecil jalan (`tmp/manim-smoke/`).

### 22 librosa — OK (1.0.1, di venv utama)
`pip install librosa` di `venv/` (menarik scipy 1.18.1, numba 0.68.1,
scikit-learn 1.9.1, soundfile, soxr — numpy 2.5.5 tetap, tidak ada konflik).
Verifikasi: `beat_track` pada wav sintetis 16 detik (burst noise tiap 0,5
detik = 120 BPM): tempo 117,45, 31 beat terdeteksi di grid 0,5 detik.
Dua catatan: (1) sinyal tes pertama (sine murni + klik) GAGAL — `beat_track`
mengembalikan tempo 0,0 karena onset envelope dengan agregasi median = 0
untuk sinyal narrowband; sinyal broadband (noise burst) yang benar untuk tes.
(2) di librosa 1.0, `beat_track` mengembalikan tempo sebagai array (bukan
skalar) dan `librosa.beat.tempo` sudah tidak ada.

### 23 WhisperX — OK (3.8.6, venv terpisah `venv-whisperx/`)
Percobaan pertama `pip install whisperx` langsung: pip menarik torch 2.8.0
CUDA + pustaka NVIDIA (±2,2 GB di `.pip-tmp`, 14 menit, 0 paket terinstall)
— dihentikan karena mesin ini CPU-only dan wheel CUDA tidak berguna di sini.
Perbaikan: pasang dulu `torch==2.8.0+cpu` + `torchaudio==2.8.0+cpu` dari
index CPU PyTorch (2 menit), baru `pip install whisperx` — pip memakai
torch CPU yang sudah ada (tetap 2.8.0+cpu, tidak diganti CUDA).
Dua konflik versi sesudahnya, keduanya diperbaiki:
(1) `whisperx.asr` gagal `from transformers import Pipeline` — transformers
4.57.6 sudah tidak menyediakan `Pipeline` di top-level → downgrade ke
transformers 4.48.3 (batas bawah requirement whisperx `>=4.48.0`).
(2) torchvision dari PyPI (build CUDA) gagal `operator torchvision::nms
does not exist` dengan torch CPU → ganti ke `torchvision==0.23.0+cpu`
dari index CPU PyTorch.
Verifikasi akhir: `import whisperx` OK; model tiny (CPU, int8) berhasil
diunduh + load; transcribe audio hujan 5 detik jalan (VAD Pyannote:
"No active speech found" — benar, bukan speech; bahasa terdeteksi en 0,42;
0 segmen). Alignment pada speech Bahasa Indonesia asli masih pending
(butuh sampel speech) — pipeline-nya sendiri terbukti jalan.
Versi akhir di venv: whisperx 3.8.6, faster-whisper 1.2.1, ctranslate2 4.9.1,
transformers 4.48.3, torch 2.8.0+cpu, torchaudio 2.8.0+cpu,
torchvision 0.23.0+cpu, pyannote-audio 4.1.1.

### 24 Openverse API — OK (tanpa install server repo)
Repo server (WordPress/openverse) TIDAK diinstall sebagai aplikasi — yang
diuji API publiknya: `api.openverse.org/v1/audio/?q=rain` TANPA API key →
HTTP 200, 240 hasil. File pertama ("Rain, Moderate, C.wav", freesound,
CC-BY 4.0) berhasil diunduh: 1.379.890 byte, MP3 128 kbps 44,1 kHz.
Catatan jujur: dulu website Openverse pernah 403 — tapi API publiknya
jalan tanpa key. Tetap catat lisensi tiap file (CC-BY butuh atribusi).

### 25–28 Skill repo — OK (link-only, TIDAK di-vendor)
Keempat repo di-clone ke `upstream-skills/` (baca SKILL.md-nya, catat isinya).
Semuanya lisensi MIT. Di repo publik `motion-studio-gratis` hanya masuk
sebagai `skills-upstream/<nama>/README.md` (deskripsi + link + clone) —
TIDAK di-vendor, karena: (a) konten keempat repo ini gagal execution-risk
check saat dibaca — menyalin/memindahkan file-nya ke repo publik atau ke
custom-skills dilarang tanpa persetujuan eksplisit owner setelah peringatan;
(b) ukuran: anatomy 40 MB (examples/ 25 MB), hairline 12 MB (monorepo);
(c) anatomy/anatomy-reveal berisi kode executable (.mjs, template, scripts)
yang perlu review. motion-design-skill sendiri bersih (md-only, 256 KB) tapi
tetap link-only karena alasan (a). Kalau owner tetap mau vendor/install,
minta persetujuan eksplisit dulu setelah peringatan ini.
Isi singkat: motion-design-skill = prinsip motion design (timing, easing,
12 prinsip Disney); hairline = 33 figur garis isometrik (skill create +
adopt); anatomy = diagram isometrik mesin interaktif (8 contoh, butuh
Node 20.10+ + Chrome); anatomy-reveal = exploded view + film product-reveal
(template lengkap, butuh Node 20+ + Chrome + ffmpeg + ImageMagick 7).

## Ukuran baru

Total `~/workspace/motion-studio/` setelah tambahan: **6,6 GB** (dari 2,3 GB).

| Folder | Ukuran | Isi |
|---|---|---|
| `js/` (node_modules) | 1,1 GB | 20 pustaka JS (14 pertama + 6 baru) |
| `venv/` (utama) | 1,7 GB | torch CPU + RIFE + librosa + scipy/numba |
| `venv-manim/` | 475 MB | Manim 0.22.1 + dep |
| `venv-whisperx/` | 2,9 GB | WhisperX 3.8.6 + torch CPU + transformers + pyannote |
| `upstream-skills/` | 58 MB | 4 clone skill repo (depth 1) |
| `rife/` | 20 MB | repo + model v4 HD |
| `tmp/` | 538 MB | scratch (tes, model zip, smoke test) |
