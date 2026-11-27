#!/usr/bin/env python3
"""Render 5 vertical clips from source.mp4 for About GTA VI (Facebook Reels).
Layout: 1080x1920, blurred bg fill, 1080x608 video centered (y=656),
title top, Indonesian captions bottom, watermark 'About GTA VI' top-right.
Captions translated from the English transcript; timings = English segment
times (relative to clip start). *word* = yellow highlight.
Same pipeline as video01 (build_clips.py there).
"""
import subprocess, sys

FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

# (start_abs, end_abs, text) -- text may contain \N line breaks and *highlight*
CLIPS = [
    dict(slug="100-jam-di-gta-6", start=0.0, end=65.0,
         title="100 JAM DI GTA 6\\NMULAI DARI $0",
         caps=[
            (0.0, 6.5, "Akhirnya, setelah *13 tahun*\nmenunggu, 100 jam di GTA VI"),
            (7.3, 9.3, "Gila, game ini keren banget"),
            (9.7, 14.9, "Misi: cari mobil termahal\nterus beli!"),
            (15.3, 18.8, "Tapi sekarang uangku *$0*"),
            (19.3, 23.9, "Ini lebih bagus dari bayanganku\nNPC-nya kayak asli!"),
            (24.8, 27.0, "Wah, sini lihat!"),
            (27.5, 30.2, "Map-nya gede banget"),
            (30.7, 34.4, "Ada tempat burger, tapi...\nmasalah besar"),
            (35.4, 37.3, "Kita beneran punya *$0*"),
            (37.5, 41.1, "Kayak dunia nyata, cari duit dulu"),
            (41.3, 43.2, "Kita harus cari duit"),
            (43.4, 44.2, "Rampok aja orang"),
            (46.5, 48.3, "Orang ini baca buku?\nPasti dia punya duit"),
            (56.7, 58.8, "*$20!* Lumayan!"),
            (59.3, 63.1, "Saking miskinnya, rampok orang\ncuma buat beli burger"),
            (64.3, 65.0, "Jimmy, kamu harus kaya!"),
         ]),
    dict(slug="helikopter-kita-mati", start=357.0, end=435.0,
         title="HELIKOPTER!\\NKITA MATI",
         caps=[
            (357.4, 360.1, "Ya Tuhan!"),
            (360.8, 362.5, "Mereka kerahkan *helikopter!*"),
            (362.7, 363.2, "Ini gawat"),
            (364.1, 365.3, "Perahu ini nggak bisa belok"),
            (365.5, 366.9, "Kalian sudah terkepung"),
            (369.3, 370.6, "Gimana lolos dari helikopter?"),
            (370.9, 372.2, "Balik ke jalan raya"),
            (379.5, 381.4, "Mereka di mana-mana\n*Kita mati!*"),
            (381.9, 384.3, "Jangan nyerah!\nJimmy, cari mobil!"),
            (385.8, 387.6, "Ini kayak film!"),
            (388.0, 390.9, "Ambil Cadillac itu!"),
            (393.8, 395.6, "Mereka mau menembak!"),
            (399.0, 401.2, "Bintang kita nggak turun"),
            (404.0, 405.0, "Jangan sampai ketangkap"),
            (405.2, 406.6, "*Seribu dolar* kita bawa!"),
            (406.9, 409.3, "Ini stres banget"),
            (413.1, 414.8, "Bintang kita berkedip!"),
            (418.2, 420.0, "Kita berhasil, boys!"),
            (423.4, 430.3, "Kalau tiap rampokan sesulit ini\nperjalanan ini bakal panjang"),
            (432.3, 435.0, "Aku nunggu game ini *13 tahun*\nIni semua yang kuminta"),
         ]),
    dict(slug="geng-motor-31000", start=816.0, end=905.0,
         title="GENG MOTOR\\N$31.000!",
         caps=[
            (816.9, 818.4, "Kita butuh rencana lain"),
            (818.6, 822.9, "Barang kuning itu duit gede\ntapi risiko tinggi!"),
            (823.2, 825.5, "Kita selinap, ambil duitnya"),
            (827.0, 828.3, "Cari duit serius di sini"),
            (829.2, 830.5, "Ini geng motor"),
            (835.2, 838.1, "Tempat ini penuh biker"),
            (845.0, 846.9, "Orang itu ngeliatin aku"),
            (848.6, 850.3, "Seluruh bar jadi hening"),
            (852.2, 854.0, "Pasti ada di dalam"),
            (856.7, 857.4, "Tak ada perjuangan\ntak ada hasil"),
            (860.3, 862.0, "Oh, oh, oh, oh"),
            (866.7, 867.4, "Tiarap! Tiarap!"),
            (871.3, 873.2, "Wah, keren banget"),
            (878.7, 881.4, "Mereka temukan brankas\nledakin pakai peledak!"),
            (884.5, 885.4, "Berapa duitnya?"),
            (887.7, 889.0, "Ambil, ambil, ambil!"),
            (889.4, 890.7, "*$16.000!*"),
            (891.9, 894.1, "Kabur, kabur! Kita harus pergi!"),
            (894.5, 897.7, "Kabur dari polisi\nbawa *$31.000!*"),
            (902.3, 904.5, "Kita punya *$87.000!*"),
         ]),
    dict(slug="rampok-2-bank-5-bintang", start=1187.0, end=1254.0,
         title="RAMPOK 2 BANK\\NBINTANG 5!",
         caps=[
            (1187.5, 1189.4, "Sekarang rampok bank berikutnya"),
            (1189.4, 1190.4, "Rampok bank ganda?"),
            (1190.7, 1192.5, "Orang-orang bingung semua"),
            (1193.0, 1195.3, "Bank ini mewah banget"),
            (1198.9, 1200.6, "Ini duit! Duit bagus!"),
            (1200.6, 1202.6, "SWAT mengejar kita!"),
            (1203.7, 1205.1, "Kita dapat *5 bintang!*"),
            (1205.6, 1206.5, "Ayo kabur!"),
            (1211.4, 1212.8, "Mana mobilnya?"),
            (1214.7, 1217.7, "Mobil sport di kiri!"),
            (1218.8, 1220.7, "Ayo, Lucia, masuk!"),
            (1221.7, 1223.6, "Lucia menembak terus!"),
            (1224.2, 1226.7, "Bagus, Lucia! Buka jalan!"),
            (1228.7, 1230.6, "Itu polisi!"),
            (1231.2, 1232.6, "Oh, tidak"),
            (1235.4, 1238.5, "Ini nggak oke\nIni nggak oke!"),
            (1240.9, 1243.4, "Lucia! Masuk, masuk!"),
            (1244.2, 1245.0, "Mundur saja"),
            (1246.6, 1247.5, "Kita harus tinggalin dia"),
            (1247.9, 1248.9, "Kita tinggalin Lucia"),
            (1249.2, 1251.6, "Maaf ya, sayang\nMaaf, Lucia"),
            (1252.2, 1253.1, "Selamat bersenang-senang\ndi penjara!"),
         ]),
    dict(slug="mobil-termahal-66250", start=1716.0, end=1805.0,
         title="MOBIL TERMAHAL\\N$66.250!",
         caps=[
            (1716.6, 1717.9, "*$66.250!*"),
            (1718.3, 1719.1, "Kita punya duitnya"),
            (1719.6, 1722.6, "Sekarang modifikasi mobilnya"),
            (1723.0, 1725.9, "Toko ini spesialis mobil mewah"),
            (1731.4, 1733.2, "Underglow pasti keren"),
            (1734.2, 1734.5, "*$500*"),
            (1735.2, 1738.2, "500 dolar terbaik yang\npernah kita belanjakan"),
            (1739.9, 1741.6, "Kita bisa bikin lebih cepat"),
            (1744.9, 1747.3, "Mesin di-upgrade\ntambah turbo!"),
            (1747.4, 1750.3, "Ini bakal jadi mobil\ntercepat di GTA!"),
            (1750.7, 1754.4, "Dua jam in-game menghias mobil"),
            (1763.9, 1765.2, "Ayo, coba jalan pertama"),
            (1765.4, 1767.4, "Tinggal 2 jam lagi\nperjalanan 100 jam"),
            (1767.4, 1768.7, "Aku nggak mau ini berakhir"),
            (1771.0, 1772.7, "Ini jauh lebih cepat"),
            (1773.1, 1774.0, "Ini mobil kita"),
            (1774.1, 1775.0, "Ini keren banget"),
            (1775.4, 1776.6, "Seberapa cepat dia?"),
            (1778.9, 1782.2, "Ini terlalu cepat, bro!"),
            (1784.3, 1785.4, "Ini gila!"),
            (1785.8, 1796.3, "Sudah 100 jam di GTA 6\nrayakan dengan lompat tebing!"),
            (1801.9, 1805.0, "Seru banget 100 jam\npertamaku di GTA 6!"),
         ]),
]

def ass_time(t):
    t = max(0.0, t)
    h = int(t // 3600); m = int((t % 3600) // 60); s = t % 60
    return f"{h}:{m:02d}:{s:05.2f}"

def hl(text):
    out = []
    on = False
    for part in text.split("*"):
        if on:
            out.append("{\\1c&H00FFFF&}" + part + "{\\1c&HFFFFFF&}")
        else:
            out.append(part)
        on = not on
    return "".join(out).replace(chr(10), chr(92) + "N")

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
