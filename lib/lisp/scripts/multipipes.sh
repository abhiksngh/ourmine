#!/usr/bin/bash

if [ -z $2 ]; then
echo "Usage: bash multipipes.sh dataset numclasses"
exit
fi

#-------------prep--------------
cd ..
here=`pwd`

includeNB="yes"


file=`basename $1`	#remove directory
file=${file%.lisp}	#remove .lisp
hypdata=$here/proj2/HyperPipes/Data
nbdata=$here/proj2/HyperPipes/NBData
scripts=$here/scripts

tmpfolder=`date +"%m-%d-%H-%M-%S"`"-"$RANDOM
tmp=$here"/tmp/"$tmpfolder
learner=$tmp"/learner"
stats=$tmp"/stats"

if [ ! -d "$here/tmp" ]; then
    mkdir $here/tmp
fi

mkdir $tmp
mkdir $learner
mkdir $stats
mkdir $data

#----------randomize data----------

for ((i = 1; i <= 10; i++))
do
cat $hypdata/$1".lisp" | gawk -f $scripts/datablend.awk -v RandSeed=$RANDOM > $tmp/blend$i-$1.lisp
done

#----format data for naive bayes---

for ((i = 1; i <= 10; i++))
do
cat $tmp/blend$i-$1.lisp | gawk -f $scripts/format-data-nb.awk -v NAME=blendnb$i-$1 > $tmp/blendnb$i-$1.lisp
done

#--------------learn---------------

if [ $includeNB = "yes" ]; then
	echo "Running naive bayes on $file dataset"
	for ((i = 1; i <= 10; i++))
	do
		sbcl --load $scripts/nb-batch.lisp --eval "(nb-batch \"blendnb$i-$file\" \"tmp/$tmpfolder\")"
	done
fi

echo "Running all HyperPipes options on $file dataset"
for ((i = 1; i <= 10; i++))
do
sbcl --load $scripts/batch.lisp --eval "(batch \"blend$i-$file\" \"tmp/$tmpfolder\")"
done

mv $tmp/outputFile* $learner


#------------stats----------------

for afile in $learner/*
do
echo "Statin' up"
gawk -f $scripts/stats.awk -v Filename=$afile -v Classes=$2 > $stats/`basename $afile`-accuracy-stats.txt
done
