---
name: motion-design-toolkit
description: 11 pustaka motion design berbasis kode (tanpa After Effects) untuk dipakai bersama Muse — animasi, partikel, 3D kecil, morphing, kamera timeline, visual beat, fluida, shader, dan render MP4. Dipakai saat butuh gerakan yang lebih hidup dari Ken Burns, mis. perbaikan animasi klip ASMR Nusantara atau Layar Cerita.
---

# Motion Design Toolkit

Sumber: postingan X @okapi_fukugyo, 23 Nov 2026 — https://x.com/okapi_fukugyo/status/2124626774902620365
("Museでモーションデザインをやるなら、この11駅を回ればいい。After Effectsを開かなくても、ここまで作れる。全部GitHubで公開。Museで動作確認済み.")
Postingan itu BUKAN satu file skill — isinya daftar 11 pustaka di bawah. Skill ini menyimpan daftar + repo resminya (semua URL t.co sudah diverifikasi mengarah ke repo di bawah).

## Daftar pustaka

| # | Pustaka | Repo | Buat apa |
|---|---------|------|----------|
| 01 | Motion Canvas | https://github.com/motion-canvas/motion-canvas | Animasi ditulis dengan kode, bukan keyframe |
| 02 | Lottie | https://github.com/airbnb/lottie-web | Memutar animasi After Effects langsung di Web |
| 03 | tsParticles | https://github.com/tsparticles/tsparticles | Confetti, percikan, salju |
| 04 | Rough.js | https://github.com/rough-stuff/rough | Gaya gambar tangan (hand-drawn) |
| 05 | Zdog | https://github.com/metafizzy/zdog | 3D kecil bergaya ilustrasi |
| 06 | Flubber | https://github.com/veltman/flubber | Morphing halus antara dua bentuk |
| 07 | Theatre.js | https://github.com/theatre-js/theatre | Menggerakkan kamera dengan timeline sungguhan |
| 08 | Hydra | https://github.com/hydra-synth/hydra | Visual yang bergerak mengikuti beat |
| 09 | WebGL Fluid | https://github.com/PavelDoGreat/WebGL-Fluid-Simulation | Asap dan tinta yang benar-benar mengalir |
| 10 | LYGIA | https://github.com/patriciogonzalezvivo/lygia | Koleksi shader besar yang bisa dipakai ulang |
| 11 | Remotion | https://github.com/remotion-dev/remotion | Menggabungkan semuanya menjadi file MP4 |

Lisensi: LYGIA gratis untuk non-komersial; Remotion gratis untuk tim sampai 3 orang.

## Kapan pakai yang mana

- **Gerakan kamera / timeline (ganti Ken Burns):** Theatre.js atau Motion Canvas — kamera bergerak mengikuti kurva timeline, bukan sekadar zoom in/out.
- **Render akhir jadi MP4:** Remotion — skill Remotion SUDAH terinstall di `~/workspace/custom-skills/remotion-video/` (v4.0.543); pakai itu dulu sebelum install ulang.
- **Asap / uap / tinta mengalir (adegan bakar, uap saji):** WebGL Fluid, shader dari LYGIA.
- **Partikel (percikan bara, uap, confetti):** tsParticles.
- **Transisi bentuk (morphing antar adegan):** Flubber.
- **Gaya gambar tangan / ilustrasi:** Rough.js, Zdog.
- **Visual ikut musik/beat:** Hydra.
- **Animasi siap pakai dari After Effects:** Lottie (lottie-web).

## Aturan pakai

- Install per-proyek via npm (`npm install <paket>`) saat dibutuhkan — jangan install semua sekaligus secara global.
- Cek lisensi tiap pustaka sebelum dipakai komersial (khususnya LYGIA non-komersial, Remotion tim >3 orang).
- Untuk konten kanal (Layar Cerita, ASMR Nusantara): gerakan harus lembut dan tenang — jangan pakai efek yang terlalu ramai. Prioritas: kamera timeline (Theatre.js/Motion Canvas) + fluida/partikel halus, render akhir via Remotion.
- Jangan pakai logo atau aset berhak cipta dari repo contoh; pakai pustakanya saja, gambar/aset tetap buatan sendiri.
