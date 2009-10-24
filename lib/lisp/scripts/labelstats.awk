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

		if ($0 ~ "yay") {
			print Count" "0.0" "$NF
			print Count+0.001" "1.0" "$NF
			print Count+0.002" "0.0" "$NF
		}
		else
		if ($0 ~ /^[0-1]./) {
			Count++
		}
	}
}
