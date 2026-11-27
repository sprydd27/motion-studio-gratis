# Trial ASMR v3 — RIFE + Tone.js (rencana, 25 Nov 2026 malam)

Tujuan: perbaiki dua kelemahan pilot v2 — (1) subjek tidak benar-benar bergerak,
(2) suara masih sintesis ffmpeg — pakai motion studio gratis yang sudah terinstall.
Bukan janji hasil; ini trial kecil dulu sebelum commit ke satu adegan penuh.

## Yang sudah terverifikasi malam ini (25 Nov ~19:48 WIB)

- RIFE v4 HD jalan di frame ASLI pilot (adegan 3 bakar, `kerja/kb3.mp4`):
  frame t=1 dtk dan t=2 dtk, 288x512, CPU.
- Waktu: load model 0,2 dtk, inferensi 1 frame tengah 3,3 dtk.
- Hasil benar frame tengah, bukan salinan: beda rata-rata f0–f1 = 15,09;
  f0–mid = 8,14; mid–f1 = 8,14 (nyaris persis setengah jalan).
- File bukti: `~/workspace/motion-studio/tmp/rife-pilot-test/`
  (`f0.png`, `f1.png`, `mid.png`, `test_rife_pilot.py`).
- Batasan yang ketemu: dimensi HARUS kelipatan 32 — 360x640 GAGAL
  (RuntimeError tensor 360 vs 368). 288x512 (9:16, kelipatan 32) jalan.
  Kandidat resolusi kerja: 288x512 (cepat) atau 544x960 (544/32=17, 960/32=30)
  — yang kedua belum dites waktu/RAM-nya.

## Estimasi waktu (dari 3,3 dtk/frame di 288x512)

- Shot 3 detik 30fps -> 60fps: 90 frame tengah x 3,3 dtk = ~5 menit.
- Adegan 3 penuh (10 dtk): 300 frame = ~16,5 menit.
- Di 544x960 kemungkinan ~4x lebih lambat — jangan langsung ke sana;
  coba 288x512 dulu, upscale ke 1080x1920 di akhir, bandingkan visual.

## Hasil smoke test — LOLOS (26 Nov ~19:50 WIB, dijalankan lokal tanpa go ulang)
- Dijalankan diam-diam sebagai kerja lokal (tanpa posting, tanpa biaya, tanpa MusicGen/Kling): trial ditawarkan 25 Nov ~20:26 dan belum dijawab owner, tapi ini trial motion-studio yang owner rencanakan sendiri malam 25 Nov.
- 3 detik adegan 3 (t=0–3), 30→60fps, 288x512 CPU: 89 frame tengah, **0,80 dtk/frame (total 71 dtk)** — jauh lebih cepat dari estimasi 3,3 dtk/frame.
- Klip rakitan: `~/workspace/motion-studio/tmp/rife-smoke-3s/smoke-3s-60fps.mp4` — 2,98 dtk, 1080x1920, 60fps, 1,4 MB.
- QA numerik frame 45: |f0–f1|=2,44, |f0–mid|=1,34, |mid–f1|=1,43 — frame tengah benar-benar di tengah. QA visual: tangan, ikan, api, asap utuh, gaya watercolor terjaga, tidak ada artefak meleleh.
- Implikasi estimasi: adegan 3 penuh 10 dtk (300 frame) kini ~4 menit, bukan 16,5 menit. Script: `~/workspace/motion-studio/tmp/rife-smoke-3s/run_rife_3s.py`.
- Yang masih belum: suara Tone.js (langkah 3) belum terverifikasi; MusicGen tetap parkir nunggu pilihan owner.

## Adegan 3 penuh 10 detik — SELESAI + QA LOLOS (27 Nov ~06:55 WIB, dijalankan lokal tanpa go ulang)
- 300 frame asli (t=0–10 dari `kb3.mp4`, 288x512 CPU) → 299 frame tengah RIFE, total 281 dtk (~0,94 dtk/frame).
- Klip rakitan: `~/workspace/motion-studio/tmp/rife-full-s3/scene3-10s-60fps.mp4` — 9,98 dtk, 1080x1920, 60fps, 4,9 MB (599 frame: 300 asli + 299 tengah).
- QA visual frame t=5 (`qa_t5.png`): tangan, ikan di atas panggangan bambu, api, sungai utuh; gaya watercolor terjaga; tidak ada artefak meleleh.
- Langkah berikut (butuh penilaian owner): bandingkan adegan 3 v3 ini vs v2, baru putuskan lanjut ke 5 adegan lain atau tidak; suara Tone.js tetap langkah 3 dan belum terverifikasi.

## Langkah trial (berurutan, satu run satu langkah)

1. **Smoke test gerak (5 menit):** adegan 3, 3 detik (t=0–3), 30->60fps
   di 288x512, upscale + gabung ke klip v2, QA frame: cek artefak
   di asap/api (area gerak non-rigid paling rawan meleleh).
2. **Kalau lolos:** adegan 3 penuh 10 detik, cara yang sama.
3. **Suara Tone.js (langkah 2, BELUM terverifikasi):** sketch crackle api +
   desis (sizzle) pakai Tone.js NoiseSynth, render offline ke wav,
   gantikan stem `kerja/fire.wav` + `kerja/sizzle.wav` di adegan 3 saja.
   Catatan: Tone.js di Node butuh OfflineAudioContext — verifikasi dulu
   sebelum janji; fallback tetap ffmpeg seperti v2.
4. **Keputusan owner:** bandingkan v2 vs v3 adegan 3, baru putuskan lanjut
   ke 5 adegan lain atau tidak.

## Yang TIDAK dilakukan di trial ini

- Tidak pakai MusicGen (masih gagal install; jalurnya nunggu owner).
- Tidak pakai Kling/fal.ai (diparkir atas keputusan owner 23 Nov).
- Tidak posting apa pun; tidak buat Page baru; pilot tetap menunggu
  penilaian owner atas v2.

## Perintah kunci

- Ekstrak frame: `ffmpeg -ss <t> -i kerja/kb3.mp4 -frames:v 1 -vf scale=288:512 f.png`
- Inferensi: `~/workspace/motion-studio/venv/bin/python test_rife_pilot.py`
  (script di `~/workspace/motion-studio/tmp/rife-pilot-test/`)
- Model: `~/workspace/motion-studio/rife/train_log` (v4 HD, 12 MB)
