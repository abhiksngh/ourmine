#!/usr/bin/bash
for file in ../proj2/HyperPipes/Data/*.lisp
do
file=`basename $file`	#remove directory
file=${file%.lisp}	#remove .lisp
echo $file
sbcl --load ../batch.lisp --eval "(batch \"$file\")"
done
