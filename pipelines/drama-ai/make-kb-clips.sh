#!/bin/bash
# Buat klip Ken Burns 720x1280 25fps dari 4 gambar adegan (zoompan, zoom 1.0 -> 1.15).
# Dijalankan dari ~/workspace/kanal-clipper/drama-ai/ep08/kerja/
# Timeline KB Ep 8: adegan1 0–17.04 | adegan2 17.04–37.61 | adegan3 37.61–52.92 | adegan4 52.92–59.14
set -e
cd "$(dirname "$0")"
mk_kb() { # $1=input jpg $2=output mp4 $3=durasi dtk $4=jumlah frame
  ffmpeg -y -v error -loop 1 -i "$1" -vf \
    "zoompan=z='1+0.15*on/$4':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$4:s=720x1280:fps=25" \
    -t "$3" -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -an "$2"
}
mk_kb adegan1.jpg kb1.mp4 17.04 426
mk_kb adegan2.jpg kb2.mp4 20.57 514
mk_kb adegan3.jpg kb3.mp4 15.31 383
mk_kb adegan4.jpg kb4.mp4 6.22 155
for f in kb1.mp4 kb2.mp4 kb3.mp4 kb4.mp4; do
  echo "$f: $(ffprobe -v error -show_entries format=duration -of default=nw=1 $f)"
done
