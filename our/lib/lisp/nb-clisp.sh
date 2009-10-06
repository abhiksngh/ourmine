#! /usr/bin/clisp

;;load everything
(load "miner")

;;extract lisp stats
(defun extract-stats (statlst learner dataset)
  (dolist (i statlst)
    (format t "~a,~a,~a" dataset learner i)
    (format t "~%")))


;;setup output structure
(extract-stats (abcd-stats (nb (weather_nominal) (weather_nominal)) :verbose nil) 'nb-lisp 'weather.nominal)

      

