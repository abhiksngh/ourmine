BEGIN {
	Filename
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
				Score+= $1 / $2
			}
			Total++
			Cntr++
			if(Cntr >= int(Size/50)) {
				Cntr = 0
				print Total" "(Hits / Total)" "(Score / Total)
			}
		}
	}
}
