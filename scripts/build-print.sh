#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
  printf 'usage: %s SPINE_MM\n' "$0" >&2
  exit 2
fi

spine_mm="$1"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
output_dir="$repo_dir/output/pdf/eikou"
scratch_dir=$(mktemp -d "${TMPDIR:-/tmp}/kokage-print.XXXXXX")

cleanup() {
  rm -r "$scratch_dir"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$output_dir"
cd "$repo_dir"

typst compile main.typ "$scratch_dir/cover.pdf" \
  --input print-target=cover \
  --input spine-mm="$spine_mm" \
  --no-pdf-tags

typst compile main.typ "$scratch_dir/body-color.pdf" \
  --input print-target=body \
  --no-pdf-tags

gs -q -dSAFER -dBATCH -dNOPAUSE \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.7 \
  -sColorConversionStrategy=Gray \
  -dProcessColorModel=/DeviceGray \
  -dOverrideICC \
  -dAutoRotatePages=/None \
  -dPreserveAnnots=true \
  -dEmbedAllFonts=true \
  -dSubsetFonts=true \
  -sOutputFile="$scratch_dir/001-028.pdf" \
  "$scratch_dir/body-color.pdf"

mv "$scratch_dir/cover.pdf" "$output_dir/cover.pdf"
mv "$scratch_dir/001-028.pdf" "$output_dir/001-028.pdf"

printf '%s\n' \
  "$output_dir/cover.pdf" \
  "$output_dir/001-028.pdf"
