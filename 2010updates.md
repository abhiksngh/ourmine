## intro ##
### motivation ###

building learners is easy. once you build some framework for loading data into some ram-based table
structure then its a snap to build new learners- if you understand the vector space model and the
operations that can be performed on it

### the freq count example ###

doing the f count for bayes, b^2/(b+r)

## exam ##

  * define acc, pd, pf, prec, f
    * when would you use each?
    * when would you not use each?
  * given some examples of actual and predicted, calculate acc, pd, pf, prec, f
  * derive a relationship between   pdf, pf ,prec . use that expression to show when prec should be avoided.

  * standard deviation, gini, entropy all measure the same thing
    * what is that thing?
  * define sd, gini, entopy using an equation
    * for what kinds if data would you use each?
  * given a sample of N things, computer their sd, gini, entropy

> <img src='http://chart.apis.google.com/chart?cht=tx&chl=x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}' align='middle'></li></ul>

we want to teach data mining. we want to divide the data mining task into dozens of small functions, that can be mixed and matched as required.  This is useful when:<br>
<br>
<ul><li>trying to improve an existing learner (you can replace the functions with others)<br>
</li><li>in new domains where existing techniques fail, to designing new algorithms<br>
</li><li>during research: when reading a new technique, consider "what table operations does in include, subsume, improve", etc.</li></ul>

<h2>vector space model ##

We have a view that the data more important than the algorithms. Therefore, we view DM as operations on tables of data. Each row of that table is a point in a hyper-dimensional space. Our job is to explore that space to discover its structure.

We therefore structure this class around manipulations to tables (rows and columns) of data. One advantage of this is that data mining is usual the application of dozens of small functions to the tables.

### Base methods ###

  * slice, recursively: oner.
  * build one function per class, classify by returning the class whose function returns the highest value: nb, byperpipes
  * float in, look around (NN) - non-parametric statistics

