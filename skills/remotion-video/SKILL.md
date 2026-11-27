# Remotion — membuat video animasi dengan kode (React)

Skill resmi Remotion (v4.0.543) untuk membuat video secara terprogram: judul animasi, transisi,
subtitle terbakar, efek Ken Burns, dan penyusunan banyak klip di satu timeline. Video ditulis sebagai
komponen React, lalu di-render jadi MP4 dengan headless browser bawaan Remotion.

Sumber upstream: https://github.com/remotion-dev/skills (commit 7e541aa4d7361dfaca0780a565a47307eb7bdfbb,
diunduh 2026-11-16). Salinan lengkap 13 skill upstream tersimpan di `upstream/` folder ini
(bahasa Inggris) — file ini adalah ringkasan berbahasa Indonesia yang siap dipakai.

## Kapan skill ini dipakai

- Membuat atau mengubah video animasi: kartu judul, intro/outro, transisi antar adegan, teks
  bergerak, dan efek pada gambar/video diam.
- Menambahkan subtitle terbakar (burned-in) atau caption animasi ke video.
- Menyusun beberapa klip (gambar AI, klip motion, VO) di satu timeline dan me-render jadi satu MP4.
- Membuat template video yang bisa dipakai ulang (mis. template episode drama vertikal 720x1280).

## Yang TIDAK bisa dilakukan skill ini

- Tidak menggantikan gambar AI (adegan masih dibuat dengan generator gambar).
- Tidak menggantikan klip motion (gerakan karakter masih dibuat dengan image-to-video, mis. Wan 2.2).
- Tidak menggantikan voice-over (VO masih dibuat dengan text-to-speech).
- Tidak mengunggah ke Facebook atau platform lain — render hanya menghasilkan file MP4 lokal.

## Prasyarat (sudah terverifikasi di mesin ini, 2026-11-16)

- Node.js v24.22.1 dan npm 10.9.4 — tersedia.
- ffmpeg 8.1.2 — tersedia (dipakai Remotion untuk encoding).
- Headless browser — TIDAK perlu install Chrome sistem. Remotion mengunduh otomatis
  `chrome-headless-shell` ke `node_modules/.remotion/` saat render pertama. Jangan pakai
  `--browser-executable` atau `browserExecutable` kecuali pemilik meminta browser lain.
- Lisensi: Remotion gratis untuk tim sampai 3 orang. Untuk render tes, tidak perlu license key.
  Jangan beli lisensi tanpa persetujuan pemilik.

## Membuat proyek baru

- Di folder kosong, scaffold proyek blank tanpa Tailwind:

```bash
npx create-video@latest --yes --blank --no-tailwind .
```

- Kalau folder sudah berisi file bermakna, scaffold ke subfolder baru:

```bash
npx create-video@latest --yes --blank --no-tailwind nama-proyek
cd nama-proyek
```

- Kalau `create-video` gagal saat install dependensi, jalankan `npm i` di dalam proyek.

## Aturan menulis markup React (dari remotion-markup)

- Animasi digerakkan dengan `useCurrentFrame()` dan `interpolate()` — JANGAN pakai CSS
  `transition`/`animation` atau class animasi Tailwind, karena tidak ikut ter-render.
- Letakkan `useCurrentFrame()` di komponen terkecil yang membutuhkannya; pisahkan judul,
  overlay, dan volume audio ke komponen sendiri supaya tidak me-render ulang semuanya tiap frame.
- Ambil `fps` dari `useVideoConfig()` untuk semua hitungan detik-ke-frame
  (mis. `trimBefore={4 * fps}`), jangan hardcode angka 30.
- Tulis `interpolate()` inline di dalam prop `style`, dan pakai properti CSS `scale`,
  `translate`, `rotate` — bukan string `transform`.
- Pakai `Easing.bezier()` atau `Easing.spring()` untuk timing yang halus.
- Untuk animasi scale, tambahkan `output: 'perceptual-scale'` di opsi interpolate.
- Aset (gambar, audio, video) ditaruh di folder `public/` proyek dan dirujuk dengan
  `staticFile("nama-file.jpg")`.
- Gambar: pakai `<Img>` (atau `<CanvasImage>`); video dan audio: `<Video>` dan `<Audio>`
  dari `@remotion/media`; GIF/WebP animasi: `<AnimatedImage>`.

## Struktur komposisi

