#!/bin/sh

CONFIG="$1"
OUTDIR="$2"

[ -z "$OUTDIR" ] && {
	echo "$0 <config_file> <output_directory>"
  exit 1
}

[ -d "$OUTDIR" ] || mkdir "$OUTDIR"

OPENSSL=openssl-1.0

$OPENSSL aes-256-cbc -d -in "$CONFIG" -k 'Archer C1200' | $OPENSSL zlib -d | tar -xf - -C "$OUTDIR"