### Table operations ###

  * rows
    * delete
      * under-sampling
      * instance sampling
      * anomaly detection
        * meta-learning to delete (TEAK)
    * weight
      * kernel functions in NN
    * group
      * clustering. k-means. K++. Genic. Compass. [Mean shift](http://www.google.com/url?sa=t&source=web&cd=1&ved=0CBYQFjAA&url=http%3A%2F%2Fhomepages.inf.ed.ac.uk%2Frbf%2FCVonline%2FLOCAL_COPIES%2FTUZEL1%2FMeanShift.pdf&ei=WVdITNrzI4T48Aab45SBDw&usg=AFQjCNFhj07okkQ7QnPjPpALOcRWhCVRLw&sig2=ei7drlysnHCzezMUfiG7wQ)
    * add
      * use cluster centroids
      * over-sampling
      * prototype generation
      * active learning
  * columns
    * delete
      * feature selection
    * weight
      * fuzzy selection: b^2/(b+r), infogain, tf\*idf
    * group
      * AODE
    * add
      * 2R
      * which
      * classification
        * utility functions (class weighting, n to one)
        * bore: best or rest
      * rotate:
        * PCA
        * [svm kerms](http://www-connex.lip6.fr/~amini/RelatedWorks/svm_intro.pdf)
      * active learning

## buzz words ##

  * [Predictive analytics](http://en.wikipedia.org/wiki/Predictive_analytics)
  * [Business Intelligence](http://en.wikipedia.org/wiki/Business_intelligence)
  * [Map reduce](http://cutting.wordpress.com/2007/07/30/mapreduce-cookbook-for-machine-learning/)

## Background Notes ##

  * http://expdb.cs.kuleuven.be/expdb/index.php
  * Kolmogorov complexity: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.81.3114
  * [Lisp quick index](http://clqr.berlios.de/download.php)

## support vector machines ##

The ideaof SVmachines: map the training data into a higher-
dimensional feature space viaΦ, and construct a separating hyperplane with
maximum margin there.This yields a nonlinear decision boundary in input space.
By the use of a kernel function (1.2), it is possible to compute the separating
hyperplane without explicitly carrying out the map into the feature space.

Figs 1.4 are good and fig 1.5 and fig 1.2

  * http://www-connex.lip6.fr/~amini/RelatedWorks/svm_intro.pdf

## resources ##

  * http://metaoptimize.com/qa/questions/?sort=mostvoted

## evaluation ##

  * http://www.site.uottawa.ca/~cdrummon/pubs/jetai09.pdf

## Org changes ##

  * start with rep grids, nomograms, timm's cheap visualizer, ripple down rules
  * more student control of projects
    * generic project. find a user who cares about something. get rules from them (hypotheses) that reflect their current policies. get data from them. maybe do a GAC and generate at random half way between any parent/child (so higher in the tree is more abstract). learn counter examples. build classifier that learns to pick and reject counter examples (use that as a reality filter on the generator).
  * give them a  text book
  * weekly homeworks (400)
  * give tutorials on my lisp and ourmine
  * active learning: http://hunch.net/~active_learning/

## classifiers ##

  * winnow: http://citeseerx.ist.psu.edu/viewdoc/similar?doi=10.1.1.21.1166&type=ab

## FSS ##

  * SS for continuous classes http://researchcommons.waikato.ac.nz/handle/10289/1024

## Content changes ##

  * adversarial   search : http://www.cs.washington.edu/homes/pedrod/papers/kdd04.pdf
  * discretization: [YangWebb09](YangWebb09.md)

### K-means ###

  * single pass k-menas: (also, a good example of a research paper) :http://www.sigmod.org/disc/disc01/out/websites/kdd_explorations_2/farnstrom.pdf
  * triangle inequality and k-means : http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.14.8422&rep=rep1&type=pdf
  * alternatives to k-meanshhttp://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.6.2789&rep=rep1&type=pdf
  * other classifiers http://citeseerx.ist.psu.edu/viewdoc/similar?doi=10.1.1.125.9225&type=ab

## model trees ##

Incremental Learning of Linear Model Trees
Machine Learning
Issue	Volume 61, Numbers 1-3 / November, 2005
Pages	5-48
Duncan Potts1  and Claude Sammut. 05pottsSammut.pdf

## simpler code ##

```
(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)  (incf ,n) ,@body)))

(defmacro dohash ((key value hash &optional end) &body body)
  `(progn (maphash #'(lambda (,key ,value) ,@body) ,hash)
          ,end))

(defmacro h+ (key hash &optional (n 1))
  `(incf (gethash ,key ,hash ,n)))

;;;;
(defun file->lists (f)
  (with-open-file (str f) 
    (stream->list  str)))

(defun stream->list (str &optional 
                     (line (read-line str nil)))
  (when line
      (cons (string->list line)
            (stream->list str))))

(defun string->list (line)
  (read-from-string
   (concatenate 'string "(" (reverse line) ")")))

;;;;
(defstruct (data (:print-function data-print)) 
  rows 
  (n 0) 
  (classes (make-hash-table)) 
  (h (make-hash-table :test 'equal)))

(defun data-print (d s k)
  (declare (ignore k))
  (format s "#S~a" 
          `(data n ,(data-n d) classes ,(data-classes d))))

(defun file->data (file &optional (label #'identity))
  (lists->data 
   (make-data :rows (file->lists file)) 
   label))

(defun lists->data (dat label)
  (dolist (list (data-rows dat) dat)
    (when list
      (list->data list dat label))))

(defun list->data (list dat label)
  (let ((class (funcall label (first list))))
    (incf (data-n dat))
    (h+ class (data-classes dat))
    (doitems (one n (rest list))
        (h+ `(,class ,n ,one) (data-h dat)))))

(defun vowelp (x) (member x '(a e i o u)))

;;;;
(defun test1 ()
  (file->data  
   "letter.dat"
   #'(lambda (x)
       (if (vowelp x) 1 0))))

(test1)
```