- Daftarkan komposisi di `src/Root.tsx` lewat komponen yang me-render `<Composition>`.
- Satu komposisi = satu video: tentukan `id`, `width`, `height`, `fps`, `durationInFrames`.
- Untuk video vertikal kanal drama: `width={720} height={1280} fps={30}`.
- Kalau video berisi banyak adegan berurutan, baca dulu `upstream/remotion-markup/multi-scene-video.md`.
- Kalau video adalah timeline dari banyak klip, baca dulu
  `upstream/remotion-markup/video-editing.md` dan beri tiap klip node JSX-nya sendiri.

## Render video

- Render MP4 (hanya kalau pemilik meminta eksplisit — "render", "export", "kasih MP4-nya"):

```bash
npx remotion render [id-komposisi] out/video.mp4
```

- Kirim properti input sebagai JSON inline atau file JSON:

```bash
npx remotion render [id-komposisi] out/video.mp4 --props='{"title": "Judul"}'
npx remotion render [id-komposisi] out/video.mp4 --props=./props.json
```

- Render beberapa frame saja sebagai gambar (untuk QC):

```bash
npx remotion render [id-komposisi] out/frames --frames=0,30,90 --image-format=png
```

- Render satu frame diam:

```bash
npx remotion still [id-komposisi] out/still.png
```

- Jangan pernah pakai `--browser-executable`, `browserExecutable`, atau `chromeMode`
  kecuali pemilik meminta browser lain secara eksplisit.

## Subtitle dan caption

- Semua caption diproses sebagai JSON dengan tipe `Caption` dari `@remotion/captions`
  (`text`, `startMs`, `endMs`, `timestampMs`, `confidence`).
- Untuk transkripsi audio jadi caption, tampilkan caption, atau impor dari file .srt, baca
  `upstream/remotion-captions/transcribe-captions.md`,
  `upstream/remotion-captions/display-captions.md`, dan
  `upstream/remotion-captions/import-srt-captions.md`.

## Preview di Studio

- Buka preview interaktif sebelum render, supaya pemilik bisa melihat dan mengarahkan:

```bash
npx remotion studio
```

- Untuk klien tanpa browser in-app, jalankan `npx remotion studio --no-open` lalu buka URL
  yang dicetak (komposisi tertentu di `/[id-komposisi]`).

## Alur kerja yang terbukti di mesin ini

- Proyek tes: `~/workspace/kanal-clipper/remotion-test/` — komposisi `LayarCeritaTest`
  (720x1280, 30 fps, 90 frame = 3 detik): gambar adegan Episode 1 dengan Ken Burns zoom
  (scale 1.0 → 1.18) + judul "LAYAR CERITA" fade + slide masuk.
- Render pertama: `npx remotion render LayarCeritaTest out/test.mp4` — 90/90 frame,
  ~30 detik, hasil `out/test.mp4` 720x1280 h264 3,000 detik, terverifikasi ffprobe dan cek
  frame visual. Detail lengkap di `INSTALL-REPORT.md`.
- Pelajaran dari tes: ukuran font judul harus diukur untuk lebar 720 px (font 92 px membuat
  "LAYAR CERITA" terbungkus dua baris); letakkan judul di area yang tidak menutupi wajah.

## Daftar skill upstream (lengkap di `upstream/`)

- `remotion-best-practices` — router semua skill; baca ini dulu kalau ragu.
- `remotion-create` — membuat proyek dan komposisi baru.
- `remotion-markup` — markup React, animasi, efek, audio, font, timing.
- `remotion-render` — export video/still, props, video transparan.
- `remotion-captions` — transkripsi, tampilan, dan impor caption.
- `remotion-studio` — preview interaktif.
- `remotion-maps` — animasi peta dan rute.
- `remotion-multimedia` — trim/crop video dan metadata di browser.
- `remotion-interactivity` — markup yang bisa diedit di Studio.
- `remotion-docs` — mencari dan membaca dokumentasi Remotion.
- `remotion-saas` — arsitektur aplikasi/SaaS berbasis Remotion.
- `remotion-license` — info lisensi dan harga.
- `remotion-upgrade` — upgrade Remotion dan skill.

## Batasan dan hal yang harus dilaporkan

- Render memakai CPU mesin ini; video panjang (55+ detik, 25-30 fps) akan jauh lebih lama
  dari tes 3 detik — ukur dulu dengan render pendek sebelum render episode penuh.
- Jangan render dua video bersamaan di mesin ini (CPU terbatas).
- Laporkan selalu: perintah render yang dipakai, durasi dan resolusi hasil ffprobe, dan
  hasil cek frame visual (subtitle terbaca, tidak ada frame hitam).
- Jangan mengubah file Episode yang sudah jadi tanpa diminta; kerja di folder proyek
  Remotion sendiri, lalu gabungkan hasilnya hanya atas instruksi pemilik.
