#!/usr/bin/gawk -f
BEGIN { 
	IGNORECASE = 1; 
	OFS = FS   = ",";
	is("rely,data,cplx,time,stor,virt,turn,acap,aexp,pcap,vexp,lexp,modp,tool,sced","em");
	is("pmat,resl,prec,team,flex","sf");
	is("loc,actEffort",0);
}

/@attribute/  { 
	split($0,Names,/ [ \t]*/); 
	Name[++A] = Names[2] ;
	$0="@attribute " Name[A] " real";
}

data && NF==A { 
	for(I=1;I<NF;I++) {
		if ($I  !~ /?/ ) { 
			if (This=What[Name[I]]) {
				$I = Table[This,Name[I],$I] 
			}
		}
	}
}
/@data/ { data=1 }

{ print $0; }

function is(s,what,   i,tmp) {
	split(s,tmp,",");
	for(i in tmp)
		What[tmp[i]]=what;
}
