# Motion Studio Gratis

Satu studio video lengkap, 0 rupiah. Tanpa GPU, tanpa langganan, tanpa Adobe, tanpa render farm.

Kurasi 14 repo open-source + skill + playbook + pipeline yang dipakai sehari-hari buat produksi video: animasi berkode (Remotion, Motion Canvas, Hyperframes), motion library (anime.js, PixiJS, Three.js, dan kawan-kawan), interpolasi frame (RIFE), sampai pipeline clipper, ASMR, dan drama AI.

## Isi repo

| Folder | Isi |
|---|---|
| `skills/` | 11 skill: Remotion, Hyperframes (+ CLI, registry, media-use, reverse-any-video, style-sampling), Motion Design Toolkit, YouTube highlight clipper, GTA 6 content creator, rights gate |
| `playbooks/` | FYP Playbook (alur produksi + riset FYP 2026) dan daftar 14 repo |
| `motion-studio/` | Install script + `package.json` + catatan install terverifikasi |
| `pipelines/clipper/` | Video panjang jadi klip vertikal 1080x1920 (transkrip + ffmpeg) |
| `pipelines/asmr/` | Animasi ASMR masak cozy storybook (Ken Burns + efek ambient + RIFE) |
| `pipelines/drama-ai/` | Episode drama AI vertikal, resep fallback Ken Burns |
| `hyperframes/` | Setup + catatan render Hyperframes (HTML → video) |

## Cara pakai cepat

```bash
git clone https://github.com/<username>/motion-studio-gratis.git
cd motion-studio-gratis
./motion-studio/install.sh
```

Lalu baca `playbooks/FYP-PLAYBOOK.md` buat alur produksi, dan `skills/` buat cara pakai tiap tool.

## Syarat

- Node.js 24 + npm
- Python 3.12
- ffmpeg 8+
- Blender 4 (diinstall otomatis lewat apt kalau ada sudo; kalau tidak, install manual)
- RAM: install berurutan, jangan paralel build berat (mesin dengan 1,3 GB RAM bebas cukup)

## Yang belum termasuk

- **MusicGen (audiocraft)** — tidak diinstall default. Lisensinya non-komersial, dan install-nya gagal di Python 3.12 (pin `av==11.0.0` tidak ada wheel + konflik torch 2.1.0). Dua jalur ada di `motion-studio/INSTALL.md`. Pengganti sementara: Tone.js + ffmpeg.
- **Model RIFE** diunduh saat install (Google Drive, 11 MB, `flownet.pkl` v4 HD).
- **Komponen GTA Hyperframes** (126 komponen) tidak di-vendor — jalankan `hyperframes/setup-gta-components.sh` buat clone.

## Lisensi

Konten repo ini (skill, playbook, pipeline, skrip install) lisensi MIT — lihat `LICENSE`.

Repo upstream tetap milik pembuatnya dengan lisensinya masing-masing — lihat `NOTICE.md`. Kalau dipakai, cantumkan atribusi sesuai lisensi masing-masing.

## Aturan hak footage

Repo ini berisi pipeline buat motong video — tapi motong bukan berarti boleh tayang. Sebelum pakai footage orang lain, tetapkan dulu dasar haknya (izin creator, clipping campaign, klip resmi platform + kredit, atau gameplay sendiri). Lihat `skills/third_party_footage_rights_gate/SKILL.md`.
