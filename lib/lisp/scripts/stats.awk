BEGIN {
	Filename
	RingSize ? RingSize : RingSize = 50
	Classes ? Classes : Classes = 22

	RollingAverage ? RollingAverage = "true" : RollingAverage = "false"

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
		if ($0 ~ /^[0-1]./) {
			if ($1 ~ "1") {
				Hits++
				ringBufferIns(1, Last10, RingSize)
				Score+= 1 - ( ($2-1) / (Classes-1) )
			}
			else {if (RollingAverage = "true")
				ringBufferIns(0, Last10, RingSize)}

			Total++
			if(Cntr >= int(Size/100)) {
				Cntr = 0
				RecentHits = 0
				for (i = 1; i < RingSize + 1; i++)
					RecentHits+= Last10[i]
				
				RunningAvg = RecentHits / RingSize
				Average = Hits / Total

				if (RunningAverage = "true")
					print Total" "RunningAvg" "(Score / Total)
				else
					print Total" "Average" "(Score / Total)
			}
			Cntr++

		}
	}
}

function ringBufferIns(x,	buffer, size) {
	buffer[buffer[0]=(buffer[0]%size)+1] = x
}
