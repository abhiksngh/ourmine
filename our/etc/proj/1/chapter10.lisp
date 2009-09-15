(defmacro nil! (x) ;Chapter 10
  (list 'setf x nil))

(deftest test-macro()
  (check
    (macroexpand-1 '(nil! x))))

(defun my-backquote (x  y) ;Chapter 10
  `(X + Y = ,(+ x y)))

(deftest test-backquote()
  (check
    (= 3 (car (last (my-backquote 1 2))))))

(deftest test-eval() ;Chapter 10
  (check
    (= 20 (eval '(+ 5 5 10)))))

(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
                     choices)))))

(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))
     ,@(let ((key -1))
         (mapcar #'(lambda (expr)
                     `(,(incf key) ,expr))
                 exprs))))

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym)))
                 syms)
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(deftest test-for()
  (check
    (let ((y 0))
      (for x 1 8
        (setf y x))
      (= 8 y))))

(deftest test-avg()
  (check
    (= 12 (avg 10 14))))
