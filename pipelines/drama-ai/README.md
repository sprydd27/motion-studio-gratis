# Drama AI — episode vertikal (fallback Ken Burns)

Resep fallback kalau generator motion tidak tersedia: gambar adegan +
gerak kamera Ken Burns (zoom/pan) + subtitle .ass + VO.

## File

- `make-kb-clips.sh` — bikin klip Ken Burns per adegan dari gambar
- `assemble-kb.sh` — gabung klip + subtitle + audio jadi episode
- `segments.json` — contoh pembagian naskah per segmen (waktu + teks)
- `subtitle.ass` — contoh subtitle .ass (720x1280)

## Catatan

- Format target: 720x1280, ~60 detik, satu episode/hari 19:00 WIB.
- Hook di 1–3 detik pertama, satu ide jelas per episode, cliffhanger di akhir.
