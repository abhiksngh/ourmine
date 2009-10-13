(defstruct (abcd (:print-function abcd-print))
  for (a 0) (b 0) (c 0) (d 0))

(labels ((a (x) (abcd-a x))
         (b (x) (abcd-b x))
         (c (x) (abcd-c x))
         (d (x) (abcd-d x)))
  (defun pd     (x) (if (zerop (d x)) 0 (/ (d x) (+ (b x) (d x)))))
  (defun pf     (x) (if (zerop (c x)) 0 (/ (c x) (+ (a x) (c x)))))
  (defun all    (x) (+ (a x) (b x) (c x) (d x)))
  (defun recall    (x) (pd x))
  (defun precision (x) (if(zerop (d x)) 0 (/ (d x) (+ (c x)(d x)))))
  (defun accuracy  (x) (if (and (zerop (a x)) (zerop (d x))) 0
                           (/ (+ (a x) (d x)) (all x))))
  (defun harmonic-mean (x y)  (/ (* 2 x y) (+ x y)))
  (defun f-measure (x) (if (or (zerop (a x)) (zerop (d x))) 0
                           (harmonic-mean (pd x) (pf x))))
  (defun balance   (x &optional (goalpd 1) (goalpf 0))
    (- 1 (/ (sqrt (+  (expt (- goalpf (pf x)) 2)
                      (expt (- goalpd (pd x)) 2)))
            (sqrt 2))))
  )

(defun abcd-stats (pairs &key (verbose t))
  "stats from cons of (want . got)"
  (let* ((h (make-hash-table :test #'equal))
         classes out)
    (dolist (pair pairs)
      (unless (member (first pair) classes)
        (push (first pair) classes))
      (unless (member (rest  pair) classes)
        (push (rest pair)  classes))
      (incf (gethash pair h 0))); while here, collect abcd-stats
    (if verbose (abcd-matrix pairs classes h))
    (dolist (class classes out)
      (unless (null class)
        (let ((abcd (make-abcd :for class)))
          (maphash ; for each item in the hash counts, do
           #'(lambda (pair count)
               (abcd-stat (first pair) (rest pair)
                          count class h abcd))
           h)
          (push abcd out))))))

(defun abcd-stat (want got count goal h abcd)
  (if (eql got goal)
                 (if (eql want goal)
                     (incf (abcd-d abcd) count)
                     (incf (abcd-c abcd) count))
                 (if (eql want goal)
                     (incf (abcd-b abcd) count)
                     (incf (abcd-a abcd) count))))


(defun abcd-print (x s d)
  (declare (ignore x))
      ;(format s "#(ABCD :FOR ~a :A ~a :B ~a :C ~a :D ~a :ACC ~2,2f "
       (format s "~a,~a,~a,~a,~a,"
       (abcd-for x) (abcd-a x) (abcd-b x)
                                  (abcd-c x) (abcd-d x) (accuracy x))
        ;(format s ":PD ~2,2f :PF ~2,2f :PREC ~2,2f :F ~2,2f :BAL ~2,2f)"
       (format s "~2,2f,~2,2f,~2,2f,~2,2f,~2,2f"
       (pd x) (pf  x) (precision x)
       (f-measure x) (balance x)))


(defun abcd-matrix (pairs classes h)
    (let ((n 0)
                  renames
                  (syms '((0  . a)(1  . b)(2  . c) (3 . d) (4 . e)
                                         (5  . f)(6  . g)(7  . h) (8 . i) (9 . j)
                                         (10 . k)(11 . l)(12 . m)(13 . n)(14 . o)
                                         (15 . p)(16 . q)(16 . r)(18 . s)(19 . t)
                                         (20 . u)(21 . v)(22 . w)(23 . x)(24 . y)
                                         (25 . z)(26 . aa)(27 . ab) (28 . ac)(29 . ad)
                                         (30 . ae)(31 . af)(32 . ag)(33 . ah)(34 . ai)
                                         (35 . aj)(36 . ak)(37 . al)(38 . am)(39 . an)
                                         (40 . ao)(41 . ap)(42 . aq)(43 . ar)(44 . as)
                                         (45 . at)(46 . au)(47 . av)(48 . aw)(49 . ax)
                                         (50 . ay)(51 . az))))
          (showh h)
              (terpri)
                  (doitems (class i classes)
                          (format t "~5<~(~a~)~>" (cdr (assoc i syms)))
                                (push (cons class (cdr (assoc i syms ))) renames))
                      (format t "  <--- classified as~%")
                          (setf n -1)
                              (doitems (class1 i1 classes)
                                      (incf n)
                                            (doitems (class2 i2 classes)
                                                      (format t "~5d" (gethash (cons class1 class2) h 0)))
                                                  (format t " | ~(~a~) = ~a~%" (cdr (assoc i1 syms)) class1))))

