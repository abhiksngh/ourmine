BEGIN {
	NAME ? NAME : "DefaultName"
	getline

	print "(defun "NAME" ()"
	print "  (data"
	print "    :name '"NAME
	printf "    :columns '("
	for (i=1; i<NF; i++) {
		printf "COL"i" "
	}
	print "class)"
	print "    :egs"
	print "    '("
	writeLine()
	while(getline) {
		writeLine()
	}	
	print "      )))"
}

function writeLine() {
	gsub(/^'/,"",$1)
	print "      "$0
}
