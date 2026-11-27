#!/usr/bin/env bash
# Motion Studio Gratis — install.sh
# Install 27 dari 28 repo (MusicGen TIDAK diinstall — lihat bawah).
# CPU-only, tanpa GPU, tanpa bayar. Terverifikasi 27 Nov 2026.
# Jalan berurutan, jangan paralel dengan build berat (RAM).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MS="$ROOT/motion-studio"
JS="$MS/js"

echo "== 1. Cek syarat =="
for cmd in node npm python3 ffmpeg git; do
  command -v "$cmd" >/dev/null || { echo "BELUM ADA: $cmd — install dulu, lalu jalankan lagi."; exit 1; }
done
node --version; python3 --version; ffmpeg -version 2>/dev/null | head -1

echo "== 2. Pustaka JS (anime, react-spring, PixiJS, p5, matter, D3, Motion Canvas, Three, Remotion, Lottie, Tone + Motion, GSAP, Tweakpane, rapier, postprocessing, three.quarks) =="
cd "$JS"
npm install

echo "== 3. Venv Python utama (torch CPU + RIFE deps + librosa) =="
python3 -m venv "$MS/venv"
export TMPDIR="$MS/.pip-tmp"
mkdir -p "$TMPDIR"
"$MS/venv/bin/pip" install --upgrade pip
"$MS/venv/bin/pip" install "torch==2.15.0+cpu" "torchvision==0.29.2+cpu" --index-url https://download.pytorch.org/whl/cpu
"$MS/venv/bin/pip" install "av==15.1.0" "numpy==2.5.5" "opencv-python-headless==5.1.0" tqdm gdown
"$MS/venv/bin/pip" install "librosa==1.0.1"

echo "== 4. RIFE (clone + model v4 HD) =="
if [ ! -d "$MS/rife" ]; then
  git clone https://github.com/hzwer/ECCV2022-RIFE "$MS/rife"
fi
mkdir -p "$MS/tmp" "$MS/rife/train_log"
if [ ! -f "$MS/rife/train_log/flownet.pkl" ]; then
  "$MS/venv/bin/python" -m gdown 1APIzVeI-4ZZCEuIRE1m6WYfSCaOsi_7_ -O "$MS/tmp/RIFE_HD_models.zip"
  unzip -o "$MS/tmp/RIFE_HD_models.zip" -d "$MS/rife/train_log/"
fi

echo "== 5. Blender (apt, butuh sudo) =="
if ! command -v blender >/dev/null; then
  if sudo -n true 2>/dev/null; then
    sudo apt-get update && sudo apt-get install -y blender
  else
    echo "SKIP: blender tidak ada dan sudo tidak tersedia — install manual: sudo apt-get install -y blender"
  fi
fi

echo "== 6. Manim (venv terpisah, pin tidak bentrok dengan venv utama) =="
# Butuh libcairo2 + libpango di sistem (biasanya sudah ada; kalau manim gagal, install via apt).
python3 -m venv "$MS/venv-manim"
"$MS/venv-manim/bin/pip" install --upgrade pip
"$MS/venv-manim/bin/pip" install "manim==0.22.1"
"$MS/venv-manim/bin/manim" --version

echo "== 7. WhisperX (venv terpisah — torch CPU DULU, baru whisperx) =="
python3 -m venv "$MS/venv-whisperx"
"$MS/venv-whisperx/bin/pip" install --upgrade pip
"$MS/venv-whisperx/bin/pip" install "torch==2.8.0+cpu" "torchaudio==2.8.0+cpu" --index-url https://download.pytorch.org/whl/cpu
"$MS/venv-whisperx/bin/pip" install "whisperx==3.8.6" "faster-whisper==1.2.1"
"$MS/venv-whisperx/bin/pip" install "transformers==4.48.3"
"$MS/venv-whisperx/bin/pip" install "torchvision==0.23.0+cpu" --index-url https://download.pytorch.org/whl/cpu
"$MS/venv-whisperx/bin/python" -c "import whisperx; print('whisperx import OK')"
echo "Catatan: model WhisperX (tiny dst.) diunduh saat pertama dipakai, bukan saat install."

echo "== 8. Openverse API (tanpa install server — cek API publik, tanpa key) =="
curl -s "https://api.openverse.org/v1/audio/?q=rain" | head -c 300 || true; echo
echo "Catatan: kalau API tidak terjangkau, lewati — Openverse hanya sumber audio, bukan blocker."

echo "== 9. Skill upstream (clone --depth 1, tidak diinstall sebagai paket) =="
mkdir -p "$MS/upstream-skills"
for repo in LottieFiles/motion-design-skill lucasmarkes/hairline wheresryan22/anatomy annnguyentt/anatomy-reveal-skill; do
  name="$(basename "$repo")"
  if [ ! -d "$MS/upstream-skills/$name" ]; then
    git clone --depth 1 "https://github.com/$repo" "$MS/upstream-skills/$name"
  fi
done

echo "== 10. Verifikasi =="
node "$JS/verify.mjs"
node "$JS/verify-p5-jsdom.mjs"
node "$JS/verify-lottie-jsdom.mjs"
node "$JS/verify-new.mjs"

echo ""
echo "SELESAI: 27 dari 28 repo terinstall."
echo "MusicGen TIDAK diinstall: pin audiocraft (av==11.0.0, torch==2.1.0) tidak"
echo "jalan di Python 3.12 + lisensinya non-komersial. Opsi ada di INSTALL.md."
echo "Pengganti suara sementara: Tone.js + ffmpeg (+ audio asli Openverse, CC-BY)."
echo "WhisperX: alignment Bahasa Indonesia belum teruji — butuh sampel speech asli."
echo "Skill upstream: file skill di-vendor di skills-upstream/ repo ini; contoh"
echo "besar (anatomy examples/ 25 MB, hairline apps/packages/assets) tidak ikut."
