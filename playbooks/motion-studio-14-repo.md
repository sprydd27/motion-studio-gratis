# Motion Studio — 14 Repo GitHub Gratis

Dikirim 25 Nov 2026. "Satu motion studio lengkap, 0 rupiah, ga ada langganan, ga ada Adobe, ga ada render farm" — semuanya jalan tanpa GPU. Link pendek t.co sudah diurai ke alamat GitHub aslinya.

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
