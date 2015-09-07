

(Acknowledgment : large parts of the this lecture were taken from Eibe Frank's excellent notes from the WEKA textbook.)

# Why learn rules? #

  * small independent chunks of knowledge
  * can be easy to explain
  * e.g
    * if THIS then THAT
    * if ANTECEDENT then CONSEQUENCE
    * if LHS then RHS


# Execution #

Two ways of executing a rule set:
  * Ordered set of rules (decision list)
    * Order is important for interpretation
  * Unordered set of rules
    * Rules may overlap and lead to different conclusions for the same instance

What if two or more rules conflict?
  * Give no conclusion at all?
  * Go with rule that is most popular on training data?
  * ...

What if no rule applies to a test instance?
  * Give no conclusion at all?
  * Go with class that is most frequent in training data?
  * ...

# OneR #

It doesn't get simpler than this...

Discretize the data

  * Sort each numeric attribute, along with its associated class.
  * Place the first 6 instances in bin1.
  * Grow bin1 as long as the majority class in bin1 remains constant.
  * Repeat for the rest of the data.

Select for classes using one attribute.
  * Note: "missing" is treated as a separate attribute value. For more details, see http://code.google.com/p/ourmine/wiki/Hh#Holte93
```
For each attribute, 
     For each value of the attribute, make a rule as follows: 
             count how often each class appears 
             find the most frequent class 
             make the rule assign that class to this attribute-value 
      Calculate the error rate of the rules (see example at bottom)
Choose the rules with the smallest error rate 
```

## Example ##
![http://ourmine.googlecode.com/svn/trunk/share/img/onerdata.png](http://ourmine.googlecode.com/svn/trunk/share/img/onerdata.png)

![http://ourmine.googlecode.com/svn/trunk/share/img/onererr.png](http://ourmine.googlecode.com/svn/trunk/share/img/onererr.png)

## TwoR ##

Same as OneR but as a pre-processor, take N columns and create a new data by combining all pairs to make N2/2-N new attributes.
  * For more detail, http://www.cs.waikato.ac.nz/~ihw/papers/95NM-GH-IHW-Develop.pdf

## NR ##

  1. Find the top sqrt(N) attributes (scored using the OneR rule)
  1. Combine to form N=sqrt(N)<sup>2</sup> new attributes
  1. Go to 1

# Stochastic Rule Generation #

## Treatment Learning ##

  * Ying Hu, UBC, 2003.
  * Ryan Clarke, OSU, 2005
  * Greg Gay, WVU, 2009

Pass 1:

  * Discretize

Pass 2:

  * Each attribute range is one test
  * Score each test (how?)

Pass 3:

  * RULES=()
  * Repeat till no new best rules seen in F (futile) number of trials
    * Repeat M times
      * Pick the number of tests at random between 1 and Tests
      * Select that number of tests, at random,
      * favoring those tests with high score
      * Score each rule (how?)
    * Find the N best rules
      * RULES1 = union(RULES,BEST)
      * if size of RULES1 == RULES
        * then Futile++
        * else Futile=0 and RULES = RULES1
  * return RULES

How to score each test (in Pass 2)

  * TAR3: by "lift"
  * give classes have a utility
    * As Is = sum(classFrequency `*` classWeight) for all examples
    * To Be = sum(classFrequency `*` classWeight) for examples selected by rules
    * Lift = To Be/As Is
      * if less than one, then BAD RULE
    * note: fast since can be done over single-attribute range frequency counts

How to score each rule (in Pass 3)

  * TAR3: by lift
    * note: not so fast since required one pass over training data per rule
      * worse, it is repeated at least F `*` M times
  * TAR4.0
    * assumed a two-class system
      * e.g. BORE pre-processing
    * treated each rule test as an example passed to a Bayes classifier
      * scored each rule test by the probability that it belonged to the best class
      * likelihood of _X= (X<sub>1</sub>  and X<sub>2</sub> and ...)_
        * `{* L(X|C) = #C/All * #X_1/C * #X_2/C * ...`
      * For a two-class system, lift is the probability that _X_ selects for _best_ class, not _rest_  class
        * L(best) / (L(best) + L(rest))
    * note1: fast since can be done over single-attribute range frequency counts
    * note2: performed much worse that TAR3
      * rules had much lower lifts
      * of course TAR4.0 failed
        * single attribute probability functions say little about joint probabilities
  * TAR4.1
    * scored each rule test by probability **support in the frequency table
      * used likelihood as the support guess-timate
      * L(best)<sup>2</sup> / (L(best) + L(rest))
    * returned (very nearly) the same rules as TAR3
      * Why?
      * If you stay away from rarely visited corners of the training data,
        * then single attribute probability functions predict for joint probabilities
    * Important:
      * TAR4.1 did not need to run each rule through the training set
      * so, used orders of magnitude less memory than TAR3
      * so, ran one order of magnitude faster than TAR3**

![http://www.csee.wvu.edu/~timm/cs591o/old/images/tar4mem.png](http://www.csee.wvu.edu/~timm/cs591o/old/images/tar4mem.png)

![http://www.csee.wvu.edu/~timm/cs591o/old/images/tar4speed.png](http://www.csee.wvu.edu/~timm/cs591o/old/images/tar4speed.png)

### Example 1, TAR3 ###
```
mkdir tar3
cd tar3
svn export http://unbox.org/wisp/tags/tar/3.0/c/ tar3.0
cd tar3.0
make
cd eg
PATH="$PATH:/home/timm/bin/wisp" ./1

-------------------------------------------------------------------
                Welcome to TARZAN (Version 3.0)
        Copyright (c) 2001 Tim Menzies (tim@menzies.com)
              Copy policy: GPL-2 (see www.gnu.org)

...while on high, our hero watches for the right chance to strike!
-------------------------------------------------------------------

default: NOW=true
default: CHANGES=true
Config: granularity  2
        maxNumber    10
        minSize      1
        maxSize      4
        randomTrials 50
        futileTrials 5
        bestClass    50.00%


Read 506 cases (13 attributes) from ../data/HOUSING/housing.data

 Worth=1.000000
 Treatment:[No Treatment]

             low:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [   148 - 29%] 
          medlow:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   [   146 - 29%] 
         medhigh:~~~~~~~~~~~~~~~~~~~~~           [   108 - 21%] 
            high:~~~~~~~~~~~~~~~~~~~~~           [   104 - 21%] 

Confidence1 Distribution:

 -10:~~~~~~~~~~~~~~~~~~~~            [     2 -  8%] 
  -9:~~~~~~~~~~                      [     1 -  4%] 
  -8:~~~~~~~~~~                      [     1 -  4%] 
  -6:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [     3 - 12%] 
  -5:~~~~~~~~~~                      [     1 -  4%] 
  -4:~~~~~~~~~~~~~~~~~~~~            [     2 -  8%] 
  -1:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [     3 - 12%] 
   0:~~~~~~~~~~~~~~~~~~~~            [     2 -  8%] 
   2:~~~~~~~~~~~~~~~~~~~~            [     2 -  8%] 
   3:~~~~~~~~~~                      [     1 -  4%] 
   4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [     3 - 12%] 
   5:~~~~~~~~~~                      [     1 -  4%] 
   6:~~~~~~~~~~                      [     1 -  4%] 
   7:~~~~~~~~~~                      [     1 -  4%] 
   8:~~~~~~~~~~                      [     1 -  4%] 
  10:~~~~~~~~~~                      [     1 -  4%] 

10 Treatments  learned after 36 random trials

 1 worth=1.959372       [INDUS=[0.460000..9.690000)] [PTRATIO=[12.600000..19.100000)] [RM=[6.209000..8.780000]] [LSTAT=[1.730000..11.380000)] 
 2 worth=1.948271       [RM=[6.209000..8.780000]] [ZN=[12.500000..100.000000]] [PTRATIO=[12.600000..19.100000)] [LSTAT=[1.730000..11.380000)] 
 3 worth=1.945428       [TAX=[187.000000..330.000000)] [RM=[6.209000..8.780000]] [INDUS=[0.460000..9.690000)] [PTRATIO=[12.600000..19.100000)] 
 4 worth=1.935531       [ZN=[12.500000..100.000000]] [INDUS=[0.460000..9.690000)] [RM=[6.209000..8.780000]] [PTRATIO=[12.600000..19.100000)] 
 5 worth=1.927808       [PTRATIO=[12.600000..19.100000)] [INDUS=[0.460000..9.690000)] [RM=[6.209000..8.780000]] 
 6 worth=1.919925       [PTRATIO=[12.600000..19.100000)] [RM=[6.209000..8.780000]] [INDUS=[0.460000..9.690000)] [CHAS=[0.000000..1.000000)] 
 7 worth=1.911425       [AGE=[2.900000..77.699997)] [INDUS=[0.460000..9.690000)] [RM=[6.209000..8.780000]] [PTRATIO=[12.600000..19.100000)] 
 8 worth=1.903024       [LSTAT=[1.730000..11.380000)] [ZN=[12.500000..100.000000]] [INDUS=[0.460000..9.690000)] [RM=[6.209000..8.780000]] 
 9 worth=1.902541       [ZN=[12.500000..100.000000]] [RM=[6.209000..8.780000]] [PTRATIO=[12.600000..19.100000)] 
10 worth=1.891092       [INDUS=[0.460000..9.690000)] [NOX=[0.385000..0.538000)] [RM=[6.209000..8.780000]] [PTRATIO=[12.600000..19.100000)] 

 Worth=1.959372
 Treatment:[INDUS=[0.460000..9.690000)
            PTRATIO=[12.600000..19.100000)
            RM=[6.209000..8.780000]
            LSTAT=[1.730000..11.380000)]

             low:                                [     1 -  1%] 
          medlow:~~                              [     6 -  5%] 
         medhigh:~~~~~~~~~~~                     [    32 - 26%] 
            high:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [    83 - 68%] 

 Worth=1.948271
 Treatment:[RM=[6.209000..8.780000]
            ZN=[12.500000..100.000000]
            PTRATIO=[12.600000..19.100000)
            LSTAT=[1.730000..11.380000)]

             low:                                [     0 -  0%] 
          medlow:~~                              [     5 -  6%] 
         medhigh:~~~~~~~~~~~~                    [    22 - 27%] 
            high:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [    55 - 67%] 
```

### Example 2, TAR3/TAR4 ###

New draft: Diagnosis of Mission-Critical Failures
  * Gregory Gay , Tim Menzies, Misty Davies, Karen Gundy-Burlet
  * http://menzies.us/pdf/09tar3.pdf
  * Seriously kicks butt compared to standard optimizers (simulated annealing) and state of the art optimizers (Quasi- Newton method with a BFGS update).

## WHICH ##

(Zach Milton, WVU, 2007)

Discretize data.
Score all ranges using some predicate P
Add all ranges to a stack, decreasing on P
  1. Pick two stack entries at random, favoring those with high scores
  1. Score the combination with P
  1. Sort the combination into stack according to its score
  1. Goto 1

Initially, stack contains singleton ranges.
  * After first pick, it is possible to have doubles, triples, etc

Usually,  combinations are disjunctions
  * But if a combination contains two ranges from one attribute, that is a disjunction.
  * Also, if a combination contains all ranges from one attribute, that attribute can be removed

How many picks?
  * Empirically, no improvements seen after 100 picks
    * Usually after 20. See last figure of http://menzies.us/pdf/08which.pdf
  * So if new score at top of stack is more than old top of stack, do 20 more picks.

If you scoring using  the TAR4.1 method,  then no need to run over the data
  * Just do frequency count lookups generated via one pass of the data
  * Very fast

# Exception Rule Learning #

Available in the WEKA

  * RIDOR (ripple-down-rules learner)
  * weka.classifiers.rules.Ridor -F 3 -S 1 -N 2.0

Assume we have a method for generating a single good rule

  * Then its easy to generate rules with exceptions
  * First: default class is selected for top-level rule
  * Then we generate a good rule for one of the remaining classes
  * Finally we apply this method recursively to the two subsets produced by the rule
    * I.e. instances that are covered/not covered

![http://www.csee.wvu.edu/~timm/cs591o/old/images/exceptions.png](http://www.csee.wvu.edu/~timm/cs591o/old/images/exceptions.png)

In classic ripple-down-rules
**We ask humans to patch faulty rules**

In numerous variants:
**Agents are called to propose patches**

Note:
**can inter-lever human/automatic patching**

# Covering algorithms #

e.g. PRISM,INDUCT,RIPPER,etc

Alternative strategy for generating a rule set directly:

  * For each class:
    * while some instances of that class remain
      * find one rule that covers most instances of that class
      * remove instances that are covered (i.e. match) the rule

![http://www.csee.wvu.edu/~timm/cs591o/old/images/cover.png](http://www.csee.wvu.edu/~timm/cs591o/old/images/cover.png)

Possible rule set for class b:

  * If x 1.2 then class = b
  * If x > 1.2 and y 2.6 then class = b
  * More rules could be added for perfect rule set

## PRISM ##

A simple covering algorithm developed by Cendrowksa in 1987.

Available in the WEKA

  * PRISM
  * weka.classifiers.rules.Prism

The algorithm is hardly profound but it does illustrate a simple way to handle an interesting class of covering learners.

  * Build rules as conjunctions of size (e.g. 3)
    * IF a == 1 and b == 2 and c == 3 then X
  * Grow rules b adding new tests (e.g. a == 1)
    * But which literal to add next?
  * Let...
    * t: total number of instances covered by rule
    * p: positive examples of the class covered by rule
    * Select tests that maximizes the ratio p/t
    * We are finished when p/t = 1 OR the set of instances cant be split any further

### PRISM: Example ###
Contact lenses data
```
           Age,SpectaclePrescription,Astigmatism,TearProductionRate,RecommendedLenses
-------------- --------------------- ----------- ------------------ -----------------
         Young,                Myope,         No,           Reduced,             None
         Young,                Myope,         No,            Normal,             Soft
         Young,                Myope,        Yes,           Reduced,             None
         Young,                Myope,        Yes,            Normal,             Hard
         Young,         Hypermetrope,         No,           Reduced,             None
         Young,         Hypermetrope,         No,            Normal,             Soft
         Young,         Hypermetrope,        Yes,           Reduced,             None
         Young,         Hypermetrope,        Yes,            Normal,             hard
Pre-presbyopic,                Myope,         No,           Reduced,             None
Pre-presbyopic,                Myope,         No,            Normal,             Soft
Pre-presbyopic,                Myope,        Yes,           Reduced,             None
Pre-presbyopic,                Myope,        Yes,            Normal,             Hard
Pre-presbyopic,         Hypermetrope,         No,           Reduced,             None
Pre-presbyopic,         Hypermetrope,         No,            Normal,             Soft
Pre-presbyopic,         Hypermetrope,        Yes,           Reduced,             None
Pre-presbyopic,         Hypermetrope,        Yes,            Normal,             None
    Presbyopic,                Myope,         No,           Reduced,             None
    Presbyopic,                Myope,         No,            Normal,             None
    Presbyopic,                Myope,        Yes,           Reduced,             None
    Presbyopic,                Myope,        Yes,            Normal,             Hard
    Presbyopic,         Hypermetrope,         No,           Reduced,             None
    Presbyopic,         Hypermetrope,         No,            Normal,             Soft
    Presbyopic,         Hypermetrope,        Yes,           Reduced,             None
    Presbyopic,         Hypermetrope,        Yes,            Normal,             None
```

Seek rule for majority class

  * Initial rule: _If ? then recommendation = hard_
  * Possible tests:
```
                                         p/t
                                         ----
Age = Young                              2/8
Age = Pre-presbyopic                     1/8
Age = Presbyopic                         1/8
Spectacle prescription = Myope           3/12
Spectacle prescription = Hypermetrope    1/12
Astigmatism = no                         0/12
Astigmatism = yes                        4/12 <== tie
Tear production rate = Reduced           0/12
Tear production rate = Normal            4/12 <== tie
```
Rule with best test added:

  * If astigmatic = yes then recommendation = hard

Instances covered by modified rule:
```
 Age                Spectacle       Astigmatism    Tear production     Recommended
                   Prescription                   Rate                lenses
--------------    --------------   -----------    ---------------     ----------- 
Young              Myope           Yes            Reduced             None
Young              Myope           Yes            Normal              Hard
Young              Hypermetrope    Yes            Reduced             None
Young              Hypermetrope    Yes            Normal              hard
Pre-presbyopic     Myope           Yes            Reduced             None
Pre-presbyopic     Myope           Yes            Normal              Hard
Pre-presbyopic     Hypermetrope    Yes            Reduced             None
Pre-presbyopic     Hypermetrope    Yes            Normal              None
Presbyopic         Myope           Yes            Reduced             None
Presbyopic         Myope           Yes            Normal              Hard
Presbyopic         Hypermetrope    Yes            Reduced             None
Presbyopic         Hypermetrope    Yes            Normal              None
```
Repeat on the covered instances

  * Find next best test
  * _If astigmatism = yes and ? then recommendation = hard_

Possible tests:
```
                                       p/t
                                       ---
Age = Young                            2/4
Age = Pre-presbyopic                   1/4
Age = Presbyopic                       1/4
Spectacle prescription = Myope         3/6
Spectacle prescription = Hypermetrope  1/6
Tear production rate = Reduced         0/6
Tear production rate = Normal          4/6 <== winner
```
Modified rule and resulting data

  * _If astigmatic = yes and tear production rate = normal then recommendation = hard_

```
Age               Spectacle       Astigmatism    Tear production     Recommended
                  prescription                   rate                lenses
--------------    -------------   -----------    ----------------    ----------
Young             Myope           Yes            Normal              Hard
Young             Hypermetrope    Yes            Normal              hard
Pre-presbyopic    Myope           Yes            Normal              Hard
Pre-presbyopic    Hypermetrope    Yes            Normal              None
Presbyopic        Myope           Yes            Normal              Hard
Presbyopic        Hypermetrope    Yes            Normal              None
```
Repeat on covered instances

  * _If astigmatism = yes and tear production rate = normal and ? then recommendation = hard_

Possible tests
```
                                        p/t
                                        --- 
Age = Young                             2/2 <== tie
Age = Pre-presbyopic                    1/2
Age = Presbyopic                        1/2
Spectacle prescription = Myope          3/3 <== tie
Spectacle prescription = Hypermetrope   1/3 
```
Tie between the first and the fourth test

  * We choose the one with greater coverage

The result

  * _If astigmatism = yes and tear production rate = normal and spectacle prescription = Myope then recommendation = hard_

Repeat for remaining instances:
```
If spectacle prescription = Myope and astigmatic = yes and 
   tear production rate = normal 
   then recommendation = hard 
If tear production rate = reduced 
   then recommendation = none 
If age = young and astigmatic = no and 
   tear production rate = normal 
   then recommendation = soft 
If age = pre-presbyopic and astigmatic = no and 
   tear production rate = normal 
   then recommendation = soft 
If age = presbyopic and spectacle prescription = Myope  and
   astigmatic = no 
   then recommendation = none 
If spectacle prescription = Hypermetrope and astigmatic = no  and
   tear production rate = normal 
   then recommendation = soft 
If age young and astigmatic = yes and tear production rate = normal 
   then recommendation = hard 
If age = pre-presbyopic and spectacle prescription = Hypermetrope and  
   astigmatic = yes 
   then recommendation = none 
If age = presbyopic and spectacle prescription = Hypermetrope and 
   astigmatic = yes 
   then recommendation = none
```
Note, some of these lower rules have very low support.
### PRISM, pseudo-code ###
```
For each class C
 Initialize E to the instance set
 While E contains instances in class C
    Create a rule R with an empty left-hand side that predicts class C
    Until R is perfect (or there are no more attributes to use) do
       For each attribute A not mentioned in R, and each value v,
              Consider adding the condition A = v to the left-hand side of R
              Select A and v to maximize the accuracy p/t
               (break ties by choosing the condition with the largest p)
       Add A = v to R
    Remove the instances covered by R from E 
```
Methods like PRISM (for dealing with one class) are separate-and-conquer algorithms:

  * First, a rule is identified
  * Then, all instances covered by the rule are separated out
  * Finally, the remaining instances are conquered

### Over-fitting avoidance ###

Standard PRISM has no over-fitting avoidance strategy

  * INDUCT uses PRISM as a sub-routine, then tries removing lasted added tests
    * Some funky statistics used to guess-timate if pruned rule would have occurred at random (i.e. no information)

Other options

  * PRISM algorithm silent on
    * Order with which classes are explored (usually, majority first)
    * Order with which attributes are explored
  * Standard PRISM also demands that all attributes are added
    * Bad idea
    * Why not:
      * prune with info gain?
      * just use the attributes that score highest on b<sup>2</sup>/(b+r).
    * Why not have an early stopping criteria?
  * Standard PRISM has no support-based pruning
    * Why not stop learning when support of selected rule falls too low?
  * Currently, these options are unexplored.

## Generalizing PRISM ##

PRISM is really a simple example of a class of separate and conquer algorithms. The basic algorithm is simple and supports a wide range of experimentation (e.g. INDUCT)

  * modify the evaluation criteria for each rule ; e.g. replace p/t with entropy, lift, etc.
  * Modify the search method
    * why explore all attributes?
    * why not apply a greedy/ beam/ etc search?
      * Stopping criterion (e.g. minimum accuracy, minimum support, ....)
  * Post-processing step
    * Pruning methods: more than just INDUCT
    * What are the merits of post-processing vs pre-pruning in the search?
    * If post-pruning, does the training set need to be divided into growing sets and pruning sets?
  * Can PRISM-like algorithms be used for explaining Bayes Classifiers?
    * Use Bayes for performance
    * Use PRISM for explanations
  * Missing values, numeric attributes
    * Common treatment of missing values: let them fail any test
      * Forces algorithm to either use other tests to separate out positive instances or to leave them uncovered until later on in the process
    * Note that in some cases its better to treat missing as a separate value (as in OneR)
  * When recursing, why not study the mis-classified rules (i.e. exception-rule or decision list learning).

## RIPPER: very Fast Covering ##

Theoretically, fast. Some implementations are .... slow.

Available in the WEKA:

  * JRip
  * weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1

William Cohen's 1995 RIPPER algorithm learns rules of the form:

  * IF test1 AND test2 AND ... AND testN THEN classX
  * where testY is one of
    * x = value (for discrete attributes)
    * x ? value (for numerics)
    * x > value (for numerics)
  * run times over m examples : O(m(log m)2)
    * c.f. the C4.5 rule generator O(m3)
  * on experimentation
    * accuracy: RIPPER matched or beat C4.5 in 22 of 37 cases
    * rule size: RIPPER's rules always smaller

Following description assumes a two-class system

  * generalizes to N classes by repeating for each class
  * positive examples = things in class N
  * negative examples = everything else

Details don't matter to much:

  * Essential details:
    * you gotta fight, for your right, to party
  * Forward, then backwards select of rule tests, of rule sets
  * Final optimization step:
    * for each surviving rules, consider replacing it with either
    * dumbest alternative, or
    * careful modifications to current

Set up:

  * Dividing training data into grow:prune, 2:1

Grow one rule:

  * sort tests using a variant of Quinlan's entropy measure
  * add tests till no negative example covered

Prune one rule:

  * in reverse order of addition
  * pop tests to find prune rule that maximizes _(p - n)/(p + n)_
    * p = number of positive pruning examples covered
    * n = number of negative pruning examples covered
  * Delete all examples covered by pruned rule

Maybe grow more rules:

  * Description length = number of bits needed to code current rule set, and their exceptions
  * If description length of current rule set not excessive
    * build another rule

Prune rules:

  * in reverse order of addition
  * delete rules that reduce overall description of rule set

Optimize rule set:

  * repeat k times, (usually, k=2).
    * Replace each rule R as follows:
      * find positive examples only covered by R
      * find negative examples only covered by R
      * initialize emptyRule with tests = ()
      * initialize currentRule with tests = R's tests
      * grow and prune emptyRule over pos,neg examples
      * grow and prune currentRule over pos,neg examples
      * replace R with best of emptyRule or currentRule.
        * best determined by description length

Pseudo-code:

![http://www.csee.wvu.edu/~timm/cs591o/old/images/ripper.png](http://www.csee.wvu.edu/~timm/cs591o/old/images/ripper.png)