#!/bin/bash
# Assemble video-final-kenburns.mp4 Ep 8 (cadangan Ken Burns-only).
# Dijalankan dari ~/workspace/kanal-clipper/drama-ai/ep08/kerja/
# Timeline KB: adegan1 0–17.04 | adegan2 17.04–37.61 | adegan3 37.61–52.92 | adegan4 52.92–59.14
set -e
cd "$(dirname "$0")"
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
FONT_R=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf

# Potong irisan klip sesuai timeline (re-encode supaya -ss/-t akurat sampai frame).
ffmpeg -y -v error -i kb1.mp4 -t 17.04 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -an seg1.mp4
ffmpeg -y -v error -i kb2.mp4 -t 20.57 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -an seg2.mp4
ffmpeg -y -v error -i kb3.mp4 -t 15.31 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -an seg3.mp4
ffmpeg -y -v error -i kb4.mp4 -t 6.22 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -an seg4.mp4
printf "file 'seg1.mp4'\nfile 'seg2.mp4'\nfile 'seg3.mp4'\nfile 'seg4.mp4'\n" > concat-kb.txt
ffmpeg -y -v error -f concat -safe 0 -i concat-kb.txt -c copy concat-kb.mp4

# Render akhir: subtitle ASS + judul + ILUSTRASI + BERSAMBUNG + VO
ffmpeg -y -v error -i concat-kb.mp4 -i ../vo-narasi.mp3 -filter_complex \
"[0:v]ass=subtitle.ass,drawtext=fontfile=$FONT:text='WARISAN ASLI DI RUMAH IBU':fontsize=40:fontcolor=\#F5C518:borderw=2:bordercolor=black:x=(w-text_w)/2:y=130:enable='between(t,0,3)',drawtext=fontfile=$FONT_R:text='ILUSTRASI':fontsize=20:fontcolor=white@0.8:x=20:y=20,drawtext=fontfile=$FONT:text='BERSAMBUNG':fontsize=72:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.42:enable='between(t,57.14,59.14)'[v]" \
-map "[v]" -map 1:a -c:v libx264 -crf 18 -pix_fmt yuv420p -r 25 -c:a aac -b:a 128k -shortest \
../video-final-kenburns.mp4
echo "OK: $(ffprobe -v error -show_entries stream=width,height,codec_name -show_entries format=duration -of default=nw=1 ../video-final-kenburns.mp4)"
