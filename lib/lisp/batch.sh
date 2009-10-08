#!/usr/bin/bash
echo "Running batch job on $1"
sbcl --load batch.lisp --eval "(batch \"$1\")"
