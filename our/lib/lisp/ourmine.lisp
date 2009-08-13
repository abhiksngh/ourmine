; disable an irritating SBCL flag
#+SBCL (DECLAIM (SB-EXT:MUFFLE-CONDITIONS CL:STYLE-WARNING))

(defun make (&rest files)
  (dolist (file files)
    (format t "~a "  file)
    (load file))
  (terpri))

(make "tests/deftest"
      "tests/timm"
      "tricks/lispfuns"
      "tricks/macros"
      )
