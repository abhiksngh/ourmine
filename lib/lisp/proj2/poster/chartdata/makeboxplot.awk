BEGIN{
	NumRuns = 10

	files[++NumFiles] = "anneal-size.txt"
	files[++NumFiles] = "audiology-size.txt"
	files[++NumFiles] = "breast-cancer-size.txt"
	files[++NumFiles] = "hypothyroid-size.txt"
	files[++NumFiles] = "ionosphere-size.txt"
	files[++NumFiles] = "kr-vs-kp-size.txt"
	files[++NumFiles] = "mushroom-size.txt"
	files[++NumFiles] = "primary-tumor-size.txt"
	files[++NumFiles] = "segment-size.txt"
	files[++NumFiles] = "sick-size.txt"
	files[++NumFiles] = "sonar-size.txt"
	files[++NumFiles] = "soybean-size.txt"
	files[++NumFiles] = "splice-size.txt"
	files[++NumFiles] = "vehicle-size.txt"

	rosetta["nb"] = "NaiveBayes"
	rosetta["000-0-0-0-0-0"] = "MultiPipes"
	rosetta["000-0-0-0-1-0"] = "OverfitRevert"
	rosetta["000-0-0-0-1-1"] = "RemoveOutliers"
	rosetta["000-0-1-0-0-0"] = "HyperPipes"
	rosetta["000-25-0-0-0-0"] = "25%Alpha"
	rosetta["000-50-0-0-0-0"] = "50%Alpha"
	rosetta["000-5-0-0-0-0"] = "5%Alpha"
	rosetta["001-0-0-0-0-0"] = "Centroid"
	rosetta["100-0-0-0-0-0"] = "WeightedMeans0"
	rosetta["110-0-0-0-0-0"] = "WeightedMeans1"

	#read in each file
	for (file in files)
		read(files[file], Data)


	write(Data)
}

function read(filename, arr) {
	FS = ","
	while(getline < filename) {
		if(!rosetta[$1])
			"No translation for "$1
		else
			arr[++Line] = rosetta[$1]","$2","filename
	}
}

function write(arr) {
	asort(arr)
	for (i = 1; i <= Line; i++)
		print arr[i]
}
	
