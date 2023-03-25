#!/bin/sh

INPUTDIR="$1"
OUTFILE="$2"
OPENSSL=openssl-1.0

[ -z "$OUTFILE" ] && {
	echo "$0 <input_dir> <outfile>"
	exit 1
}

(cd "$INPUTDIR" && tar -cf - * && cd -) | $OPENSSL zlib | $OPENSSL aes-256-cbc -out "$OUTFILE" -k 'Archer C1200'
