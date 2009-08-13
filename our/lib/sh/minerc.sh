#define and create required directories

Base=$OurMine
Data=$Base/arffs
Docs=$Base/docs
Help=$Base/helpdocs
Tmp=$HOME/tmp
Var=$Tmp/var
Awk=$Base/lib/awk
Sh=$Base/lib/sh
Java=$Base/lib/java
Perl=$Base/lib/perl
Lists=$Base/lib/lists
Save=$Base/save

mkdir -p "$Var $Tmp"
mkdir -p $Tmp

# useful globals

Weka="java -Xmx1024M -cp $Java/weka.jar "
Clusterers="java -Xmx1024M -jar $Java/Clusterers.jar "
Reducers="java -Xmx1024M -jar $Java/Reduce.jar "

# define and load files

Files="	
		$Sh/util.sh 
		$Sh/preprocess.sh 
		$Sh/learn.sh 
                $Sh/cluster.sh
                $Sh/fss.sh
		$Sh/analysis.sh
                $Base/workers/worker_cluster.sh
                $Base/workers/worker_cluster_analysis.sh
                $Base/workers/worker_reduce.sh
		$Base/demos.sh		
		"
#load all from Files above

for config in $Files; do 
	[ -f  "$config" ] && . $config
done

echo "Ourmine - Copyright 2009 by Tim Menzies, Adam Nelson, Gregory Gay"
PS1="OURMINE> "
