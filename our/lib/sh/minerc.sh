#define and create required directories

Base=$OurMine/opt/ourmine
Data=$Base/arffs
Docs=$Base/docs
Help=$Base/helpdocs
Tmp=$HOME/tmp
Var=$Tmp/var
Awk=$Base/lib/awk
Perl=$Base/lib/perl
Lists=$Base/lib/lists

mkdir -p "$Var $Tmp"
mkdir -p $Tmp

# useful globals

Weka="nice -19 java -Xmx1024M -cp $Base/lib/java/weka.jar "
Clusterers="nice -19 java -jar $Base/lib/java/Clusterers.jar "


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
