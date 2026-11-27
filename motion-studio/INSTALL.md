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
