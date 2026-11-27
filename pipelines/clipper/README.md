# Clipper — video panjang jadi klip vertikal

Pipeline buat motong video panjang (mis. YouTube) jadi klip vertikal 1080x1920
siap Reels: transkrip (faster-whisper) → pilih segmen → render ffmpeg
(caption .ass dua baris, judul di layar, watermark, kredit on-screen).

## Syarat

- Python 3.12 venv: yt-dlp, faster-whisper, av==15.1.0
- ffmpeg 8+
- Font DejaVu Sans (atau ganti FONT di skrip)

## File

- `transcribe.py` — transkrip video jadi segmen + timestamp
- `build_clips_video01.py`, `build_clips_video02.py` — contoh konfigurasi
  per video (segmen, judul, caption). Sesuaikan VIDEO_ID, segmen, dan teks
  sebelum dipakai buat video lain.

## Aturan hak (penting)

Motong video orang lain bukan berarti boleh tayang. Tetapkan dulu dasar hak
(`skills/third_party_footage_rights_gate/SKILL.md`): izin creator, clipping
campaign, klip resmi platform + kredit di layar dan deskripsi, atau gameplay
sendiri. Satu klip yang disetujui tidak berlaku buat klip lain dari sumber
yang sama.
