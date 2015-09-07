

# To do #

For proj2

  * implement at least one of each of the _basic_ pre-processor, discretizer, clusterer, classifier, feature subset selector.
  * Also, port my NaiveBayes code into your rig (so it can be compared to everything else).
  * For 2\*F bonus marks, code up F more   functions
    * no more than F=3
    * no more than two of the ones marked EASY.
    * HINT: there are common inference patterns in the following functions. With a little lambda abstraction you should be able to implement MULTIPLE functions using the same LISP code (but called using slightly different functions).
  * Note, unless it is for bonus marks, once one group picks a function no other group can pick the same one.

For proj3,  not sure of the details yet but it will probably be implementing another pre-processor, discretizer, clusterer, classifier, feature subset selector, run all 32 combinations, do an evaluation experiment.

# Details #

By the end of proj2 and proj3, every group will have implemented:

  * at least two pre-processors
  * at least two discretizers
  * at least two clusterers
  * at least two classifiers
  * at least two feature subset selectors.

Note that:

  * There are some magic numbers associated with each of the above  functions- assume three settings for each different data miners.
  * Which you'll repeat 10 times;
  * Over 10 data sets
  * This means that, before the end of term, you'll have to run this code for `10*10*3^5^*2^5=777,000` combinations. Tee hee!

Future projects will comparatively assess these 20,000+ possible data miners. This project will just get you started.

You will assume that there exists two files "train.lisp" and "test.lisp" containing data in the same format (same number of columns, and if a column is numeric/discrete in one, it is numeric/discrete in the other).

To run the code, your main function must be

```
(defun learn (&key (k            8)
                   (prep         #'normalizeNumerics)
                   (discretizer  #'10bins)
                   (cluster      #'(lambda (data) (kmeans k data)) 
                   (fss          #'infoGain)
                   (classify     #'naiveBayes)
                   (train        "train.lisp")
                   (test         "test.lisp"))
      (let ((training (load train))
           ((testing  (load test)))
       ...
     ; first prep train and test
     ; then run the discretizer
     ; then cluster the training set into k clusters
     ; the do FSS on each cluster 
     ; then on the remaining attributes, train a classifier for each cluster
     ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifier
```

Note that, in the above, if you only generate k=1 cluster than means you skip
clustering and just use all the data.

When you do the classifying for the testing, you must keep four separate counts, for each class X in the test set.


  * A: the number of test things  that are NOT class=X which were NOT classified as class=X
  * B: the number of test things  that ARE class=X which were NOT classified as class=X
  * C: the number of test things  that ARE class=X where were NOT classified as class=X
  * D: the number of test things  that ARE class=X where were classified as class=X

If you like pictures, A,B,C,D, comes from this matrix:
```
                  oh no it ain't    oh yes, it is   
                  |--------------|----------------|
detector said no  |     A        |       B        |
                  |--------------|----------------|
detector said yes |     C        |       D        |
                  |--------------|----------------|
```

Note that the above numbers change from class to class. So the above table must  be computed for each class, independently.

Fro these numbers, the following measures can be computed:

  * prec= precision   = D / (C+D)
  * acc= accuracy   = (A+D) / (A+B+C+D)
  * pd= probability of detection   = pd = D / (B+D)
  * pf= probability of false alarm   C / (A+C)
  * f= f-measure = 2(prec)(recall) / (prec + recall)
  * g= g-measure = 2(pf)(pd)  / (pf+pd)

Your output must be comma separated lines, one for each class in test set.

```
prep,discretizer, cluster,fss,classify, class,a,b,c,d,acc,prec,pd,pf,f,g <NEWLINE>
```

e.g.

```
#prep,discretizer, cluster,fss,classify, class,     a,	b,	c,	d,	acc,	prec,	pd,	pf,	f,	g
normalize,bin10,kmeans/5,infoGain,naiveBayes,happy, 10,	20,	30,	40,	50.0,  57.1,	66.7,	75.0,	61.5,	70.6,
doNothing,bin10 ,kmeans/5,infoGain,naiveBayes,happy,11,	1,	1200,	300,	20.6,	20.0,	99.7,	99.1,	33.3,	99.4
...
```


## How to Pick Test Data ##

You need data sets with discrete classes; see  http://code.google.com/p/ourmine/source/browse/trunk/our/lib/lisp/tests/data/

