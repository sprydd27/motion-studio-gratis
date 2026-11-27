#!/usr/bin/env bash
# Clone komponen video GTA (126 komponen, MIT) + setup per komponen.
# setup.sh komponen hanya copy font + motion kit ke assets/ + bikin folder
# footage kosong — tidak ada download/install lain.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$DIR/gta-components" ]; then
  git clone https://github.com/echris6/gta-components "$DIR/gta-components"
fi
echo "Selesai. Jalankan setup.sh komponen saat pertama dipakai, misal:"
echo "  ./gta-components/setup.sh components/<slug>/shorts"
echo "Lihat SETUP.md buat detail render (TMPDIR + cache dialihkan, -w 1)."
