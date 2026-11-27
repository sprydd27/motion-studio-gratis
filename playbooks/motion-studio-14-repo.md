# Motion Studio — 28 Repo GitHub Gratis

Dikirim 25 Nov 2026. "Satu motion studio lengkap, 0 rupiah, ga ada langganan, ga ada Adobe, ga ada render farm" — semuanya jalan tanpa GPU. Link pendek t.co sudah diurai ke alamat GitHub aslinya.

**Update 27 Nov 2026:** tambah 14 repo dari post X @yepzXBT (lihat "Tambahan 27 Nov 2026"
di bawah) — total jadi 28 repo.

| # | Repo | Buat apa (kata owner) | GitHub |
|---|------|--------------------|--------|
| 01 | anime.js | engine animasi web yang halus itu | https://github.com/juliangarnier/anime |
| 02 | react-spring | gerakan UI pake fisika pegas biar keliatan beneran | https://github.com/pmndrs/react-spring |
| 03 | PixiJS | render 2D kenceng, partikel, efek, 60fps | https://github.com/pixijs/pixijs |
| 04 | p5.js | generative art cuma beberapa baris | https://github.com/processing/p5.js |
| 05 | matter-js | fisika 2D beneran, jatuh, mantul, tabrakan | https://github.com/liabru/matter-js |
| 06 | D3 | grafik bergerak sama visualisasi data | https://github.com/d3/d3 |
| 07 | Motion Canvas | animasi 2D ditulis pake kode, bukan keyframe | https://github.com/motion-canvas/motion-canvas |
| 08 | Blender | 3D pake python, langsung render | https://github.com/blender/blender |
| 09 | Three.js | scene 3D jalan di browser | https://github.com/mrdoob/three.js |
| 10 | Remotion Skills | skill resmi buat nyuruh AI bikin video | https://github.com/remotion-dev/skills |
| 11 | Lottie Web | animasi after effects diputer langsung di web | https://github.com/airbnb/lottie-web |
| 12 | RIFE | bikin frame di antara frame, slowmo halus sama 60fps | https://github.com/hzwer/ECCV2022-RIFE |
| 13 | MusicGen | tulis suasananya, jadi BGM | https://github.com/facebookresearch/audiocraft |
| 14 | Tone.js | synth, beat, sound effect di browser | https://github.com/Tonejs/Tone.js |

## Cocok buat kerjaan kita

- **Motion Canvas (07) + Remotion (10)** — sudah tersedia (skill `motion-design-toolkit` + `remotion-video`). Ini jalur utama animasi berkode buat Layar Cerita.
- **RIFE (12)** — paling relevan buat pilot ASMR: interpolasi frame bisa menghaluskan gerakan + slow-mo. Juga buat slow-mo klip GTA.
- **MusicGen (13) + Tone.js (14)** — paling relevan buat kelemahan terbesar pilot ASMR (suara masih sintetis): MusicGen buat BGM dari deskripsi suasana, Tone.js buat SFX/beat yang dikontrol penuh dari kode.
- **PixiJS (03) + p5.js (04) + matter-js (05)** — efek partikel (api, debu, hujan), background generatif, dan adegan fisika buat Layar Cerita/ASMR. Semuanya bisa jalan di dalam pipeline HTML→video (Remotion/Hyperframes).
- **D3 (06)** — grafik animasi, mis. visualisasi data GTA/leaderboard.
- **Blender (08) + Three.js (09)** — aset/scene 3D. Three.js bisa di-render lewat browser; Blender buat aset 3D yang lebih serius.
- **anime.js (01) + react-spring (02) + Lottie Web (11)** — animasi teks/judul, transisi halus, dan stiker/ikon bergerak di video HTML.

## Catatan penting

- **MusicGen non-komersial doang** (lisensi) — jangan jadi andalan buat konten yang targetnya dimonetisasi di Facebook. Tone.js + SFX bebas lebih aman buat jalur monetisasi.
- **Remotion gratis buat tim sampai 3 orang.**
- "Tanpa GPU" berlaku buat repo-repo web di atas; render Blender scene berat tetap butuh waktu CPU/GPU.

## Rencana

Rencana: coba bikin sesuatu malam 25 Nov 2026. Kandidat pertama yang paling nyambung sama kerjaan jalan: perbaiki pilot ASMR (RIFE buat gerakan + MusicGen/Tone.js buat suara), atau coba satu animasi Motion Canvas buat Layar Cerita.

