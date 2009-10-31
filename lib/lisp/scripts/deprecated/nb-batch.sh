#!/usr/bin/bash
for file in ./proj2/HyperPipes/NBData/*.lisp
do
file=`basename $file`	#remove directory
file=${file%.lisp}	#remove .lisp
echo $file
sbcl --load nb-batch.lisp --eval "(nb-batch \"$file\")"
done
