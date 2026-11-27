# ASMR — animasi masak cozy storybook

Pipeline pilot ASMR (ikan bakar + sambal terasi, 58 detik, 1080x1920):
gambar AI → gerak kamera (Ken Burns) → efek ambient → suara ffmpeg.

## File

- `build.sh` — rakit 6 adegan dari gambar + gerak kamera dasar
- `build-audio.sh` — suara sintetis via ffmpeg (api, ulek, air, saji)
- `build-motion-v2.sh` — gerak kamera + efek ambient per adegan
  (ripple air, flicker api, ulek sinkron audio, uap naik)
- `rife-trial-v3.md` + `run_rife_3s.py` — trial interpolasi RIFE 30→60fps
  (adegan bakar, 3 detik, ~0,8 detik/frame di CPU)

## Catatan jujur

- Suara masih sintetis (ffmpeg). Sumber rekaman asli belum didapat.
- Gambar + kamera bergerak, tapi subjek (tangan/ikan) belum benar-benar
  bergerak — RIFE menghaluskan antar-frame, bukan menganimasikan subjek.
- Gambar, audio, dan video hasil TIDAK termasuk di repo (input produksi
  masing-masing).
