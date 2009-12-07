BEGIN{
	NumRuns = 10

	files[++NumFiles] = "anneal.txt"
	files[++NumFiles] = "audiology.txt"
	files[++NumFiles] = "breast-cancer.txt"
	files[++NumFiles] = "hypothyroid.txt"
	files[++NumFiles] = "ionosphere.txt"
	files[++NumFiles] = "kr-vs-kp.txt"
	files[++NumFiles] = "mushroom.txt"
	files[++NumFiles] = "primary-tumor.txt"
	files[++NumFiles] = "segment.txt"
	files[++NumFiles] = "sick.txt"
	files[++NumFiles] = "sonar.txt"
	files[++NumFiles] = "soybean.txt"
	files[++NumFiles] = "splice.txt"
	files[++NumFiles] = "vehicle.txt"

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
			arr[++Line] = rosetta[$1]","$3","filename
	}
}

function write(arr) {
	asort(arr)
	for (i = 1; i <= Line; i++)
		print arr[i]
}
	
