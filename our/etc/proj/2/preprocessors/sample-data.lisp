(defun make-data ()
  (data
   :name   'test-nums
   :columns '($hours $miles $age $minutes valid)
   :egs    '((1      0      24   20       yes)
             (2      1      33   15       yes)
             (3      0      17   30       no)
             (4      1      10   45       yes)
             (5      0      65   45       yes)
             (6      1      26   60       no)
             )))

