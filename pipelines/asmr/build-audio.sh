#!/bin/bash
# Lanjutan build pilot ASMR — stem 4-6 (TANPA aevalsrc; aevalsrc gagal parse di lavfi),
# lalu mix + assemble. KB clips + water/fire/sizzle sudah jadi dari build.sh.
# Dijalankan dari ~/workspace/asmr-nusantara/pilot-ikan-bakar/kerja/
set -e
cd "$(dirname "$0")"
OUT=..
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

echo "== Stem 4: ulek sambal (dentum ritmis sine+tremolo + gesekan) =="
ffmpeg -y -v error -f lavfi -i "sine=frequency=95:duration=9.2:sample_rate=48000" \
  -f lavfi -i "anoisesrc=color=pink:duration=9.2:amplitude=0.5" -filter_complex \
  "[0:a]tremolo=f=1.39:d=1.0,agate=threshold=-20dB:ratio=20:attack=1:release=120,lowpass=f=300,volume=1.8,aformat=sample_rates=48000:channel_layouts=stereo[thud]; \
   [1:a]bandpass=f=900:w=600,tremolo=f=1.39:d=0.85,volume=0.8,aformat=sample_rates=48000:channel_layouts=stereo[scrape]; \
   [thud][scrape]amix=inputs=2:normalize=0,afade=t=in:st=0:d=0.8,afade=t=out:st=8.4:d=0.8[grind]" \
  -map "[grind]" -c:a pcm_s16le -ar 48000 grind.wav
echo "== Stem 5: saji (uap tipis) + ketukan lembut =="
ffmpeg -y -v error -f lavfi -i "anoisesrc=color=white:duration=9.2:amplitude=0.4" -filter_complex \
  "[0:a]highpass=f=5000,volume=0.05,afade=t=in:st=0:d=0.8,afade=t=out:st=8.4:d=0.8,aformat=sample_rates=48000:channel_layouts=stereo[plate]" \
  -map "[plate]" -c:a pcm_s16le -ar 48000 plate.wav
ffmpeg -y -v error -f lavfi -i "sine=frequency=80:duration=0.6:sample_rate=48000" -filter_complex \
  "[0:a]afade=t=out:st=0:d=0.45,volume=0.5,aformat=sample_rates=48000:channel_layouts=stereo[thunk]" \
  -map "[thunk]" -c:a pcm_s16le -ar 48000 thunk.wav
echo "== Stem 6: celup (blip lembut) =="
ffmpeg -y -v error -f lavfi -i "sine=frequency=140:duration=1.2:sample_rate=48000" -filter_complex \
  "[0:a]afade=t=out:st=0.15:d=0.9,volume=0.6,aformat=sample_rates=48000:channel_layouts=stereo[dip]" \
  -map "[dip]" -c:a pcm_s16le -ar 48000 dip.wav
for f in grind.wav plate.wav thunk.wav dip.wav; do
  echo "$f: $(ffprobe -v error -show_entries format=duration -of default=nw=1 "$f") $(ffmpeg -v info -i "$f" -af volumedetect -vn -sn -dn -f null /dev/null 2>&1 | grep -E 'mean_volume|max_volume' | tr '\n' ' ')"
done

echo "== Mix audio 58 dtk (7 input) =="
ffmpeg -y -v error -i water.wav -i fire.wav -i sizzle.wav -i grind.wav -i plate.wav -i thunk.wav -i dip.wav -filter_complex \
  "[1:a]adelay=18400:all=1[fire_d];[2:a]adelay=18400:all=1[siz_d];[3:a]adelay=28600:all=1[grind_d]; \
   [4:a]adelay=37800:all=1[plate_d];[5:a]adelay=38500:all=1[thunk_d];[6:a]adelay=49000:all=1[dip_d]; \
   [0:a][fire_d][siz_d][grind_d][plate_d][thunk_d][dip_d]amix=inputs=7:normalize=0,volume=0.7[mix]" \
  -map "[mix]" -c:a pcm_s16le -ar 48000 mix.wav
echo "mix: $(ffprobe -v error -show_entries format=duration -of default=nw=1 mix.wav) $(ffmpeg -v info -i mix.wav -af volumedetect -vn -sn -dn -f null /dev/null 2>&1 | grep -E 'mean_volume|max_volume' | tr '\n' ' ')"

echo "== Assemble video + audio =="
ffmpeg -y -v error -i kb1.mp4 -i kb2.mp4 -i kb3.mp4 -i kb4.mp4 -i kb5.mp4 -i kb6.mp4 -i mix.wav -filter_complex \
  "[0:v][1:v]xfade=transition=fade:duration=0.8:offset=9.2[x1]; \
   [x1][2:v]xfade=transition=fade:duration=0.8:offset=18.4[x2]; \
   [x2][3:v]xfade=transition=fade:duration=0.8:offset=28.6[x3]; \
   [x3][4:v]xfade=transition=fade:duration=0.8:offset=37.8[x4]; \
   [x4][5:v]xfade=transition=fade:duration=0.8:offset=47.0[x5]; \
   [x5]drawtext=fontfile=$FONT:text='IKAN BAKAR':fontsize=64:fontcolor=white:borderw=2:bordercolor=black:x=(w-tw)/2:y=620:enable='between(t,0,3.5)', \
   drawtext=fontfile=$FONT:text='& SAMBAL TERASI':fontsize=44:fontcolor=white:borderw=2:bordercolor=black:x=(w-tw)/2:y=710:enable='between(t,0,3.5)'[v]; \
   [6:a]loudnorm=I=-14:TP=-1.5:LRA=11[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 192k -movflags +faststart -shortest \
  "$OUT/video-final.mp4"
echo "== Final =="
ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate -show_entries format=duration,size -of default=nw=1 "$OUT/video-final.mp4"
ffmpeg -v info -i "$OUT/video-final.mp4" -af loudnorm=print_format=json -f null - 2>&1 | grep -A 12 "Parsed_loudnorm"
echo DONE
