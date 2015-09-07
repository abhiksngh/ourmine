

# Mission #

Your mission is to report either show the presence or prove the absence of a general theory of defect prediction, learned from the NASA (USA) and SoftLab (Turkey) data sets.
Your challenge, which is up to you, is to come up with some visualization that illustrates stability (or instability) in the learned theories.

Every group has to do the [setup](http://code.google.com/p/ourmine/wiki/Cs573proj2#Set_up),

After that, it s a free for all trying to find what learners + row/column pruning leads to stablest theories.

When we do demos for this project, I will be looking for two products:
  1. deftests: You'll all have to write deftests that demonstrate that:
    * the setup code is working
    * your preferred data reducer(s) are working.
  1. Report (preliminary reports); You also need to include a pdf in branch/ProjNumber/proj2/report.pdf in the format of the ACM conference "tighter" papers http://www.acm.org/sigs/publications/proceedings-templates.
    * 10 pages max, 2 column.
    * Include a bibliography and pseudo-code for any algorithms you use.


# Set up #

## Create Your Data Sets ##

You need to hand-convert some data to LISP:
  * all the  arff files in http://unbox.org/wisp/trunk/ourmine/2.0/lib/arffs/softlab/
  * all the SHARED arff files into http://code.google.com/p/ourmine/source/browse/trunk/our/arffs/promise/ into our LISP format

## Build Some Pre-Processors ##

You'll need to code the following tools:
  * a pre-processor that replaces numeric value _N_ with
    * `log(N< 0.0001 ? 0.0001 : N)`
  * a pre-processor that builds a new "(data) call from N existing data sets
  * a pre-processor  that splits one "(data)" into 10 bins, then
    * builds a train "(data)" from 90% of the data
    * "(test)' data from 10% of the data.
    * Note that the distribution of classes in "train/test" should be similar to the original data set
  * a nearest-neighbor tool that finds the k-th nearest examples from example1 in some "(data)" set. For this you will need
    * A "normalizer" that reduces all numerics to min..max zero..one
    * A "bestK" tool
      * Given some performance measure (use "g") and N training examples remove 20 training instance (at random) then for k=1 to N-1 for a conclusion by polling the k-th nearest neighbors. Return the k value that maximizes the performance score.

## Build Output Tools ##

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

# Build Small Data Sets #

For us to check of there is theory stability, it is wise to reduce the size of the training set (and so generate a small theory).

Recall that there are two kinds of data reduction methods: row pruners and column pruners.

I don't know if any of these are useful, but  in your quest for stable theories,
you may need to try them all

## Reducing Rows ##

Methods for reducing the size of the data set (from http://menzies.us/pdf/08ceiling.pdf):
  * Sub-sample
    * During training, find the minority class and throw away instances (at random) from the other classes till all classes have the same frequency. Use the learner trained on this sub-sample on the test data (without sub-sampling). See [Figure 3](http://menzies.us/pdf/08ceiling.pdf).
    * Special case: micro-sampling :
      * Select N defect classes at random. Select N non-defect classes at random
      * See results in [section 3.2](http://menzies.us/pdf/08ceiling.pdf).

Methods for reducing the size of the data set (from http://menzies.us/pdf/08ccwc.pdf):
  * The Burak filter
    * For all T test instances, find the 10 nearest instances in the train set
    * Train a NaiveBayes on  that set of T\*10 instances, remove duplicates

Yet another idea:
  * The super-Burak filter
    * Find the union of the T\*10 test instances for D data sets.
    * Delete all instances not in that union.

## Reducing Columns ##

Note that you'll be after reductions that hold true for multiple data sets. Which means you don't InfoGain (problems with log(p) for low p) but ones that use support-based pruning:

  * B-squared
    * Replace each class symbol with a utility score (lower score = higher utility).
    * Sort instances by that score and divide them using N=20%-chops.
    * Label all the rows in bin=1 "best" and the remaining "rest".
    * Pretend you are doing NaiveBayes? and collect the frequencies of ranges in best/rest.
    * Sort each range (r) by b^^2/(b+r) where
> > > o b = freq(r in Best) / SizeOfBest?
> > > o r = freq(r in Rest) / SizeOfRest?
> > > o btw, if b < r, then b = 0.
> > > o if b under some magic value, then ignore them
    * Sort each attribute by the median score of b2/(b+r).
    * Reject attributes with les than X% of the max. median score.
  * Greedy forward select
    * Find the next best attribute to add
  * Greedy back select
    * Find the next best attribute to delete

## Learners ##

See if you can build/find a learner that has stable conclusions across the N data sets.
Learners are:

  * Instance-based (already taken: Aaron and Adam2)
  * NaiveBayes
  * PRISM (with the search-space reduced by FSS).
  * WHICH (see the appendix, and http://menzies.us/pdf/08which.pdf)

# Appendix: WHICH #

The WHICH  rule learner loops over the space of possible feature ranges, evaluating
various combinations of features.

  1. WHICH maintains a stack of of combinations of features, sorted by an evaluation criteria P.
  1. Initially, WHICH's "combinations" are just each range of each feature. Subsequently, they can create conjunctions of two or more features.
  1. Two combinations are picked at random, favoring those combinations that are ranked highly by P .
  1. The two combinations are themselves combined, scored, then sorted into the stacked population of prior combinations.
  1. Go to step 1.

