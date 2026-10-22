#!/usr/bin/env bash
# Sync the CV between Overleaf, the local clone, and content/cv.pdf.
#
#   tools/sync-cv.sh            ol pull (Overleaf → local) → compile → copy PDF into the site
#   tools/sync-cv.sh --push     commit local .tex edits, ol push (local → Overleaf), then compile + copy
#   tools/sync-cv.sh --commit   also commit the new PDF in the site repo
#
# Overleaf access goes through the `ol` CLI (overleaf-git-sync), logged in once with
# `ol auth login --cookie-stdin` inside $CV_DIR. Re-run that login when the session expires.
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CV_DIR="${CV_DIR:-$HOME/project/personal/heewoong-cv}"
TEX_IMAGE="${TEX_IMAGE:-texlive/texlive:latest-full}"
MAIN_TEX="${MAIN_TEX:-main.tex}"
TARGET="$SITE_DIR/content/cv.pdf"
OL="${OL:-$HOME/.local/bin/ol}"

COMMIT=0; PUSH=0
for a in "$@"; do
  case "$a" in
    --commit) COMMIT=1 ;;
    --push) PUSH=1 ;;
    *) echo "unknown arg: $a" >&2; exit 2 ;;
  esac
done

[ -f "$CV_DIR/.ol-sync/config.toml" ] || { echo "$CV_DIR is not an ol project (run ol init there first)" >&2; exit 1; }
cd "$CV_DIR"

# 1. sync with Overleaf
if [ "$PUSH" = 1 ]; then
  if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Update CV ($(date +%Y-%m-%d))"
  fi
  echo ">>> pushing local edits to Overleaf"
  "$OL" push
else
  echo ">>> pulling from Overleaf"
  "$OL" pull
fi

# 2. regenerate service.tex from content/data/service.yml (single source with the homepage)
CV_DIR="$CV_DIR" python3 "$SITE_DIR/tools/gen-service-tex.py"

# 3. compile in Docker (output to build/, keeps the clone clean)
echo ">>> compiling $MAIN_TEX with $TEX_IMAGE"
mkdir -p build
docker run --rm -u "$(id -u):$(id -g)" -v "$CV_DIR":/work -w /work "$TEX_IMAGE" \
  latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build "$MAIN_TEX" >build/latexmk.log 2>&1 \
  || { grep -n -A3 '^! ' build/main.log | head -20; echo "compile failed (full log: $CV_DIR/build/latexmk.log)" >&2; exit 1; }
PDF="build/${MAIN_TEX%.tex}.pdf"

# 4. copy into the site
if cmp -s "$PDF" "$TARGET"; then
  echo ">>> PDF unchanged"
  exit 0
fi
cp "$PDF" "$TARGET"
echo ">>> updated $TARGET"

if [ "$COMMIT" = 1 ]; then
  cd "$SITE_DIR"
  git add content/cv.pdf
  git commit -m "Update CV from Overleaf"
  echo ">>> committed"
fi