## Tambahan 27 Nov 2026: 14 repo dari @yepzXBT

Dikirim 27 Nov 2026. Post X @yepzXBT (25 Nov 2026, 28,6 rb views):
"Coba pake 20 repo GitHub ini jika kamu ingin membuat Vidio menggunakan muse".
Dari 20 itu, 5 sudah ada di daftar 14 pertama + FFmpeg sudah jadi tool —
sisanya 14 baru di bawah ini. Install 27 Nov 2026, laporan di
~/workspace/motion-studio/INSTALL.md ("Tambahan 27 Nov 2026").

| # | Repo | Buat apa | GitHub | Status install |
|---|------|----------|--------|-------|
| 15 | Motion | spring animation & transisi smooth | https://github.com/motiondivision/motion | OK 14.14.0 |
| 16 | GSAP | timeline animasi powerful, sekarang full gratis | https://github.com/greensock/GSAP | OK 3.15.1 |
| 17 | Tweakpane | sesuaikan parameter animasi real-time | https://github.com/cocopon/tweakpane | OK 4.0.5 |
| 18 | react-three-rapier | fisika realistis di scene Three.js/React | https://github.com/pmndrs/react-three-rapier | OK 2.2.0 |
| 19 | react-postprocessing | glow, depth of field, efek film di Three.js | https://github.com/pmndrs/react-postprocessing | OK 3.2.2 |
| 20 | three.quarks | partikel & efek visual dramatis di Three.js | https://github.com/Alchemist0823/three.quarks | OK 0.18.0 |
| 21 | Manim | animasi penjelasan, formula, diagram | https://github.com/ManimCommunity/manim | OK 0.22.1 |
| 22 | librosa | deteksi beat biar animasi pas ketukan | https://github.com/librosa/librosa | OK 1.0.1 |
| 23 | WhisperX | auto-align subtitle, support Indonesia | https://github.com/m-bain/whisperX | OK 3.8.6 |
| 24 | Openverse API | SFX, ambient, musik gratis tanpa API key | https://github.com/WordPress/openverse | API OK |
| 25 | motion-design-skill | skill prinsip motion design (timing, easing, 12 prinsip Disney) | https://github.com/LottieFiles/motion-design-skill | link-only |
| 26 | hairline | ide/SVG jadi animasi line art isometrik | https://github.com/lucasmarkes/hairline | link-only |
| 27 | anatomy | diagram 3D mesin & struktur interaktif | https://github.com/wheresryan22/anatomy | link-only |
| 28 | anatomy-reveal | exploded view + highlight produk, film product-reveal | https://github.com/annnguyentt/anatomy-reveal-skill | link-only |

### Overlap dengan 14 pertama (5 repo)

- Remotion Skills (10), Remotion (engine, bagian dari 10), Blender (08),
  Three.js (09), Lottie Web (11) — sudah ada, tidak dihitung dua kali.
- FFmpeg (20 di post) sudah jadi tool sistem (ffmpeg 8.1.2), bukan repo baru.

### Cocok buat kerjaan kita (tambahan)

- **WhisperX (23)** — subtitle Indonesia auto-align: ganti/tingkatkan faster-whisper
  di pipeline clipper.
- **Openverse API (24)** — SFX/ambient/musik gratis tanpa key: jawaban buat
  kelemahan terbesar pilot ASMR (suara masih sintetis). API teruji 27 Nov:
  `api.openverse.org/v1/audio/?q=rain` → 200, 240 hasil, file mp3 bisa diunduh.
- **GSAP (16) + Motion (15)** — timeline + spring buat animasi teks/judul di video HTML.
- **Manim (21)** — animasi penjelasan/formula: gaya Irsan Saputra buat Layar Cerita.
- **motion-design-skill (25)** — prinsip motion (timing/easing/Disney) sebagai skill.
- **anatomy (27) + anatomy-reveal (28) + hairline (26)** — diagram isometrik &
  product-reveal: buat konten edukasi/visualisasi GTA.
- **librosa (22)** — beat detection: sinkronkan gerakan dengan ketukan musik.
- **react-three-rapier (18) + react-postprocessing (19) + three.quarks (20)** —
  fisika + efek film + partikel di scene 3D (Three.js).
- **Tweakpane (17)** — tuning parameter animasi real-time.
