#!/usr/bin/env python3
"""Render 5 vertical clips from source.mp4 for About GTA VI (Facebook Reels).
Layout: 1080x1920, blurred bg fill, 1080x608 video centered (y=656),
title top, Indonesian captions bottom, watermark 'About GTA VI' top-right.
Captions translated from the English transcript; timings = English segment
times (relative to clip start). *word* = yellow highlight.
"""
import os, subprocess, sys

FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

# (start_abs, end_abs, text) -- text may contain \N line breaks and *highlight*
CLIPS = [
    dict(slug="curi-untuk-mama", start=0.0, end=46.5,
         title="CURI DI GTA 6\\NBUAT MAMA",
         caps=[
            (0.0, 5.1, "Setiap dolar yang dicuri\\Ndi GTA 6, buat *Mama*"),
            (7.4, 9.6, "Timer satu jam dimulai!"),
            (11.8, 13.1, "Ini semua demi *Mama*"),
            (13.5, 14.9, "Aku nggak peduli berapa pun"),
            (15.1, 17.7, "Nggak ada batas uangnya!"),
            (17.9, 20.4, "Aku mau *sejuta dolar!*"),
            (20.7, 21.3, "Harus fokus!"),
            (21.4, 22.3, "Aku curi mobil"),
            (22.5, 23.5, "Kita rampok pom bensin"),
            (23.7, 24.5, "Ini buat *Mama*"),
            (24.8, 29.6, "Mama bakal bilang apa\\Nkalau nonton ini?"),
            (30.6, 34.2, "Mamaku orangnya berprinsip\\NDia nggak bakal senang"),
            (35.1, 36.2, "Kasih semua uangmu!"),
            (36.7, 39.7, "Ma, jangan nonton bagian ini\\NTonton pas aku dapat uangnya"),
            (40.8, 42.4, "Mama dapat *sembilan dolar!*"),
            (42.6, 44.0, "Bisa beli tas besar!"),
            (45.1, 45.8, "Oh, *dua ratus dolar!*"),
         ]),
    dict(slug="rampok-perhiasan-5000", start=109.0, end=184.0,
         title="RAMPOK PERHIASAN\\N$5.000",
         caps=[
            (109.8, 110.5, "Toko perhiasan?"),
            (111.6, 113.2, "Ayo, kita gas!"),
            (118.7, 121.0, "Banyak orang, banyak saksi..."),
            (122.5, 124.8, "Maaf ya, Bu\\NKasih semua uangnya!"),
            (126.5, 129.4, "Kami cuma mau uangnya\\Nbuat *Mama*"),
            (131.0, 132.1, "Cuma *120 dolar?*"),
            (135.3, 137.4, "Semua tiarap!"),
            (142.0, 144.0, "*500 dolar* perhiasan...\\N*600 dolar...*"),
            (145.4, 147.5, "Ambil semua, ambil semua!"),
            (149.6, 150.5, "Aku ambil semuanya!"),
            (153.3, 154.9, "Cepat, cepat!\\N*Seribu dolar!*"),
            (159.5, 160.6, "Polisi datang!"),
            (161.2, 164.2, "Seberapa serakah kita\\Ndemi Mama? *Sangat serakah!*"),
            (164.5, 166.0, "*4.000 dolar* buatku!"),
            (168.7, 171.6, "Perhiasan *5.000 dolar*\\Ntapi polisi nungguin"),
            (175.4, 178.1, "Maaf ya, Pak, minggir dulu!"),
            (180.7, 183.8, "Perhiasan *5.000 dolar*\\Nplus tunai *400 dolar*"),
         ]),
    dict(slug="mati-lalu-comeback", start=422.0, end=497.0,
         title="MATI, TERUS\\NCOMEBACK!",
         caps=[
            (424.6, 426.4, "Ini brutal. Ini susah."),
            (426.5, 428.5, "*37 menit* lagi\\NKamu kehilangan semuanya"),
            (430.4, 432.9, "Semua orang suka\\Nkisah *comeback*"),
            (441.2, 444.1, "Gagal sekali, bangkit lagi\\NLakukan lagi!"),
            (445.5, 448.6, "Lima satpam?\\NHabisi semuanya!"),
            (456.1, 459.8, "Ada tiga lagi di belakang"),
            (470.1, 471.2, "Aku ambil uangnya"),
            (473.6, 474.6, "*120 dolar*"),
            (477.2, 479.4, "700... Kamu sudah *2.000?*"),
            (483.3, 485.5, "Kamu sudah *4.000!*\\NAku dapat semuanya kembali"),
            (491.6, 493.5, "Nggak ada brankas\\NItu ATM"),
            (495.6, 496.5, "Kamu dapat *5.000!*"),
         ]),
    dict(slug="bank-25000-peluang-30-persen", start=623.0, end=702.0,
         title="BANK $25.000\\NPELUANG 30%",
         caps=[
            (623.3, 626.4, "Mama, dia pakai *1.200 dolar*\\Nuangmu buat beli senapan"),
            (627.1, 630.4, "Jimmy, menurutmu aku bisa\\Nrampok bank ini?"),
            (630.8, 634.0, "Peluang suksesmu *30%*"),
            (635.7, 636.9, "Lebih baik dari nol"),
            (637.0, 639.3, "Kita lakukan ini, Jimmy!"),
            (649.8, 651.1, "Mereka bakal mulai menembak"),
            (657.1, 660.6, "Maaf! Aku menembak semuanya!\\NAku panik!"),
            (663.4, 666.8, "Pasang peledak?\\NAyo, lalu kabur"),
            (671.7, 675.2, "Di mana uangnya?\\NAda satpam!"),
            (684.7, 686.8, "Itu brankasnya!\\NPasang peledak!"),
            (688.5, 690.4, "Minggir! Jangan ledakin\\Ndirimu sendiri"),
            (692.9, 695.4, "Ada apa di dalam?\\NBerapa uangnya?"),
            (696.5, 698.3, "*2.000... 3.000...*\\N*11.000!*"),
            (699.0, 699.5, "Ayo, Ma! Ayo, Ma!"),
            (700.1, 701.5, "Kamu sudah *25.000 dolar!*"),
         ]),
    dict(slug="mama-dapat-44641", start=1205.0, end=1284.6,
         title="MAMA DAPAT\\N$44.641!",
         caps=[
            (1205.5, 1207.6, "Itu helikopter!\\NDia menembakiku!"),
            (1208.1, 1210.4, "*40 detik! 38 detik!*"),
            (1215.5, 1219.8, "Terbang ke atas!\\N*28 detik!*"),
            (1221.0, 1223.7, "Terbang ke atas!"),
            (1228.3, 1231.9, "Ini nyata!\\NTerbang ke atas!"),
            (1232.1, 1237.2, "Aku naik! Aku naik!\\NAku naik!"),
            (1239.7, 1242.5, "Aku naik! Ini nyata!\\NKita nggak bakal berhasil... Ayo!"),
            (1244.0, 1246.3, "*4, 3, 2, 1*"),
            (1250.8, 1255.7, "Nggak mungkin\\NIni beneran *100% nyata*"),
            (1257.0, 1259.9, "Kamu berhasil!\\N*44.000!*"),
            (1260.4, 1262.0, "Mama bakal kaget banget"),
            (1264.7, 1268.1, "Hai, Ma. Aku baru menangin\\N*44.000 dolar* buat Mama"),
            (1273.0, 1275.1, "Kamu anak terbaik\\NTerima kasih"),
            (1280.7, 1283.6, "Terima kasih banyak\\NAku sayang Mama"),
         ]),
]

