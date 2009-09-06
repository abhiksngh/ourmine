;;;; CHAPTER 7

;; setting a pathname

(deftest test-path()
  (let ((myfile "myfile"))
    (check
      (setf path (make-pathname :name myfile)))))


;; to create a stream on which you can write to a file (overwrite if file exists)
(deftest test-write-str()
    (check
      (setf str (open path :direction :output
		      :if-exists :supersede))))

;; read from a file
(deftest test-read-str()
  (check
    (setf str (open path :direction :input))))


(deftest test-format-nil()
  (check
    (samep (format nil "Dear ~A, Our records indicate..." 
	    "Mr. Mensah") "Dear Mr. Mensah, Our records indicate...")))


;;;; OPERATIONS ON RING BUFFERS

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

;; create a buffer
(deftest test-new-buf()
  (let ((size 5))
    (check
      (setq mybuf (new-buf size)))))

; initialize a global buffer called mybuffer
;(setq mybuffer (new-buf 5))

;; insert A into the buffer
(defun buf-insert (x b)
  (setf (bref b (incf (buf-end b))) x))

(deftest test-buf-insert()
  (check
    (eql 'a (buf-insert 'a (new-buf 5)))))


(defun buf-pop (b)
  (prog1
      (bref b (incf (buf-start b)))
    (setf (buf-used b) (buf-start b)
	  (buf-new b) (buf-end b))))

; A should be popped out from the buffer
(deftest test-buf-pop()
  (let* ((mybuff (new-buf 5)))
    (buf-insert 'a mybuff)
    (check
     (eql 'a (buf-pop mybuff)))))


(defun buf-next (b)
  (when (< (buf-used b) (buf-new b))
    (bref b (incf (buf-used b)))))

;;; don't test this
;(deftest test-buf-next()
 ; (let* ((mybuff (new-buf 5)))
  ;  (buf-insert 'a mybuff)
   ; (check
    ; (buf-next mybuff))))

(defun buf-reset (b)
  (setf (buf-used b) (buf-start b)
	(buf-new b) (buf-end b)))

(deftest test-buf-reset()
  (let* ((mybuff (new-buf 5)))
    (buf-insert 'a mybuff)
    (check
     (eql 0 (buf-reset mybuff)))))

(defun buf-clear (b)
  (setf (buf-start b) -1 (buf-used b) -1
	(buf-new b) -1 (buf-end b) -1))

(deftest test-buf-clear()
  (let* ((mybuff (new-buf 5)))
    (buf-insert 'a mybuff)
    (check
     (eql -1 (buf-clear mybuff)))))
