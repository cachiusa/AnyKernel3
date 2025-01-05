#!/bin/bash
set -exo pipefail
AKHOME=$(dirname "$0")
THIS_FILE=$(basename "$0")
OUT_FILE=$(pwd)/$1
OUT_DTB=veux.dtb
IGNORE=".git .github *.md $THIS_FILE"
cd "$AKHOME"
[ -f "$OUT_DTB" ] && mv "$OUT_DTB" dtb
[ -f dtb ] || exit
[ -f Image ] || exit
if [ -f Image_KSU ]; then 
  bsdiff Image Image_KSU ksu.bdf
  rm Image_KSU
fi
if [ "$1" = "clear" ]; then
  rm -rf $IGNORE
else
  zip -r9 "$OUT_FILE" * -x $IGNORE
fi
