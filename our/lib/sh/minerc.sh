#-------------------------------                                               # define and create required directories                                                                                                                                                                          
Here=`pwd`
Base=$HOME/opt/ourmine/our
Data=$Base/arffs
Docs=$Base/docs
Tmp=$HOME/tmp
Var=$Base/var
Awk=$Base/lib/awk
Perl=$Base/lib/perl
Lists=$Base/lib/lists

mkdir -p "$Var $Tmp"
mkdir -p $Tmp

#-------------------------------       

#-------------------------------
# useful globals
Weka="nice -19 java -Xmx1024M -cp $Here/lib/java/weka.jar "
Clusterers="nice -19 java -jar $Here/lib/java/Clusterers.jar "
#-------------------------------
# define and load files
Files="	
		lib/sh/util.sh 
		lib/sh/preprocess.sh 
		lib/sh/learn.sh 
                lib/sh/cluster.sh
                lib/sh/fss.sh
                workers/worker_cluster.sh
		demos.sh
		"
#load all from Files above
for config in $Files; do 
	[ -f  "$config" ] && . $config
done

echo "Ourmine - Copyright 2009 by Tim Menzies, Adam Nelson"
PS1="OURMINE> "
