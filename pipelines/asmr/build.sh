#!/bin/bash
# Pilot ASMR Nusantara — Ikan Bakar + Sambal Terasi
# Gambar AI (storybook watercolor, 1152x2048) -> Ken Burns zoompan 1080x1920 30fps
# -> xfade 0.8s antar adegan -> judul di awal -> audio ASMR SINTESIS (ffmpeg)
# -> loudnorm -14 LUFS. Dijalankan dari ~/workspace/asmr-nusantara/pilot-ikan-bakar/kerja/
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

mk_kb() { # $1=input $2=output $3=durasi $4=frames $5=ekspresi zoom
  ffmpeg -y -v error -loop 1 -i "$1" -vf \
    "zoompan=z='$5':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$4:s=1080x1920:fps=30" \
    -t "$3" -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 -an "$2"
}
echo "== Ken Burns =="
mk_kb "$S1" kb1.mp4 10 300 "1+0.12*on/300"
mk_kb "$S2" kb2.mp4 10 300 "1.12-0.12*on/300"
mk_kb "$S3" kb3.mp4 11 330 "1+0.08*on/330"
mk_kb "$S4" kb4.mp4 10 300 "1+0.10*on/300"
mk_kb "$S5" kb5.mp4 10 300 "1.10-0.10*on/300"
mk_kb "$S6" kb6.mp4 11 330 "1+0.12*on/330"
for f in kb*.mp4; do echo "$f: $(ffprobe -v error -show_entries format=duration -of default=nw=1 "$f")"; done

echo "== Audio stems (SINTESIS ffmpeg — bukan rekaman lapangan) =="
# 1) Air sungai: bed kontinyu 58 dtk — brown noise lowpass + tremolo lambat + shimmer tipis
ffmpeg -y -v error -f lavfi -i "anoisesrc=color=brown:duration=58:amplitude=0.6" \
  -f lavfi -i "anoisesrc=color=pink:duration=58:amplitude=0.25" -filter_complex \
  "[0:a]lowpass=f=420,tremolo=f=0.11:d=0.35,volume=0.55,aformat=sample_rates=48000:channel_layouts=stereo[bed]; \
   [1:a]highpass=f=5200,volume=0.05,aformat=sample_rates=48000:channel_layouts=stereo[shim]; \
   [bed][shim]amix=inputs=2:normalize=0,afade=t=in:st=0:d=1.0,afade=t=out:st=56.5:d=1.5[water]" \
  -map "[water]" -c:a pcm_s16le -ar 48000 water.wav
# 2) Api: crackle (pink noise highpass + gate) + body hangat — 10.2 dtk (adegan 3)
ffmpeg -y -v error -f lavfi -i "anoisesrc=color=pink:duration=10.2:amplitude=0.7" \
  -f lavfi -i "anoisesrc=color=brown:duration=10.2:amplitude=0.5" -filter_complex \
  "[0:a]highpass=f=1500,agate=threshold=-30dB:ratio=15:attack=0.2:release=80,volume=0.8,aformat=sample_rates=48000:channel_layouts=stereo[crack]; \
   [1:a]lowpass=f=220,volume=0.5,aformat=sample_rates=48000:channel_layouts=stereo[body]; \
   [crack][body]amix=inputs=2:normalize=0,afade=t=in:st=0:d=0.8,afade=t=out:st=9.4:d=0.8[fire]" \
  -map "[fire]" -c:a pcm_s16le -ar 48000 fire.wav
# 3) Desis bakar (sizzle): white noise band 3.2–9.5 kHz + tremolo + pops — 10.2 dtk (adegan 3)
ffmpeg -y -v error -f lavfi -i "anoisesrc=color=white:duration=10.2:amplitude=0.5" \
  -f lavfi -i "anoisesrc=color=white:duration=10.2:amplitude=0.6" -filter_complex \
  "[0:a]highpass=f=3200,lowpass=f=9500,tremolo=f=6.5:d=0.35,compand=attacks=0.01:decays=0.05:points=-60/-60|-30/-18|-12/-10|0/-6,volume=0.5,aformat=sample_rates=48000:channel_layouts=stereo[hiss]; \
   [1:a]highpass=f=2000,agate=threshold=-24dB:ratio=20:attack=0.1:release=30,volume=0.35,aformat=sample_rates=48000:channel_layouts=stereo[pops]; \
   [hiss][pops]amix=inputs=2:normalize=0,afade=t=in:st=0:d=0.8,afade=t=out:st=9.4:d=0.8[siz]" \
  -map "[siz]" -c:a pcm_s16le -ar 48000 sizzle.wav
