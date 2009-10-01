BEGIN {
	main()
	cntr
}

function main() {
	while (getline) {
		if ($1 ~ "1")
			Hits++
		Total++
		Cntr++
		if(Cntr == 100) {
			Cntr = 0
			print Total" "(Hits / Total)
		}
	}
}
