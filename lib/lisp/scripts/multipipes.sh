#!/usr/bin/bash

if [ -z $2 ]; then
echo "Usage: bash multipipes.sh dataset numclasses"
exit
fi

#-------------prep--------------
cd ..
here=`pwd`

includeNB="yes"
plotacc="yes"


file=`basename $1`	#remove directory
file=${file%.lisp}	#remove .lisp
hypdata=$here/proj2/HyperPipes/Data
nbdata=$here/proj2/HyperPipes/NBData
scripts=$here/scripts

tmpfolder=`date +"%H-%M-%S"`"-$1-"$RANDOM
tmp=$here"/tmp/"$tmpfolder
data=$tmp"/data"
learner=$tmp"/learner"
accstats=$tmp"/accuracy-stats"
sizestats=$tmp"/size-stats"
accplots=$tmp"/accuracy-plots"

if [ ! -d "$here/tmp" ]; then
    mkdir $here/tmp
fi

mkdir $tmp
mkdir $data
mkdir $learner
mkdir $accstats
mkdir $sizestats
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

mv $tmp/*outputFile* $learner
mv $tmp/*.lisp $data


#------------stats----------------

##accuracy stats
for afile in $learner/*
do
echo "Statin' up accuracy in "$afile
gawk -f $scripts/stats.awk -v Filename=$afile -v Classes=$2 > $accstats/`basename $afile`-accuracy-stats.txt
done


##set size stats
for afile in `ls $learner | grep '000\{1\}.*0-0-0-0.txt'`
do
echo "Building set size statistics on "$afile
tmpfilename=${afile%.txt}
gawk -f $scripts/sizestats.awk -v Filename=$learner/$afile -v Classes=$2 > $sizestats/`basename $tmpfilename`-size-stats.txt
done

#-------plot accuracy------------
if [ $plotacc = "yes" ]; then
mkdir $accplots
gawk -f $scripts/make-acc-plot.awk -v Source=$accstats -v OutPath=$accplots -v NB=$includeNB -v Dataset=$1 > $accplots"/$1-accuracy.plot"
gnuplot $accplots/$1-accuracy.plot
fi

#---------build boxplots---------

for afile in $accstats/*
do

type=`echo $afile | sed 's/.*\([01][01][01]-[0-9]*-[01]-[01]-[01]-[01]\).*/\1/'`

echo $type
echo ${#type}

if (( ${#type} > 20 )); then
type=nb
fi

echo $type","`cat $afile | gawk 'END{print 100*$2","100*$3}'`>> $tmp/boxplot.txt
done
