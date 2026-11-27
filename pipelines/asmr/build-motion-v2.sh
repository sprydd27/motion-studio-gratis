#!/bin/bash
# Perbaikan gerakan v2 — ASMR Nusantara pilot (ikan bakar + sambal terasi)
# ffmpeg SAJA (Wan 2.2 TIDAK bisa dipakai — lihat CATATAN.md "Perbaikan gerakan v2").
# Gambar sama (6 gambar AI v1), durasi total tetap 58 dtk, audio = audio v1 (disalin utuh).
# Koreografi per adegan: easing cosinus (bukan zoom linear), pan/drift berarah,
# sway halus, + secondary motion (ripple air, flicker api, bob ulek, uap).
# Dijalankan dari ~/workspace/asmr-nusantara/pilot-ikan-bakar/kerja/
set -e
cd "$(dirname "$0")"
IMG=../images
OUT=..
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

S1=$IMG/media-generation-scene1-stream-fish-0-aaa7e1c3-d037-460f-be1e-7938f6536dbb.webp
S2=$IMG/media-generation-scene2-spice-rub-0-380b1f1d-cf02-43cf-b6d9-ee19ae827b4b.webp
S3=$IMG/media-generation-scene3-grill-fire-0-0a918d43-ba5a-4aad-80d0-facd7aa7e851.webp
S4=$IMG/media-generation-scene4-sambal-cobek-0-cb45888c-ff35-4dd4-a9e2-c7d4982d354f.webp
S5=$IMG/media-generation-scene5-plating-0-024ee673-aea8-4147-9deb-3681813166e4.webp
S6=$IMG/media-generation-scene6-dip-taste-0-2e0584fd-7ff1-4765-a534-9ef5084b9fba.webp

echo "== Audio v1 (disalin utuh, tidak di-mix ulang) =="
ffmpeg -y -v error -i "$OUT/video-final.mp4" -vn -c:a copy audio-v1.m4a
ffprobe -v error -show_entries format=duration -of default=nw=1 audio-v1.m4a

echo "== Peta ripple air S1 (10 dtk) =="
ffmpeg -y -v error -f lavfi -i "nullsrc=s=270x480:d=10,geq=r='128+5*exp(-pow((Y-262)/100,2))*sin((X-T*10)/9)':g='128+4*exp(-pow((Y-262)/100,2))*sin((Y-T*6)/11)':b='128',scale=1080:1920,fps=30" \
  -c:v libx264 -pix_fmt yuv420p -r 30 map-s1.mp4

echo "== S1 sungai 10 dtk: push-in + drift + ripple air =="
ffmpeg -y -v error -loop 1 -i "$S1" -i map-s1.mp4 -filter_complex \
  "[0:v]zoompan=z='1+0.10*(1-cos(PI*on/300))/2':x='iw/2-(iw/zoom/2)+30*(1-cos(PI*on/300))/2':y='ih/2-(ih/zoom/2)+60*(1-cos(PI*on/300))/2':d=300:s=1080x1920:fps=30[kb];[1:v]format=rgb24,split=2[mx][my];[mx]extractplanes=r[xm];[my]extractplanes=g[ym];[kb][xm][ym]displace=edge=smear[v]" \
  -map "[v]" -t 10 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb1v2.mp4

echo "== S2 bumbu 10 dtk: zoom-in + sway melingkar (gosok) =="
ffmpeg -y -v error -loop 1 -i "$S2" -vf \
  "zoompan=z='1.06+0.06*(1-cos(PI*on/300))/2':x='iw/2-(iw/zoom/2)+15*(1-cos(PI*on/300))/2*sin(2*PI*on/300*2)':y='ih/2-(ih/zoom/2)+12*(1-cos(PI*on/300))/2*cos(2*PI*on/300*2)':d=300:s=1080x1920:fps=30" \
  -t 10 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb2v2.mp4