Make sure you use  big and little data sets (little to debug on, big to try out your scale up).

You need easy and hard data sets. To find a range of easy/hard, look at:

![http://iccle.googlecode.com/svn/trunk/share/img/bayesVsOthers.png](http://iccle.googlecode.com/svn/trunk/share/img/bayesVsOthers.png)

# Functions #

Note that the following list is very long (46 items). But you only need to code up five of them.

## Pre-processors ##

Pre-processors handle certain common set-up tasks.

  1. (EASY) Fill out:
    * Replace X% of the cells in each row with "?" (not the class variable).
  1. (EASY) Fill in:
    * Replace all "?" with the most common symbol (in discrete columns) or the median value (in numeric columns) for rows of that class.
  1. (EASY) Normalize:
    * Normalize all numerics zero to one.
  1. (EASY) BORE (best or rest):
    * Take a data set with a numeric class and discrete it into 20% "best" and 80% "rest" scores.
  1. Ucube (normalize + BORE):
    * Derive a class by taking 3 normalize numeric values, mapping them into a 1\*1\*1 cube, then take all instances and place them in that cube, then compute the distance of each instance from "heaven" (best values on the axes) then divide those distances into 20% "best" and 80% "rest"
  1. Sub-sample
    * During training, find the minority class and throw away instances (at random) from the other classes till all classes have the same frequency. Use the learner trained on this sub-sample on the test data (without sub-sampling)
  1. Super-sample (for binary classes only)
    * During training, find the minority class and randomly repeat its rows till it has the same frequency as the next most common class.   Use the learner trained on this super-sample on the test data (without super-sampling)
  1. Best(k)
    * Given some performance measure and N training examples remove 20 training instance (at random) then for k=1 to N-1 for a conclusion by polling the k-th nearest neighbors. Return the k value that maximizes the performance score.
  1. Roll your own
    * But clear it with the lecturer first.

## Discretizers ##

Discretizers take numeric ranges and chop them up into a handful of bins (typically, less than 20, often between 2 and 8). Think of them like a condenser:
  * some signal is spread out thinly like drops of water across a bunch of numbers
  * discretization compresses that signal into a small number of bins
  * at which point the signal condenses and becomes visible.

  1. (EASY) N-bins (equal-width discretization)
    * Find max and min of each numeric columns. Replace number X with `round(N*(X - min)/(max-min))`
  1. (EASY) bin-logging
    * Same as N-bins but "N" is set to the log of the number of unique values.
  1. (EASY) N-chops (equal-frequency discretization)
    * Sort the numbers, find the number at the end of the first N% of the data, call that break1. Until the next smallest number is different to break1, walk up the list. Find the number at the next N% of the data, call that break2.  Until the next smallest number is different to break2, walk up the list. Etc. Go back over the data: everything underneath break1 is in bin1, the remainder underneath break2 is in bin2, etc.
  1. (EASY) Normal-chops
    * Assume data is Gaussian and divide into -3, -2, -1, 0, 1,2,3 standard deviations away from the mean. Hint: see lisp/tricks/normal.lisp
  1. (EASY) PKID
    * See http://iccle.googlecode.com/svn/trunk/share/pdf/YangWebb03.pdf
  1. ONERd
    * Sort each numeric attribute, along with its associated class.
    * Place the first 6 instances in bin1.
    * Grow bin1 as long as the majority class in bin1 remains constant.
    * Repeat for the rest of the data.
  1. Recursive supervised discretization:
    * See https://list.scms.waikato.ac.nz/pipermail/wekalist/2004-October/002988.html
    * Compute the gain of each split using ∑<sub>i</sub>(p<sub>i</sub><sup>2</sup>`*`log(p<sub>i</sub>))  where
      * p<sub>i</sub> is the number of instances of class "I" divided by the number of instances in this split
  1. Roll your own
    * But clear it with the lecturer first.

## Clusterers ##

Clusters group together related rows.

  1. K-means
    * Pick k instances at random and call them centroids0. Mark each instance with its closest centroid0. Move each centroid to the median position of its marked instances. Repeat till centroids stop moving.
  1. K-means++
    * Same as K-means but take care when selecting the initial centroids (try to keep them far apart).
    * Pick one instance at random.
    * Label each remaining instance with the (D/maxD)<sup>2</sup>: the  square of the normalized  distance to pick1 divided by max distance.
    * Repeat until you find K-1 more centroids:
      * Pick an instance at random
      * Make it a centroid if  rand() > (D/max)<sup>2</sup> (this favors centroids that are, on average, 75% away from the initial centroid).
  1. GENIC
    * See http://code.google.com/p/ourmine/wiki/Gg#Gupta
  1. GENIC2
    * Same as GENIC but be adaptive on the number of clusters returned. Start with K=10 centroids. At each era, prune any that are weighted less than 0.5\*maxWeight. If no  centroids are pruned, set K to K`*`1.5.
  1. Recursive 2-means.
    * Apply 2-means, then re-apply it to both generated clusters. Stop when the size of the sub-clusters is below a certain threshold or the diversity of the clusters is too small (diversity measured using entropy: ∑<sub>i</sub>(p<sub>i</sub><sup>2</sup>`*`log(p<sub>i</sub>))  where  p<sub>i</sub> is the number of instances of class "I" divided by the number of instances
  1. GAC (Greedy Agglomerative Clustering.)
    * Move each instance to its nearest pair and create an artificial instance halfway between them. Repeat until you form a binary tree.
  1. IPO
    * Given the range of discretized data, generate a small number of centroids equidistant across the space of possible centroids. The _IPO_ function, shown below, builds centroids with the property that no two centroids share the same pair of values.
      * For example, `(ipo '(2 3 1))`  returns
```
           ((0 3 2 0) (0 3 1 0) (0 2 2 0) (0 2 1 0)  
            (0 1 2 0) (0 1 1 0) (3 0 2 0) (3 0 1 0)  
            (2 0 2 0) (2 0 1 0) (1 0 2 0) (1 0 1 0)) 
```
      * This pairwise heuristic is very powerful. Data sets with 100 binary attributes generate 15 centroids and 20 attributes with a range of 10 generate around 200 centroids. For more details, see the table at the bottom of http://pairwise.org/tools.asp.
    * Make each of these a cluster.
    * Perform GAC to build an index over those clusters.
    * Amazingly, all this can be done _before you see any data_.
  1. GAC-prune
    * Same as GAC, then descend the tree and replace certain  sub-trees with the median performance statistic within those sub-trees. Replace sub-trees that have
      * very low diversity (so their conclusion is nearly certain)
      * or very high variance (you won't trust those).
  1. IPO-prune
    * Same as GAC-prune but the tree is built before seeing any data and the pruning happens after see the data.
  1. GRID
    * Impose a coarse grained mesh over the data (e.g. using N=10bins or IPO) and sort each bucket in the mesh by the density of items in that bucket. Take the densest bucket and while there exist a (transitive) neighbor with densities less than or equal to that bucket, add it into that bucket. For more details, see http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.53.9395 .
  1. Roll your own
    * But clear it with the lecturer first.

## Feature Subset Selection ##


Feature subset selectors throw out irrelevant columns.

  1. InfoGain
    * Rank each column by dividing up its values into different classes. Rank each column by ∑<sub>i</sub>(p<sub>i</sub><sup>2</sup>`*`log(p<sub>i</sub>)). Reject columns that have less than X% of the maximum InfoGain.
  1. Relief:
    * See notes, below.
  1. B-squared
    * Replace each class symbol with a utility score (lower score = higher utility).
    * Sort instances by that score and divide them using N=20%-chops.
    * Label all the rows in bin=1 "best" and the remaining "rest".
    * Pretend you are doing NaiveBayes and collect the frequencies of ranges in best/rest.
    * Sort each range (r) by b^^2/(b+r) where
      * b = freq(r in Best) / SizeOfBest
      * r = freq(r in Rest) / SizeOfRest
      * btw, if b < r, then b = 0.
    * Sort each attribute by the median score of b<sup>2</sup>/(b+r).
    * Reject attributes with les than X% of the max. median score.
  1. Nomograms:
    * Same as B-squared  but score r using odds ratio log(b)/log(r)
    * For examples of ranges sorted on log of odds ratio, see below.
    * btw,
      * if b < r, then log(oddsRatio) = 0.
      * if log(oddsRatio) less than N% of max log(oddsRatio), then log(oddsRatio) = 0.
      * if b too small (how small?) then ignore it.
  1. Roll your own
    * But clear it with the lecturer first.

## Classifiers ##

Classifiers make decisions.

  1. NaiveBayes
  1. 2B (a.k.a. AODE)
    * Same as NaiveBayes but as a pre-processor, take N columns and create a new data by combining all pairs to make N<sup>2</sup>/2-N new attributes.
  1. K-th nearest neighbor
    * post-processor to clustering. The classification on the test instance comes from a poll of the k-th nearest instances in the training set.
  1. EKREM-C
    * Post-processor to EKREM. Recursively move test instances to the nearest neighbor in the pruned GAC tree. Return the leaf median value and a measure of trust in that sub-tree.
  1. EKREM-prune-C
    * Same as EKREM-C but this is a post-processor to EKREM-prune.
  1. IPO-C
    * Post-processor to C. Recursively move test instances to the nearest neighbor in the pruned GAC tree. Return the leaf median value and a measure of trust in that sub-tree.
  1. IPO-prune-C
    * Same as IPO-C but this is a post-processor to IPO-prune.
  1. OneR
    * Select for classes using one attribute.
    * Note: "missing" is treated as a separate attribute  value.  For more details, see  http://code.google.com/p/ourmine/wiki/Hh#Holte93
```
For each attribute, 
	For each value of the attribute, make a rule as follows: 
		count how often each class appears 
		find the most frequent class 
		make the rule assign that class to this attribute-value 
	Calculate the error rate of the rules (see example at bottom)
Choose the rules with the smallest error rate 
```
  1. TwoR
    * Same as OneR but as a pre-processor, take N columns and create a new data by combining all pairs to make N<sup>2</sup>/2-N new attributes.
    * For more detail, http://www.cs.waikato.ac.nz/~ihw/papers/95NM-GH-IHW-Develop.pdf
  1. PRISM
    * [PRISM1](AlgorithmPrism.md) .
  1. PRISM2
    * [PRISM1](AlgorithmPrism.md) runs through the attributes in any order. PRISM2 first discards all attribute ranges that score badly on (say) InfoGain, Relief, B-squared or nomograms., etc.
  1. PRISM2-B
    * This is PRISM2-B using B-squared as its FSS, and  each rule is scored using pre-computed frequency counts, without running over the data.
      * Given a rule of the form if(A<sub>1</sub>=V<sub>1</sub> and A<sub>2</sub>=V<sub>2</sub> and ... then class<sub>c</sub>)
      * then its score is L<sub>c</sub><sup>2</sup>/(L<sub>c</sub> + L<sub>not(c)</sub>)
      * where L<sub>c</sub>=p<sub>c</sub>`*`PROD<sub>i</sub>`*`freq(A<sub>i</sub>=V<sub>i</sub> in class<sub>c</sub>)/(number of class<sub>c</sub> entries)
  1. Roll your own
    * But clear it with the lecturer first.

# Appendix #

## IPO ##
```
(deftest test-ipo()
  (let ((factors (ipo '(3 3 2 2))))
(check
 (equalp '((2 3 1) (2 2 1) (2 1 1) (1 3 1) (1 2 0) (1 1 0))
	 (ipo '(2 3 1)) )	
 (equalp  '((0 3 2 0) (0 3 1 0) (0 2 2 0) (0 2 1 0) (0 1 2 0) 
	    (0 1 1 0) (3 0 2 0) (3 0 1 0) (2 0 2 0) (2 0 1 0) 
	    (1 0 2 0) (1 0 1 0))   
	  (generate-pairs 2 '(3 3 2 2)))
 (equalp 1000000 (match-pat '(0 3 2 0) '(1 1 0 0)))
 (equalp 1 (match-pat '(1 1 2 0) '(1 1 0 0)))
 (equalp 0 (match-pat '(1 1 0 0) '(1 1 0 0)))	
 )))

(defun ipo (factors)
  "From a list of ranges, generate test cases for each range
  using  Lei & Tai PairTest function for generating pairwise tests 
  in-parameter-order. By Andy Barrett"
  (let (tests)
   ;; for the first two parameters p1 and p2
    (dotimes (i (car factors))
      (dotimes (j (cadr factors))
        (let ((test (make-list (length factors) :initial-element 0)))
          (setf (car test) (+ 1 i))
          (setf (cadr test) (+ 1 j))
          (push test tests))))
    (loop for i from 2 to (- (length factors) 1) do
	 (let ((api (generate-pairs i factors))
	       (s (min (nth i factors) (length tests)))
	       (j 0))
	   ;; horizontal growth using IPO_H_IV
	   (dolist (tst tests)
	     (if (< j s)
		 (setf (nth i tst) (incf j))
		 (let ((api-p nil)
		       (v-p nil))
		   (dotimes (v (nth i factors))
		     (setf (nth i tst) (+ 1 v))
		     (let ((api-pp (remove-if #'(lambda (pat) (< 0 (match-pat pat tst))) api)))
		       (when (> (length api-pp) (length api-p))
			 (setf api-p api-pp)
			 (setf v-p v))))
		   (setf (nth i tst) (if v-p (+ 1 v-p) 0))))
	     (setf api (remove-if #'(lambda (pat) (= 0 (match-pat pat tst))) api)))          ;; vertical growth using IPO_V
	   (dolist (p api)
	     (let ((tst (find-if #'(lambda (v) (> 20 (match-pat p v))) tests)))
	       (if (null tst) (setf tests (append tests (list p)))
		   (do ((a tst (cdr a))
			(b p (cdr b)))
		       ((null a) nil)
		     (when (not (zerop (car b)))
		       (setf (car a) (car b)))))
	       ))))
    (check-tests factors tests)
    tests))

(defun generate-pairs (i factors &aux (ret nil))
  "Generate all tuples that use the Ith factor"
  (dotimes (j i ret)
   (dotimes (v1 (nth j factors))
     (dotimes (v2 (nth i factors))
       (let ((pair (make-list (length factors) :initial-element 0)))
         (setf (nth j pair) (+ 1 v1))
         (setf (nth i pair) (+ 1 v2))
         (push pair ret))))))

(defun match-pat (pat vec &aux (cost 0))
  "Match a pattern (a tuple) against a test vector to see if the
vector can be modified to include the tuple."
  (do ((p pat (cdr p))
      (v vec (cdr v)))
     ((or (null p) (null v) (<= 5000 cost)) cost)
   (when (not (or (zerop (car p)) (= (car p) (car v))))
     (setf cost (if (zerop (car v)) (+ 1 cost) 1000000)))))

(defun check-tests (factors tests)
  "Check to make sure that TESTS is a solution."
 (dotimes (i (length factors) t)
   (dolist (pair (generate-pairs i factors))
     (when (null (find-if
                  #'(lambda (tst) (zerop (match-pat pair tst)))
		  tests))
       (format t "missing pair ~a~%" pair)
       (return-from check-tests nil)))))
```

## Relief ##


  * [Kononenko97](http://code.google.com/p/ourmine/wiki/Kk#Kononenko97)
  * useful attributes differentiate between instances from other class
  * randomly pick some instances (here, 250)
  * find something similar, in an another class
  * compute distance this one to the other one
  * Stochastic sampler: scales to large data sets.
  * Binary RELIEF (two class system) for "n" instances for weights on features "F"
```
      set all weights W[f]=0
      for i = 1 to n; do
         randomly select instance R with class C
         find nearest hit H      // closest thing of same class
         find nearest miss M     // closest thing of difference class
         for f = 1 to #features; do
             W[f] = W[f] - diff(f,R,H)/n + diff(f,R,M)/n
         done
      done
```
  * computing "diff":
> > o discrete differences: 0 if same 1 if not.
> > o continuous: differences absolute differences
> > o normalized to 0:1
> > o When values are missing, see Kononenko97, p4.
  * N-class RELIEF: not 1 near hit/miss, but k nearest misses for each class C
```
      W[f]= W[f] - ∑i=1..k diff(f,R, Hi) / (n*k) 
                 + ∑C ≠ class(R) ∑i=1..k ( 
                                      P(C) / ( 1 - P(class(R)))
                                      * diff(f,R, Mi(C)) / (n*k)
                                     )
```
> > The P(C) / (1 - P(class(R)) expression is a normalization function that
> > > o demotes the effect of R from rare classes
> > > o and rewards the effect of near hits from common classes.

## Some ranges, scored on log(oddsRation) ##

![http://iccle.googlecode.com/svn/trunk/share/img/nomofss.png](http://iccle.googlecode.com/svn/trunk/share/img/nomofss.png)

## OneR example ##

<img width='300' src='http://ourmine.googlecode.com/svn/trunk/share/img/onerdata.png'>

<img width='300' src='http://ourmine.googlecode.com/svn/trunk/share/img/onererr.png'>