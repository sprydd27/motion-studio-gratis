# HyperFrames — Setup (23 Nov 2026)

Framework render video open-source dari HeyGen: tulis HTML, render jadi video.
Repo: https://github.com/heygen-com/hyperframes — Docs: https://hyperframes.heygen.com/introduction

## Yang terinstall

| Komponen | Versi / lokasi |
|---|---|
| HyperFrames CLI | 0.9.85 (via `npx hyperframes`, tanpa clone repo) |
| Chrome Headless Shell (render) | 158.0.8127.36 — `~/.cache/hyperframes/chrome/chrome-headless-shell/linux-158.0.8127.36/chrome-headless-shell-linux64/chrome-headless-shell` |
| Node.js | v24.22.1 |
| bun | 1.4.4 |
| ffmpeg / ffprobe | 8.1.2 (`/usr/bin/ffmpeg`) |
| Core skills (6) | `~/.claude/skills/` + `~/.agents/skills/` — disalin ke `~/workspace/custom-skills/` supaya ditemukan skill_search: `hyperframes` (entry/router), `hyperframes-cli`, `hyperframes-registry`, `media-use`, `reverse-any-video`, `style-sampling` |

Verifikasi: `skill_search "hyperframes"` menemukan `hyperframes`, `hyperframes-cli`, `hyperframes-registry`, `media-use`.

## Perubahan izin (diperlukan installer browser)

`npx hyperframes browser ensure` menolak `~/.cache` dan `/home/hatch` yang group-writable.
Yang dilakukan: `chmod go-w ~/.cache` dan `chmod go-w /home/hatch` (sekarang `drwxr-x---`).
Hanya menghapus group/other write; akses owner tidak berubah.

## Perintah dasar

```bash
cd ~/workspace/gta6-channel/hyperframes

npx hyperframes init --example blank --resolution portrait --non-interactive --skip-skills <nama-proyek>
npx hyperframes lint            # cek struktur HTML (di dalam folder proyek)
npm run check                   # lint + runtime + layout + motion + contrast
npx hyperframes snapshot --at 1,3,5   # lihat frame PNG sebelum render
npx hyperframes render -o renders/out.mp4 -w 1   # render MP4
npx hyperframes skills update   # refresh core skills (JANGAN dari dalam clone repo hyperframes)
npx hyperframes doctor          # cek prasyarat
```

**Penting — /tmp cuma 0,5 GB bebas:** render gagal dengan "Low disk space" kalau pakai /tmp.
Selalu render dengan cache dialihkan ke workspace:

```bash
export TMPDIR=~/workspace/gta6-channel/hyperframes/.cache/tmp
export HYPERFRAMES_EXTRACT_CACHE_DIR=~/workspace/gta6-channel/hyperframes/.cache/extract
npx hyperframes render -o renders/out.mp4 -w 1 --frames-cache-dir ~/workspace/gta6-channel/hyperframes/.cache/extract
```

Pakai `-w 1` (satu worker Chrome) karena RAM bebas tinggal ~1,1 GB (peringatan doctor).
Aturan komposisi (dari CLAUDE.md): file HTML dengan atribut `data-*`, clip pakai `class="clip"`,
satu paused GSAP root timeline per komposisi di `window.__timelines`, rendering harus
deterministik (tanpa `Date.now()` / `Math.random` tanpa seed / fetch saat render).
Validasi `lint` + `check` harus lolos sebelum render.

## Smoke test (berhasil)

Proyek: `smoke-test/` (template blank portrait 1080x1920, 10 dtk, judul fade+scale via GSAP).
- `npm run check`: PASSED — 0 error, 2 warning craft template kosong (first_frame_empty, dead_stretch), 1 info (tanpa audio).
- Render: `smoke-test/renders/smoke-test.mp4` — 10,0 dtk, 1080x1920, H.264, 51,1 KB, render 24 dtk (300 frame, 1 worker, software GPU).

## Komponen GTA (echris6/gta-components)

Lokasi: `~/workspace/gta6-channel/hyperframes/gta-components/` (git clone --depth 1, 23 Nov 2026)
Repo: https://github.com/echris6/gta-components — 126 komponen motion-graphics GTA sebagai kode
(HyperFrames + GSAP + Three.js): 76 long-form (masing-masing ada versi 16:9 `long-form/` dan 9:16
`shorts/`) + 50 Shorts-only di `shorts/`. Mencakup captions, counters, wheels, maps, HUDs,
title stings, comparison splits (daftar lengkap di `components.json`).

Struktur per komponen: `components/NN-slug/{long-form,shorts}/index.html` + `README.md` + `DECISIONS.md`.
`shared/fonts`, `shared/kit` (font + look/motion kit), `showcase/` (galeri), `docs/` (design guide +
brief BUILDER/CRITIC).

Cara pakai (dari README repo):
- Tiap komponen satu proyek HyperFrames kecil: satu file HTML + CSS + timeline GSAP.
- Variabel (teks, angka, varian) lewat `data-composition-variables` di atas `index.html`.
- Overlay: render dengan `--variables '{"bg":"none"}'` untuk file transparan, lalu composite di editor.
- Footage TIDAK termasuk: `assets/shots/`, `assets/plates/`, `assets/clips/` kosong — isi dengan
  klip sendiri (nama file sesuai yang direferensikan `index.html`) atau pakai overlay transparan.
- Long-form pin `hyperframes@0.9.72`; Shorts-only pin `hyperframes@0.8.162` (CLI terinstall 0.9.85).
- Lisensi kode MIT; font SIL OFL; GTA merek dagang Take-Two, proyek tidak berafiliasi dengan Rockstar,
  tanpa footage/logo/typeface Rockstar.

**DISETUJUI owner 23 Nov 19:24 WIB:** `setup.sh` boleh dijalankan tiap kali komponen pertama
dipakai. Isinya sudah dibaca: hanya `cp -R` shared fonts/kit ke `assets/` komponen +
`mkdir -p` folder footage kosong — tidak ada download/install/eksekusi lain. Cara pakai:
`./setup.sh components/38-spin-wheel/long-form` (atau `shorts/27-podium-3d` untuk Shorts).
Jangan jalankan perintah git atau build/test lain di dalam folder `gta-components/` tanpa izin.

## Yang belum terinstall (opsional, tidak dibutuhkan untuk render dasar)

- whisper-cpp (transkripsi), TTS Kokoro, BGM MusicGen, Docker — semuanya opsional menurut doctor.
  Install hanya kalau ada kebutuhan transkripsi/TTS/musik lokal.

## Yang masih butuh owner

1. Tidak ada login/pembayaran yang dibutuhkan HyperFrames sendiri.
2. `setup.sh` sudah disetujui owner (23 Nov 19:24 WIB) — lihat catatan di atas.