def ass_time(t):
    t = max(0.0, t)
    h = int(t // 3600); m = int((t % 3600) // 60); s = t % 60
    return f"{h}:{m:02d}:{s:05.2f}"

def hl(text):
    # *word* -> yellow override, then back to white
    out = []
    on = False
    for part in text.split("*"):
        if on:
            out.append("{\\1c&H00FFFF&}" + part + "{\\1c&HFFFFFF&}")
        else:
            out.append(part)
        on = not on
    return "".join(out)

def write_ass(clip, path):
    lines = [
        "[Script Info]",
        "ScriptType: v4.00+",
        "PlayResX: 1080",
        "PlayResY: 1920",
        "ScaledBorderAndShadow: yes",
        "",
        "[V4+ Styles]",
        "Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding",
        "Style: Title,DejaVu Sans,76,&H00FFFFFF,&H000000FF,&H00000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,2,8,60,60,110,1",
        "Style: Cap,DejaVu Sans,60,&H00FFFFFF,&H000000FF,&H00000000,&H80000000,-1,0,0,0,100,100,0,0,1,2.5,1,2,70,70,100,1",
        "",
        "[Events]",
        "Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text",
        f"Dialogue: 0,0:00:00.00,{ass_time(clip['end']-clip['start'])},Title,,0,0,0,,{hl(clip['title'])}",
    ]
    for (s, e, txt) in clip["caps"]:
        lines.append(f"Dialogue: 0,{ass_time(s-clip['start'])},{ass_time(e-clip['start'])},Cap,,0,0,0,,{hl(txt)}")
    open(path, "w").write("\n".join(lines) + "\n")

def render(i, clip):
    ass = f"clip{i}.ass"
    write_ass(clip, ass)
    out = f"clip_{i}_{clip['slug']}.mp4"
    s, e = clip["start"], clip["end"]
    fc = (
        f"[0:v]trim=start={s}:end={e},setpts=PTS-STARTPTS,fps=30,split[a][b];"
        f"[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,"
        f"gblur=sigma=35,eq=brightness=-0.3:saturation=0.9[bg];"
        f"[b]scale=1080:608[fg];"
        f"[bg][fg]overlay=(W-w)/2:656,ass={ass}[v0];"
        f"[v0]drawtext=fontfile={FONT}:text='About GTA VI':fontsize=34:"
        f"fontcolor=white@0.6:borderw=1:bordercolor=black@0.6:x=w-tw-40:y=36[vout];"
        f"[vout]drawtext=fontfile={FONT}:text='Klip\\: @mrbeastgaming':fontsize=30:"
        f"fontcolor=white@0.75:borderw=1:bordercolor=black@0.6:x=(w-tw)/2:y=320[vout2];"
        f"[0:a]atrim=start={s}:end={e},asetpts=PTS-STARTPTS,"
        f"loudnorm=I=-14:TP=-1.5:LRA=11,aresample=48000[aout]"
    )
    cmd = ["ffmpeg", "-v", "error", "-y", "-i", "source.mp4",
           "-filter_complex", fc,
           "-map", "[vout2]", "-map", "[aout]",
           "-c:v", "libx264", "-preset", "medium", "-profile:v", "high",
           "-pix_fmt", "yuv420p", "-r", "30",
           "-c:a", "aac", "-b:a", "192k", "-movflags", "+faststart", out]
    print(f"--- clip {i} {clip['slug']} {s}-{e} ({e-s:.1f}s) -> {out}", flush=True)
    r = subprocess.run(cmd)
    if r.returncode != 0:
        print(f"!!! clip {i} FAILED rc={r.returncode}", flush=True)
        sys.exit(1)
    print(f"--- clip {i} done", flush=True)

if __name__ == "__main__":
    only = [int(x) for x in sys.argv[1:]] or None
    for i, clip in enumerate(CLIPS, 1):
        if only and i not in only:
            continue
        render(i, clip)
    print("ALL DONE", flush=True)
