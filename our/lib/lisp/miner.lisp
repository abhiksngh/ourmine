; disable an irritating SBCL flag

(defparameter *files* '(
			"tests/deftest"  ; must be loaded first
			"tricks/lispfuns"
			"tricks/macros"
			"tricks/number"
			"tricks/string"
			"tricks/list"
			"tricks/hash"
			"tricks/random"
			"tricks/normal"
			"tricks/caution"
			"table/structs"
			"table/header"
			"table/data"
			"table/table"
			"table/xindex"
			"learn/nb"
                        "learn/abcd"
                        ;"proj1/tprifti/deftest_chapter2"
                        ;"proj1/tprifti/deftest_chapter6"
                        ;"proj1/tprifti/deftest_chapter10"
                        "proj1/figures/graham"
			;"proj1/anelson/chapter3"
			;"proj1/wmensah/chapter4"
			;"proj1/anelson/chapter5"
			;"proj1/wmensah/chapter7"
                        ;"proj1/anelson/chapter10-4"
                        ;"proj1/anelson/chapter10-5"
                        ;"proj1/anelson/chapter10-6"
			;"proj1/wmensah/chapter10-7"
			;"proj1/wmensah/chapter14-5"
                        "learn/hyperpipes"
                        ;"proj1/tprifti/TWCNB"
                        "proj2/discretize"
                        "proj2/discretize2"
                        ;"tests/data/primary-tumor"
                        ;"tests/data/vote"
                        ;"tests/data/mushroom"
                        ;"tests/data/audiology"
                        ;"tests/data/splice"
                        ;"tests/data/soybean"
                        ;"tests/data/contactlens"
                        ;"tests/data/kr-vs-kp"
                        ;"tests/data/weather_nominal"
                        ;"tests/data/weather2"
                        "proj2/distances"
                        "proj2/split2bins"
                        "proj2/preprocess"
                        "proj2/k-means"
                        "proj2/learn"
                        "proj2/infogain"
                        "proj2/ranker"
                        "proj2/nb-num"
                        "proj2/discretize2"
                        "proj2/data/shared_PC1"
                        "proj2/data/shared_CM1"
                        "proj2/data/shared_KC1"
                        "proj2/data/shared_KC2"
                        "proj2/data/shared_KC3"
                        "proj2/data/shared_MC2"
                        "proj2/data/shared_MW1"
                        "proj2/util"
                        "proj3/prism"
                        "proj3/split-tables"
                        "proj3/utilscore"
                        "proj3/score-bsquare"
                        "proj3/commoncols"
                        ;"proj3/mlh2/entropy"
                        ;"proj3/mlh2/classify-id3"
                        ;"proj3/mlh2/id3"
			))

(defun make1 (files)
  (let ((n 0))
    (dolist (file files)  
      (format t ";;;; ~a.lisp~%"  file) 
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind 
	  ((style-warning #'muffle-warning))
	(make1 *files*))))

(make)
