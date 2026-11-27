# Laporan Install — Skill Remotion Video

Tanggal: 2026-11-16
Sumber: postingan X Felix @Feljoy_ix (15 Nov 2026) — 18 repo GitHub gratis yang diklaim sebagai
"Skill" untuk membuat video animasi dengan Muse. Yang diinstall: **hanya nomor 1, Remotion Skills**
(https://github.com/remotion-dev/skills) — satu-satunya yang benar-benar berupa skill.
17 lainnya adalah library animasi, bukan skill, jadi TIDAK diinstall sebagai skill; daftarnya ada
di bawah sebagai referensi library yang bisa dipakai di dalam proyek Remotion bila perlu.

## Yang diinstall

- Repo: https://github.com/remotion-dev/skills
- Cara ambil: `git clone --depth 1` (shallow) ke /tmp, lalu salinan lengkap skill dipindah ke
  `~/workspace/custom-skills/remotion-video/upstream/` (3,0 MB).
- Commit: `7e541aa4d7361dfaca0780a565a47307eb7bdfbb` ("Update template")
- Versi paket: `@remotion/skills` 4.0.543
- Skill custom (ringkasan Bahasa Indonesia): `~/workspace/custom-skills/remotion-video/SKILL.md`
- Isi upstream: 13 skill — remotion-best-practices, remotion-captions, remotion-create,
  remotion-docs, remotion-interactivity, remotion-license, remotion-maps, remotion-markup,
  remotion-multimedia, remotion-render, remotion-saas, remotion-studio, remotion-upgrade.

## Cek lingkungan mesin ini

| Komponen | Hasil |
|---|---|
| Node.js | v24.22.1 — tersedia |
| npm | 10.9.4 — tersedia |
| ffmpeg | 8.1.2 — tersedia |
| Chrome/Chromium sistem | TIDAK ada di PATH — **tidak diperlukan** |
| Headless browser Remotion | Terunduh otomatis saat render pertama ke `node_modules/.remotion/chrome-headless-shell` |
| Proyek tes | `~/workspace/kanal-clipper/remotion-test/` — remotion 4.0.543, React 19.3.1, `node_modules` 638 MB |

Perintah scaffold yang dipakai:

```bash
npx create-video@latest --yes --blank --no-tailwind .
```

Scaffold + install dependensi selesai tanpa error.

## Uji render nyata — BERHASIL

Proyek tes: `~/workspace/kanal-clipper/remotion-test/`
Komposisi: `LayarCeritaTest` — 720x1280 vertikal, 30 fps, 90 frame (3 detik).
Isi: gambar adegan 1 Episode 1 (`public/adegan1-kereta.jpg`, dari
`~/workspace/kanal-clipper/drama-ai/ep01-v2/kerja/`) dengan efek Ken Burns
(scale 1.0 → 1.18) + judul "LAYAR CERITA" fade + slide masuk + subjudul
"DRAMA AI BERSAMBUNG" + gradasi gelap bawah.

Perintah render:

```bash
npx remotion render LayarCeritaTest out/test.mp4
```

Hasil (terverifikasi, bukan klaim):

- 90/90 frame ter-render dan ter-encode, waktu render ~30 detik.
- File: `~/workspace/kanal-clipper/remotion-test/out/test.mp4` — 677 kB.
- ffprobe: h264, 720x1280, 30 fps, durasi 3,000 detik, video stream ada.
- Cek frame visual: frame 0 = adegan penuh tanpa judul; frame 89 = judul emas
  "LAYAR CERITA" + "DRAMA AI BERSAMBUNG" terlihat jelas, gambar ter-zoom (tanda LED
  kereta di atas terpotong karena zoom) — animasi dan Ken Burns terbukti jalan.

Catatan QC dari tes (pelajaran untuk pemakaian nyata):

- Font judul 92 px terlalu besar untuk lebar 720 px — "LAYAR CERITA" terbungkus jadi
  dua baris. Untuk judul satu baris di 720 px, pakai ~64–72 px atau ukur teks dulu.
- Judul jatuh menutupi wajah tokoh — atur posisi (lebih ke atas/bawah) atau pakai
  gradasi lebih kuat di area judul.

## Penilaian jujur untuk kanal "Layar Cerita"

### Yang Remotion BISA bantu

- **Animasi judul dan teks**: judul episode, "BERSAMBUNG", nama tokoh — fade/slide/spring
  dengan timing presisi per frame (lebih rapi dan konsisten daripada drawtext ffmpeg).
- **Transisi antar adegan**: fade, slide, wipe, zoom — bisa dibuat sebagai template.
- **Subtitle terbakar**: caption dari JSON/SRT ditampilkan dengan gaya konsisten
  (putih tebal + outline hitam seperti sekarang), tanpa render ulang manual per baris.
- **Efek Ken Burns yang terkontrol**: zoom/pan dengan easing di atas gambar adegan,
  menggantikan ffmpeg zoompan yang sekarang dipakai.
- **Template episode**: satu komposisi dengan props (judul, gambar adegan, naskah) bisa
  dipakai ulang tiap episode — cukup ganti props, render ulang.
- **Penyusunan timeline**: menggabungkan gambar AI + klip motion + VO dalam satu
  komposisi dan render jadi satu MP4 (menggantikan concat ffmpeg yang rapuh).

### Yang Remotion TIDAK bisa

- **Tidak menggantikan gambar AI** — adegan tetap dibuat dengan generator gambar.
- **Tidak menggantikan klip motion Wan 2.2** — gerakan karakter (menoleh, mengangkat
  telepon) tetap dibuat dengan image-to-video; Remotion hanya menganimasikan elemen
  yang sudah ada (zoom, geser, fade).
- **Tidak menggantikan VO** — narasi tetap dibuat dengan text-to-speech.
- **Tidak membuat dialog lip-sync** seperti referensi "Konten Ai" — itu butuh model
  video generatif, bukan animasi kode.
- **Tidak mengunggah ke Facebook** — output hanya file MP4 lokal.
- **Biaya waktu render**: video 55 detik akan jauh lebih lama dari tes 3 detik
  (~30 detik untuk 90 frame); ukur dulu dengan render pendek sebelum render penuh,
  dan jangan render dua video bersamaan (CPU mesin terbatas).

### Rekomendasi pemakaian

- Pakai Remotion mulai Episode 3 untuk: template judul + "BERSAMBUNG", subtitle
  terbakar, dan transisi — tiga hal yang paling terasa peningkatannya dibanding ffmpeg.
- Tetap pakai pipeline sekarang (gambar AI + klip motion Wan 2.2 + VO) untuk isi adegan.
- Simpan template episode di `~/workspace/kanal-clipper/remotion-test/` atau proyek
  Remotion khusus per musim, jangan campur dengan file Episode yang sudah jadi.

## 17 library lain dari postingan X (TIDAK diinstall sebagai skill)

Dari utas yang sama, 17 repo berikut diklaim sebagai "skill" padahal semuanya adalah
**library/framework animasi**, bukan skill agen. Dicatat di sini saja sebagai referensi —
semuanya bisa dipakai DI DALAM proyek Remotion (atau proyek video lain) bila suatu saat
dibutuhkan, tapi tidak ada yang diinstall sekarang:

1. Motion Canvas, 2. Motion, 3. Ola, 4. Anime.js, 5. Manim, 6. Shifty, 7. Two.js,
8. Lottie Web, 9. TweenJS, 10. LUME, 11. gifenc, 12. Konva, 13. Blender, 14. Three.js,
15. Godot, 16. Babylon.js, 17. Proton.

Catatan: Remotion sendiri sudah mendukung Lottie (`@remotion/lottie`) dan Three.js
(`@remotion/three`), jadi dua library itu tercakup tanpa install terpisah.
