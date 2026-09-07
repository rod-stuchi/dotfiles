#!/usr/bin/env bash
# Compress PDFs with Ghostscript, keeping the result only when it is actually smaller.
# Invoked from the pdfCompress* openers in yazi.toml.
#
# Usage: pdf-compress.sh <gs-preset> <file.pdf>...
#   <gs-preset>  /screen (72dpi) | /ebook (150dpi) | /printer | /prepress (300dpi)

set -u

preset="${1:?usage: pdf-compress.sh <gs-preset> <file.pdf>...}"
shift
tag="${preset#/}"

notify() { notify-send -a yazi "PDF compress" "$1"; }
human() { numfmt --to=iec "$1"; }

for f in "$@"; do
	out="${f%.*}_${tag}.pdf"

	if ! gs -sDEVICE=pdfwrite \
		-dCompatibilityLevel=1.5 \
		-dPDFSETTINGS="$preset" \
		-dDetectDuplicateImages=true \
		-dAutoRotatePages=/None \
		-dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile="$out" "$f"; then
		rm -f "$out"
		notify "failed: ${f##*/}"
		continue
	fi

	before=$(stat -c%s "$f")
	after=$(stat -c%s "$out")

	if [ "$after" -ge "$before" ]; then
		rm -f "$out"
		notify "${f##*/}: no gain ($(human "$before") → $(human "$after"))"
	else
		notify "${out##*/}: $(human "$before") → $(human "$after") ($((100 - 100 * after / before))% smaller)"
	fi
done