echo "== S3 bakar 11 dtk: zoom-out + flicker api =="
ffmpeg -y -v error -loop 1 -i "$S3" -vf \
  "zoompan=z='1.10-0.08*(1-cos(PI*on/330))/2':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=330:s=1080x1920:fps=30,eq=eval=frame:brightness='0.03*sin(2*PI*t/2.3)+0.02*sin(2*PI*t/0.7)'" \
  -t 11 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb3v2.mp4

echo "== S4 sambal 10 dtk: zoom-in + bob ritmis ulek 0.72 dtk =="
ffmpeg -y -v error -loop 1 -i "$S4" -vf \
  "zoompan=z='1+0.08*(1-cos(PI*on/300))/2':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=300:s=1080x1920:fps=30,scale=1104:1966,crop=1080:1920:x='(in_w-out_w)/2':y='(in_h-out_h)/2+3*sin(2*PI*t/0.72)'" \
  -t 10 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb4v2.mp4

echo "== S5 saji 10 dtk: pan naik + uap =="
ffmpeg -y -v error -loop 1 -i "$S5" \
  -f lavfi -i "nullsrc=s=270x480:d=10,geq=lum='128+70*sin(X/22)*sin((Y-T*14)/26)',gblur=sigma=12,scale=1080:1920,fps=30,format=rgba,colorchannelmixer=aa=0.05" \
  -filter_complex "[0:v]zoompan=z='1+0.06*(1-cos(PI*on/300))/2':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)-50*(1-cos(PI*on/300))/2':d=300:s=1080x1920:fps=30[kb];[kb][1:v]overlay=0:0[v]" \
  -map "[v]" -t 10 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb5v2.mp4

echo "== S6 celup 11 dtk: push-in ke mangkok + sway halus =="
ffmpeg -y -v error -loop 1 -i "$S6" -vf \
  "zoompan=z='1+0.12*(1-cos(PI*on/330))/2':x='iw/2-(iw/zoom/2)+20*(1-cos(PI*on/330))/2+12*(1-cos(PI*on/330))/2*sin(2*PI*on/330)':y='ih/2-(ih/zoom/2)+70*(1-cos(PI*on/330))/2+10*(1-cos(PI*on/330))/2*cos(2*PI*on/330)':d=330:s=1080x1920:fps=30" \
  -t 11 -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an kb6v2.mp4

for f in kb?v2.mp4; do echo "$f: $(ffprobe -v error -show_entries format=duration -of default=nw=1 "$f")"; done

echo "== Assemble v2 (xfade 0.8 dtk, judul, audio v1 disalin) =="
ffmpeg -y -v error -i kb1v2.mp4 -i kb2v2.mp4 -i kb3v2.mp4 -i kb4v2.mp4 -i kb5v2.mp4 -i kb6v2.mp4 -i audio-v1.m4a -filter_complex \
  "[0:v][1:v]xfade=transition=fade:duration=0.8:offset=9.2[x1]; \
   [x1][2:v]xfade=transition=fade:duration=0.8:offset=18.4[x2]; \
   [x2][3:v]xfade=transition=fade:duration=0.8:offset=28.6[x3]; \
   [x3][4:v]xfade=transition=fade:duration=0.8:offset=37.8[x4]; \
   [x4][5:v]xfade=transition=fade:duration=0.8:offset=47.0[x5]; \
   [x5]drawtext=fontfile=$FONT:text='IKAN BAKAR':fontsize=64:fontcolor=white:borderw=2:bordercolor=black:x=(w-tw)/2:y=620:enable='between(t,0,3.5)', \
   drawtext=fontfile=$FONT:text='& SAMBAL TERASI':fontsize=44:fontcolor=white:borderw=2:bordercolor=black:x=(w-tw)/2:y=710:enable='between(t,0,3.5)'[v]" \
  -map "[v]" -map 6:a -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -c:a copy -movflags +faststart -shortest \
  "$OUT/video-final-v2.mp4"

echo "== Final v2 =="
ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate -show_entries format=duration,size -of default=nw=1 "$OUT/video-final-v2.mp4"
ffmpeg -v error -i "$OUT/video-final-v2.mp4" -af loudnorm=print_format=json -f null - 2>&1 | tail -12
echo DONE-V2
