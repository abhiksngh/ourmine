BEGIN {
	Filename
	Classes ? Classes : 22
	main()
	cntr
}

function main() {
	while (getline < Filename) {
		if ($0 !~ /^[ ]./)
			Size++
	}
	close(Filename)
	while (getline < Filename) {
		if ($0 !~ /^[ ]./) {
			if ($1 ~ "1") {
				Hits++
				Score+= 1 - ( ($2-1) / (Classes-1) )
			}
			Total++
			Cntr++
			if(Cntr >= int(Size/25)) {
				Cntr = 0
				print Total" "(Score / Total)" "(Score / Total)
			}
		}
	}
}
