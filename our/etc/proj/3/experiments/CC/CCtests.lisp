(defun cvtests ()
	(cross-validation2 (shared_KC2)(shared_KC1) :file-name "kc2kc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC2)(shared_MW1) :file-name "kc2mw1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )
	(cross-validation2 (shared_KC2)(shared_MC2) :file-name "kc2mc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )		
	(cross-validation2 (shared_KC2)(shared_PC1) :file-name "kc2pc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )
	(cross-validation2 (shared_KC1)(shared_KC3) :file-name "kc1kc3.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )
	(cross-validation2 (shared_KC1)(shared_CM1) :file-name "kc1cm1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC1)(shared_KC2) :file-name "kc1kc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC1)(shared_PC1) :file-name "kc1pc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC3)(shared_CM1) :file-name "kc3cm1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC3)(shared_MW1) :file-name "kc3mw1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC3)(shared_KC1) :file-name "kc3kc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_KC3)(shared_MC2) :file-name "kc3mc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_PC1)(shared_KC2) :file-name "pc1kc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_PC1)(shared_KC3) :file-name "pc1kc3.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_PC1)(shared_CM1) :file-name "pc1cm1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_PC1)(shared_MW1) :file-name "pc1mw1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MC2)(shared_KC1) :file-name "mc2kc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MC2)(shared_KC2) :file-name "mc2kc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MC2)(shared_PC1) :file-name "mc2pc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MC2)(shared_CM1) :file-name "mc2cm1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_CM1)(shared_MW1) :file-name "cm1mw1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_CM1)(shared_MC2) :file-name "cm1mc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_CM1)(shared_PC1) :file-name "cm1pc1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_CM1)(shared_KC2) :file-name "cm1kc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )
	(cross-validation2 (shared_MW1)(shared_KC3) :file-name "mw1kc3.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MW1)(shared_KC2) :file-name "mw1kc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify )
	(cross-validation2 (shared_MW1)(shared_CM1) :file-name "mw1cm1.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	(cross-validation2 (shared_MW1)(shared_MC2) :file-name "mw1mc2.csv" :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
	)