# 4) Ulek sambal: dentum ritmis 0.72 dtk + gesekan — 9.2 dtk (adegan 4)
ffmpeg -y -v error -f lavfi -i "aevalsrc='sin(2*PI*95*mod(t,0.72))*exp(-16*mod(t,0.72)):sin(2*PI*95*mod(t,0.72))*exp(-16*mod(t,0.72))':duration=9.2:sample_rate=48000" \
  -f lavfi -i "aevalsrc='(random(0)-0.5)*2*exp(-7*mod(t,0.72)):(random(0)-0.5)*2*exp(-7*mod(t,0.72))':duration=9.2:sample_rate=48000" -filter_complex \
  "[0:a]volume=0.9,aformat=sample_rates=48000:channel_layouts=stereo[thud]; \
   [1:a]lowpass=f=1400,volume=0.35,aformat=sample_rates=48000:channel_layouts=stereo[scrape]; \
   [thud][scrape]amix=inputs=2:normalize=0,afade=t=in:st=0:d=0.8,afade=t=out:st=8.4:d=0.8[grind]" \
  -map "[grind]" -c:a pcm_s16le -ar 48000 grind.wav
# 5) Saji: uap tipis + satu ketukan lembut di 0.7 dtk — 9.2 dtk (adegan 5)
ffmpeg -y -v error -f lavfi -i "anoisesrc=color=white:duration=9.2:amplitude=0.4" \
  -f lavfi -i "aevalsrc='if(gt(t,0.7),sin(2*PI*80*(t-0.7))*exp(-14*(t-0.7)),0):if(gt(t,0.7),sin(2*PI*80*(t-0.7))*exp(-14*(t-0.7)),0)':duration=9.2:sample_rate=48000" -filter_complex \
  "[0:a]highpass=f=5000,volume=0.05,aformat=sample_rates=48000:channel_layouts=stereo[steam]; \
   [1:a]volume=0.5,aformat=sample_rates=48000:channel_layouts=stereo[thunk]; \
   [steam][thunk]amix=inputs=2:normalize=0,afade=t=in:st=0:d=0.8,afade=t=out:st=8.4:d=0.8[plate]" \
  -map "[plate]" -c:a pcm_s16le -ar 48000 plate.wav
# 6) Celup: blip lembut 2 dtk, ditempatkan di t=49 (adegan 6)
ffmpeg -y -v error -f lavfi -i "aevalsrc='if(gt(t,0.2),sin(2*PI*140*(t-0.2))*exp(-10*(t-0.2)),0):if(gt(t,0.2),sin(2*PI*140*(t-0.2))*exp(-10*(t-0.2)),0)':duration=2:sample_rate=48000" \
  -filter_complex "[0:a]volume=0.6,afade=t=in:st=0:d=0.3,afade=t=out:st=1.2:d=0.8,aformat=sample_rates=48000:channel_layouts=stereo[dip]" \
  -map "[dip]" -c:a pcm_s16le -ar 48000 dip.wav
for f in water.wav fire.wav sizzle.wav grind.wav plate.wav dip.wav; do
  echo "$f: $(ffprobe -v error -show_entries format=duration -of default=nw=1 "$f") $(ffmpeg -v error -i "$f" -af volumedetect -f null - 2>&1 | grep -E 'mean_volume|max_volume' | tr '\n' ' ')"
done

echo "== Mix audio 58 dtk =="
ffmpeg -y -v error -i water.wav -i fire.wav -i sizzle.wav -i grind.wav -i plate.wav -i dip.wav -filter_complex \
  "[1:a]adelay=18400:all=1[fire_d];[2:a]adelay=18400:all=1[siz_d];[3:a]adelay=28600:all=1[grind_d]; \
   [4:a]adelay=37800:all=1[plate_d];[5:a]adelay=49000:all=1[dip_d]; \
   [0:a][fire_d][siz_d][grind_d][plate_d][dip_d]amix=inputs=6:normalize=0,volume=0.7[mix]" \
  -map "[mix]" -c:a pcm_s16le -ar 48000 mix.wav
echo "mix: $(ffprobe -v error -show_entries format=duration -of default=nw=1 mix.wav)"

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
ffmpeg -v error -i "$OUT/video-final.mp4" -af loudnorm=print_format=json -f null - 2>&1 | tail -12
echo DONE
