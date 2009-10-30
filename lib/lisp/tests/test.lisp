 (defun weather ()
	(data
	 :name 'weather
	 :columns '( outlook $temperature $humidity windy play)
	 :egs
	 '(			
	   ( sunny 69 70 FALSE yes )
           ( sunny 75 70 TRUE yes )
           ( overcast 64 65 TRUE yes )
           ( rainy 70 96 FALSE no)
           ( sunny 80 90 TRUE no)
           ( sunny 85 85 FALSE no )
           ( sunny 72 95 FALSE yes )
           ( rainy 65 70 TRUE yes )
           ( rainy 68 80 FALSE no )
           ( rainy 71 91 TRUE no )
	   )))

