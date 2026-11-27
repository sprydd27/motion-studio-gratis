#!/usr/bin/env bash
# Motion Studio Gratis — install.sh
# Install 13 dari 14 repo (MusicGen TIDAK diinstall — lihat bawah).
# CPU-only, tanpa GPU, tanpa bayar. Terverifikasi 25 Nov 2026.
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

echo "== 2. Pustaka JS (anime, react-spring, PixiJS, p5, matter, D3, Motion Canvas, Three, Remotion, Lottie, Tone) =="
cd "$JS"
npm install

echo "== 3. Venv Python (torch CPU + RIFE deps) =="
python3 -m venv "$MS/venv"
export TMPDIR="$MS/.pip-tmp"
mkdir -p "$TMPDIR"
"$MS/venv/bin/pip" install --upgrade pip
"$MS/venv/bin/pip" install "torch==2.15.0+cpu" "torchvision==0.29.2+cpu" --index-url https://download.pytorch.org/whl/cpu
"$MS/venv/bin/pip" install "av==15.1.0" "numpy==2.5.5" "opencv-python-headless==5.1.0" tqdm gdown

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

echo "== 6. Verifikasi =="
node "$JS/verify.mjs"
node "$JS/verify-p5-jsdom.mjs"
node "$JS/verify-lottie-jsdom.mjs"

echo ""
echo "SELESAI: 13 dari 14 repo terinstall."
echo "MusicGen TIDAK diinstall: pin audiocraft (av==11.0.0, torch==2.1.0) tidak"
echo "jalan di Python 3.12 + lisensinya non-komersial. Opsi ada di INSTALL.md."
echo "Pengganti suara sementara: Tone.js + ffmpeg."
