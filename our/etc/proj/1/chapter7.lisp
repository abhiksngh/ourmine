;;;; Code from figure 7.1

(defstruct buf
  vec (start -1) (used -1) (new -1) (end -1))

(defun bref (buf n)
  (svref (buf-vec buf)
         (mod n (length (buf-vec buf)))))

(defun (setf bref) (val buf n)
  (setf (svref (buf-vec buf)
               (mod n (length (buf-vec buf))))
        val))

(defun new-buf (len)
  (make-buf :vec (make-array len)))

(defun buf-insert (x b)
  (setf (bref b (incf (buf-end b))) x))

(defun buf-pop (b)
  (prog1 
    (bref b (incf (buf-start b)))
    (setf (buf-used b) (buf-start b)
          (buf-new  b) (buf-end   b))))

(defun buf-next (b)
  (when (< (buf-used b) (buf-new b))
    (bref b (incf (buf-used b)))))

(defun buf-reset (b)
  (setf (buf-used b) (buf-start b)
        (buf-new  b) (buf-end   b)))

(defun buf-clear (b)
  (setf (buf-start b) -1 (buf-used  b) -1
        (buf-new   b) -1 (buf-end   b) -1))

(defun buf-flush (b str)
  (do ((i (1+ (buf-used b)) (1+ i)))
      ((> i (buf-end b)))
    (princ (bref b i) str)))

;;;; DEFTESTS
(deftest test-buf-insert ()
  (check
    (let ((buffer (new-buf 3)))
      (buf-insert #\a buffer)
      (and (= (buf-end buffer) 0)
           (char= #\a (buf-pop buffer))))))

(deftest test-buf-pop ()
  (check
    (let ((buffer (new-buf 3)))
      (buf-insert #\a buffer)
      (and (char= #\a (buf-pop buffer))
           (= (buf-start buffer) 0)))))

(deftest test-buf-next ()
  (check
    (let ((buffer (new-buf 3)))
      (buf-insert #\b buffer)
      (buf-insert #\a buffer)
      (buf-pop buffer)
      (and (char= (buf-next buffer) #\a)
           (= (buf-start buffer) 0)
           (char= (buf-pop buffer) #\a)))))

(deftest test-buf-reset ()
  (check
    (let ((buffer (new-buf 3)))
      (buf-insert #\b buffer)
      (buf-insert #\a buffer)
      (buf-next buffer)
      (buf-next buffer)
      (buf-reset buffer)
      (and (= (buf-start buffer) (buf-used buffer))
           (= (buf-end buffer)   (buf-new buffer))))))

(deftest test-buf-clear ()
  (check
    (let ((buffer (new-buf 3)))
      (buf-insert #\b buffer)
      (buf-insert #\a buffer)
      (buf-pop buffer)
      (buf-next buffer)
      (buf-clear buffer)
      (= -1 (buf-start buffer) (buf-end buffer) (buf-used buffer) (buf-new buffer)))))
