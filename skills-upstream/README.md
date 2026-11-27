# Skill Upstream — di-vendor sebagian

Empat skill dari repo lain DI-VENDOR di repo ini (bukan link-only lagi),
atas persetujuan owner setelah peringatan keamanan. Tiap folder berisi
SKILL.md + file-file yang dibutuhkan skill itu + LICENSE aslinya.
Atribusi lengkap (repo, penulis, lisensi MIT) ada di `NOTICE.md`.

Yang TIDAK ikut di-vendor (tetap clone dari repo aslinya kalau perlu):

- `motion-design-skill` — di-vendor penuh (md-only, 100 KB).
  Sumber: https://github.com/LottieFiles/motion-design-skill
- `hairline` — di-vendor `skills/` saja (192 KB): `hairline-create`
  + `hairline-adopt`. Tidak ikut: `apps/`, `packages/`, `assets/`,
  `registry/`, `fixtures/`, `scripts/`, file pnpm/turbo (monorepo 12 MB).
  Sumber: https://github.com/lucasmarkes/hairline
- `anatomy` — di-vendor inti skill saja (1,3 MB): `SKILL.md`, `kit/`,
  `references/`, `scripts/` (tanpa file `*.test.mjs`), `agents/`.
  Tidak ikut: `examples/` (25 MB — delapan contoh lengkap, skill ini
  merujuknya; clone repo penuh kalau mau contohnya), `evals/`, `tests/`,
  dokumen repo (CHANGELOG/CONTRIBUTING/dst).
  Sumber: https://github.com/wheresryan22/anatomy
- `anatomy-reveal` — di-vendor hampir penuh (580 KB): `SKILL.md`,
  `template/`, `scripts/`, `references/`, `THIRD_PARTY_NOTICES.md`.
  Tidak ikut: `demo/` (2,5 MB hasil demo).
  Sumber: https://github.com/annnguyentt/anatomy-reveal-skill

Catatan keamanan: file `.mjs` di skill-skill ini hanya menjalankan tool
lokal (node --check, ffmpeg, headless Chrome di localhost, npm install
playwright-core saat skill hairline-create dipakai pertama kali).
Tidak ada yang mengirim data ke luar. Jangan jalankan skripnya tanpa
membaca dulu apa yang dilakukannya.
