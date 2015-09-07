

# The Big Picture #

## Development Structure ##

This code was written using a test-driven approach; i.e. whenever I built a new functionality, I wrote a _deftest_ command to test that code.

```
(deftest test-normal ()
  (let ((n (make-normal)))
    (dolist (x '( 1 2 3 4 5 4 3 2 1))
      (add n x))
    (check 
      (samep n "#S(NORMAL :MAX 5 :MIN 1 :N 9 :SUM 25 :SUMSQ 85)")
      (equal (mean n) (/ 25 9))
      (equal (stdev n) 1.3944334)
      (samep (format nil "~10,9f" (pdf n 5))  ".080357649")
    )))
```
This code throws a set of numbers at a normal distribution. If it is working correctly, then that distribution should generate certain values.

The above shows four _check\_s. The_samep_functions checks if two forms evaluate to the same print string, ignoring minor details like white space and capitalization._

A site effect of using _deftest_ is that a global _**tests**_ stores all the known tests and the _(tests)_ function can report what percent of the test suite is working right now.

It is impossible to understate the value of this kind of development. Everyday, I stop with a broken test. Every new day, I start with the test broken from last night. And if ever I make any changes to anything, I can check if that breaks anything else.

## Code structure ##

At the time of this writing, the main LISP directory is our/lib/lisp. This is broken down into:

  * [our/lib/lisp/miner.lisp](#miner.lisp.md) : main load file. Loads the rest of the code.
  * [our/lib/lisp/tests](#tests.md) : code for test suite
  * [our/lib/lisp/tricks](#tricks.md) : general LISP utils
  * [our/lib/lisp/table](#table.md) : code for storing data
  * [our/lib/lisp/learn](#learn.md) : code for learners

This code structure will be discussed below.

## Getting Started ##

First, you have to [install Ourmine](http://ourmine.googlecode.com). Then
at the UNIX shell prompt:
```
cd ~/opt/our/lib/lisp
emacs
```
Once inside EMACS:
```
M-x slime
(load "miner.lisp")
```

## Data Structure ##

### Main Data Structures ###

At the time of this writing, the main data structures are:

  * **eg** : an example data row
  * **header** : meta-information about each column of data (e.g. the maximum and minimum number seen in an row in a particular column). Headers have two sub-classes
    * **Discrete** : for non-numeric data
    * **Numeric**  : for numeric data
  * **table** : combines examples with column headers.


For example, this code returns a _table_ with five _eg\_s, one for each row of the data:_

```
(defun did-you-play-golf ()
  (data
    :name   'weather
    :columns '( forecast temp humidity $wind play)
    :egs     '((sunny    hot  high     20    no) 
               (sunny    hot  high     10    no) 
               (sunny    hot  high     30    no) 
               (sunny    hot  high     20.2  yes)
               (sunny    hot  high     20.1  yes)
               (sunny    hot  high     20.7  yes)
              )
)
```

The table has four _discrete_ columns (forecast, temp, humidity, play) and one numeric one (denoted with a "$" sign: see"$wind"). The last column is the _class_ (so it  columns satisfies _header-classp_).

Optionally, the columns can store frequency counts of the data seen in each column.  The code

```
(xindex (did-you-play-golf))
```
runs over the table and:
  * For _discrete_ columns, it stores the count of symbols seen in each class.
  * _Numeric_ columns are summarized,  assuming  [normal distributions](http://en.wikipedia.org/wiki/Normal_distribution).


### Other Structures ###

  * **normal** : used to store normal distributions and report mean, standard deviation, pdf, etc.
  * **caution** : collects any error strings on flaws found  when reading the data. If two many flaws are found, _caution_ calls an abort.

# The Details #

## miner.lisp ##

This file defines a list of files to load; e.g.
```
(defparamater *files* '(
                          "tests/deftest"
                          "tricks/lispfuns"
                          etc
                       ))
```
Once this file is loaded, then the whole system can be reloaded with _make_.
```
(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind 
          ((style-warning #'muffle-warning))
        (make1 *files*))))
```
_make_ works in two modes. The call _(make)_ loads the system, suppressing SBCL's verbose load information. To see that output, use _(make t)_.

Note that there is a better way to define systems in LISP- the asdf system. But while debugging this code, I found some quirks in my local
installation of that system, so....

## tests ##

> <em>Debugging had to be discovered.  I can remember the exact instant when I realized that a large part of my life from then on was going to be spent in finding mistakes in my own programs. </em>
<br>--Maurice Wilkes, 1949</li></ul>



At least half the development time of any system is spent debugging the code. So it is worthwhile to spend a little time<br>
simplifying this very, very, common task.<br>
<br>
The unit test system used by Ourmine is based on code  from Peter Seibel. The <i>deftest</i> macro calls a <i>defun</i> and, as a side-effect, registers<br>
the test in a list <b>tests</b>. One test can can contain <i>check_s and, if passed, each</i>check<i>adds one to a counter of passed tests:<br>
<pre><code>(deftest test-normal ()<br>
  (let ((n (make-normal)))<br>
    (dolist (x '( 1 2 3 4 5 4 3 2 1))<br>
      (add n x))<br>
    (check <br>
      (samep n "#S(NORMAL :MAX 5 :MIN 1 :N 9 :SUM 25 :SUMSQ 85)")<br>
      (equal (mean n) (/ 25 9))<br>
      (equal (stdev n) 1.3944334)<br>
      (samep (format nil "~10,9f" (pdf n 5))  ".080357649")<br>
    )))<br>
</code></pre>
An individual test like</i>test-normal<i>can be<br>
called like any other function.</i>

All the current tests can be called using <i>(tests)</i>.<br>
When <i>(tests)</i> terminates, it reports what percent of tests passed/failed.<br>
<br>
<br>
<h2>tricks ##

Tricks stores some common COMMON LISP tricks- should be useful for more than just Ourmine.

### list.lisp ###
<dl>
<dt><i>(shuffle list)</i> </dt>
<dd>Returns a randomly reordered <i>list</i>. Note: the original <i>list</i> is changed by this function.</dd>
</dl>
### string.lisp ###
<dl>
<dt><i>(lt x y)</i> </dt><dd>
Returns true if <i>x</i> is   less than <i>y</i>.<br>
</dd>
<dt><i>(nchars integer &optional char)</i> </dt><dd>
Returns a string of length <i>integer</i> containing <i>char</i> (default: space).<br>
</dd>
<dt><i>(samep x y)</i> </dt><dd>
Returns true if a  string comparison of the results <i>x</i> and the results of <i>y</i>
are lexicographically different. Ignores differences like whitespace of upper or lower case.<br>
</dd>
<dt><i>(whiteout seq)</i> </dt><dd>
Returns a sequence without any whitespace (space, tab, newline, page breaks).<br>
</dd>
</dl>

### hash.lisp ###
<dl>
<dt><i>(print-object hash stream)</i> </dt><dd>
Redefines the printed representation of a hashtable.<br>
</dd>
<dt><i>(showh hash &key indent stream before after if-empty show lt)</i> </dt><dd>
Pretty prints the contents of <i>hash</i> on <i>stream</i> (defaults to standard output).<br>
The strings <i>before</i> and <i>after</i> are printed before and after showing the hash table contents.<br>
Buckets are printed in a sort order controlled by <i>lt</i>. If a bucket is empty, <i>if-empty</i> is shown.<br>
<br>
In this example, fruit is stored in a hash table at a key equal to the string length of the fruit (e.g. "PEAR" goes to "4"):<br>
<pre><code>(deftest test-showh ()<br>
  (let ((h (make-hash-table)))<br>
    (dolist (one '(apple pear banana))<br>
      (setf (gethash (length (string one)) h) one))<br>
   (check<br>
     (samep (with-output-to-string (s) <br>
            (showh h  :stream s))<br>
                "4 = PEAR<br>
                 5 = APPLE<br>
                 6 = BANANA"<br>
))))<br>
</code></pre>
</dd>
</dl>
### macros.lisp ###
#### Macros for Debugging ####

<dl>
<dt><i>(o &rest items)</i></dt><dd>
For each item in <i>items</i>, print its symbolic name, then its current value. This is useful for adding print statements into LISP code.<br>
<br>
Example usage:<br>
<pre><code>(deftest test-o ()<br>
  (let* ((a 'tim)<br>
         (b 'tom)<br>
         (result  <br>
			(with-output-to-string (s)<br>
               (let ((*standard-output* s))<br>
                  (o a b)))))<br>
    (check<br>
      (samep result<br>
             "[A]=[TIM] [B]=[TOM]"))))<br>
</code></pre>
</dd>
</dl>
#### Macros for Iteration ####
<dl>
<dt><i>(dohash (key value hash &optional out) body)</i> </dt><dd>
For each <i>key</i> and <i>value</i> in <i>hash</i>, call <i>body</i>. Useful for traversing all items in a hash table.<br>
Returns <i>out</i> (defaults to nil).<br>
</dd>
<dt><i>(doitems (item integer list &optional out) body)</i> </dt><dd>
For each <i>item</i> at position <i>integer</i> within the <i>list</i>,  call <i>body</i>. Useful for traversing all items in a list while knowing<br>
your index in the list.<br>
Returns <i>out</i> (defaults to nil).<br>
<br>
For example:<br>
<br>
<pre><code>(deftest test-doitems ()<br>
  (check (samep<br>
          (with-output-to-string (s)<br>
            (doitems (item pos '(the quick brown fox))<br>
              (format s "~a is at position ~a~%" item pos)))<br>
<br>
          "THE is at position 0<br>
           QUICK is at position 1<br>
           BROWN is at position 2<br>
           FOX is at position 3"<br>
)))<br>
</code></pre>
</dd>
</dl>

#### Macros for Profiling ####

<dl>
<dt><i>(watch  code)</i> </dt><dd>
Run <i>code</i> and report what functions took the most time. Useful for optimization.<br>
For example, the following <i>watch</i> result shows that 12/28=43% of the runtimes of <i>test-normal</i>
is spend computing the mean value. Clearly, incrementally updating the mean would be a candidate optimization for this code.<br>
<pre><code>CL-USER&gt; (watch (test-normal))<br>
      seconds  |   consed  | calls |  sec/call  |  name  <br>
    -------------------------------------------------------<br>
         0.016 |   613,888 |     9 |   0.001777 | ADD<br>
         0.012 |   540,256 |     2 |   0.005999 | MEAN<br>
         0.000 |         0 |   114 |   0.000000 | WHITESPACEP<br>
         0.000 |    16,296 |     2 |   0.000000 | SAMEP<br>
         0.000 |         0 |     1 |   0.000000 | NORMAL-SUM<br>
         0.000 |         0 |     4 |   0.000000 | REPORT-RESULT<br>
         0.000 |    24,536 |     1 |   0.000000 | PDF<br>
         0.000 |         0 |     1 |   0.000000 | NORMAL-N<br>
         0.000 |         0 |    13 |   0.000000 | SQUARE<br>
         0.000 |         0 |     1 |   0.000000 | NORMAL-MIN<br>
         0.000 |         0 |     1 |   0.000000 | MAKE-NORMAL<br>
         0.000 |     8,192 |     4 |   0.000000 | WHITEOUT<br>
         0.000 |    16,360 |     2 |   0.000000 | STDEV<br>
         0.000 |         0 |     1 |   0.000000 | NORMAL-SUMSQ<br>
         0.000 |     8,184 |     1 |   0.000000 | TEST-NORMAL<br>
         0.000 |         0 |     1 |   0.000000 | NORMAL-MAX<br>
    -------------------------------------------------------<br>
         0.028 | 1,227,712 |   158 |            | Total<br>
</code></pre>
</dd>
</dl>
### number.lisp ###
<dl>
<dt><i>(square  number)</i> </dt><dd>
Returns the square of a number.<br>
</dd>
</dl>
### random.lisp ###

It is hard to reproduce the behavior of  code that uses random number generation. This is a problem when tracking down bugs or when
writing tests. Hence, sometimes it is useful to use random number generators that build random number _X_<sub>i</sub>_from
random number_X<sub>i-1</sub>_.
The behavior of code that uses these_pseudo-random generators_can then be reproduced by setting the "seed"; i.e._X<sub>0</sub>_._

<dl>
<dt><i>(my-random number)</i></dt>
<dd>Returns a pseudo-random float in the range zero to <i>number</i>.</dd>
<dt><i>(my-random-int number)</i></dt>
<dd>Returns a pseudo-random integer in the range zero to <i>number</i>.</dd>
<dt><i>(reset-seed)</i></dt>
<dd>Resets the random number seed to an initial value.</dd>
</dl>
### Abstract Data Types ###
#### caution.lisp ####
A _caution_ is a place to store a list of errors seen thus far. Such _caution_ structures have finite patience (initially set to 20)
and after enough errors, _caution_ calls a halt to the processing.
```
(defstruct (caution (:print-function caution-print))
  all (patience 20) killed)

(defun caution-print (c s depth)
  (declare (ignore depth))
  (format s "#(CAUTION :ALL ~a :PATIENCE ~a)"
          (caution-all c)
          (caution-patience c)))
```
_Caution_ is useful when parsing user inputted data structures. If the user makes too many errors, _caution_ calls a halt.
<dl>
<dt>(ok test cautions format-str &rest args)<br>
</dt>
<dd>If <i>test</i> return nil, then a new string (generated using <i>(format nil format-str ,@args)</i> is added to cautions.<br>
<br>
For example, here's the Ourmine function called when it expects to see a number. If <i>datum</i> is not a number then a new error<br>
message is added to the <i>cautions</i> structure:<br>
<pre><code>(defmethod datum ((column numeric) datum cautions)<br>
  (ok (numberp datum) cautions "~a is not a number" datum)<br>
  t)<br>
</code></pre>
</dd>
</dl>
#### normal.lisp ####
A _normal_ is a place to summarize a stream of numeric Gaussian data.  Each addition to a _normal_ updates the information  required to determine
the mean, standard deviation, etc.
```
(defstruct normal 
  (max (* -1 most-positive-single-float))
  (min       most-positive-single-float)
  (n 0)
  (sum 0)
  (sumSq 0))
```
<dl>
<dt><i>(add  normal number)</i></dt> <dd>Add a <i>number</i> to a <i>normal</i> distribution</dd>
<dt><i>(mean normal)</i></dt> <dd>Returns the mean of a  <i>normal</i> distribution</dd>
<dt><i>(stdev normal)</i></dt> <dd>Returns the standard deviation of a <i>normal</i> distribution.</dd>
<dt><i>(pdf normal number)</i></dt> <dd>Returns the probability of <i>number</i> belonging to a normal distribution.</dd>
</dl>
## table ##

When we read data, we have to store it somewhere. Ourmine uses _table_:
```
(defstruct table 
  name                      ; symbol          : name of the table
  columns                   ; list of header  : one header to describe each column of data
  class                     ; number          : which column is the header column?
  (cautions (make-caution)) ; list of caution : any load-time errors?
  all                       ; list of eg      : all the examples
  indexed
)
```

The _data_ function  builds _table\_s. The list of words given to_:columns: defines each column of the data. For example,
in the following, _windy_ is marked with a "$" so we expect all numbers in that column.
```
(defun make-data1 ()
  (data
   :name   'weather
   :columns '(forecast temp humidity $windy play)
   :egs    '((sunny    hot  high   FALSE no) 
             (sunny    hot  high   TRUE  yes)
             (sunny    hot  high         yes)
             )))
```
Note that the data has some errors. Row 3 does not have enough columns and all the values in the _windy_ column are non-numeric.
The following call shows that Ourmine has seen those errors:
```
CL-USER> (make-data1)

 #S(TABLE
   :NAME WEATHER
   :COLUMNS (#S(DISCRETE
                :NAME FORECAST
                :CLASSP NIL
                :IGNOREP NIL
                :F {hash of 0 items}
                :UNIQUES (SUNNY))
             #S(DISCRETE
                :NAME TEMP
                :CLASSP NIL
                :IGNOREP NIL
                :F {hash of 0 items}
                :UNIQUES (HOT))
             #S(DISCRETE
                :NAME HUMIDITY
                :CLASSP NIL
                :IGNOREP NIL
                :F {hash of 0 items}
                :UNIQUES (HIGH))
             #S(NUMERIC
                :NAME $WINDY
                :CLASSP NIL
                :IGNOREP NIL
                :F {hash of 0 items})
             #S(DISCRETE
                :NAME PLAY
                :CLASSP T
                :IGNOREP NIL
                :F {hash of 0 items}
                :UNIQUES (YES NO)))
   :CLASS 4
   :CAUTIONS #(CAUTION :ALL ((SUNNY HOT HIGH YES) wrong size
                             TRUE is not a number
                             FALSE is not a number) :PATIENCE 17)
   :ALL (#S(EG :FEATURES (SUNNY HOT HIGH TRUE YES) :CLASS YES)
         #S(EG :FEATURES (SUNNY HOT HIGH FALSE NO) :CLASS NO))
   :INDEXED NIL)
```

The above code shows a <em>table</em> (on the outside) containing five <em>header</em>s (four <em>discrete</em> and one <em>numeric</em>) describing each column of data.  For the <em>discrete</em> headers, the  set of unique symbols seen in each column is stored in the <em>:uniques</em> slot.  The <em>:class</em> slot shows that the class variable is the fifth header (which, you will note, has <em>:classp T</em>).   An <em>all</em> slot stores all the examples.  Each example as some <em>:features</em> and a  <em>:class</em> value.


The _:indexed_ slot of the above is NIL. A _table_ becomes indexed when the _xindex_ function does some detailed counts of the symbols
seen in all the rows. We will return to this function is just a moment.
Note that the  file _our/lib/lisp/data.lisp_ defines a hook that triggers whenever we see discrete or number data. This hook has two methods (one for each column type). For example, this hook notes when we have missed a numeric column.
```
(defmethod datum ((column discrete) datum oops)
  "things to do when reading a discrete datum"
  (declare (ignore  oops))
  (unless (member datum (discrete-uniques column))
    (push datum (discrete-uniques column)))
  t)

(defmethod datum ((column numeric) datum oops)
  "things to do when reading a numeric datum"
  (ok (numberp datum) oops"~a is not a number" datum)
  t)
```

Returning now to _xindex_, this function stores the information about the distribution in the _f_ slot of _header_ structures.
```
; e.g.
(xindex (make-data1))
```
Just as with _datum_, there is a hook defined for handling numeric data differently to numeric data (see _our/lib/lisp/xindex.lisp_):
```
(defmethod xindex-datum ((column discrete) class  datum)
  (let* ((key `(,class ,datum))
         (hash (header-f column)))
    (incf (gethash key hash 0))))

(defmethod xindex-datum ((column numeric) class  datum)
  (let* ((key      class)
         (hash     (header-f column))
         (counter  (gethash  key hash (make-normal))))
    (setf (gethash key hash) counter) ; make sure the hash has the counter
    (add counter datum)))
```
(The _add_ method comes from the _normal_ code, described above.)

Note that distribution information is hashed on class name; i.e. separate distribution information is kept for each class.
For example, the following data has very different mean values  for _$humidity_. Also, _forecast=overcast_ appears four times
in class=YES but never in class=NO.
```
(defun make-some-weather-data ()
  (data
   :name   'weather
   :columns '(forecast $temp $humidity wind play)
   :egs    '((sunny 85 85 FALSE no)
             (sunny 80 90 TRUE no)
             (overcast 83 86 FALSE yes)
             (rainy 70 96 FALSE yes)
             (rainy 68 80 FALSE yes)
             (rainy 65 70 TRUE no)
             (overcast 64 65 TRUE yes)
             (sunny 72 95 FALSE no)
             (sunny 69 70 FALSE yes)
             (rainy 75 80 FALSE yes)
             (sunny 75 70 TRUE yes)
             (overcast 72 90 TRUE yes)
             (overcast 81 75 FALSE yes)
             (rainy 71 91 TRUE no))))

(deftest test-some-counts ()
  (check
    (samep 
     (with-output-to-string (str)
       (dolist (col (table-columns (xindex (make-some-weather-data))))
         (format str "~%~a~%" (header-name col))
         (showh (header-f col) :indent 10 :stream str)))
    "
    FORECAST
          (NO RAINY) = 2
          (NO SUNNY) = 3
          (YES OVERCAST) = 4
          (YES RAINY) = 3
          (YES SUNNY) = 2

    $TEMP
          NO = #S(NORMAL :MAX 85 :MIN 65 :N 5 :SUM 373 :SUMSQ 28075)
          YES = #S(NORMAL :MAX 83 :MIN 64 :N 9 :SUM 657 :SUMSQ 48265)

    $HUMIDITY
          NO = #S(NORMAL :MAX 95 :MIN 70 :N 5 :SUM 431 :SUMSQ 37531)
          YES = #S(NORMAL :MAX 96 :MIN 65 :N 9 :SUM 712 :SUMSQ 57162)

    WIND
          (NO FALSE) = 2
          (NO TRUE) = 3
          (YES FALSE) = 6
          (YES TRUE) = 3

    PLAY
          (NO NO) = 5
          (YES YES) = 9")))

```
For convenience, the _f_ function allows simple access to the frequency counts. It can be called with 1,2,of 4 arguments depending on
how much information you want.
<dl>
<dt><i>(f tbl)</i> </dt>
<dd>Return the number of examples in a table </dd>
<dt><i>(f tbl class)</i> </dt>
<dd>Return the number of examples of one <i>class</i> in a table </dd>
<dt><i>(f tbl class index range)</i> </dt>
<dd>Return the number of examples in one <i>class</i> of  a table in <i>index</i>-th column with a certain <i>range</i>. </dd>
</dl>
## learn ##
With all the above machinery, we can now define a learner. A _Naive Bayes_ classifier takes a training and a test data set.
_Xindex_ is called on the training set, and the resulting statistics are applied on the test set.

Ignoring for the moment the details of its internal working, here's how we'd call it:
```
(defun nb-simple (train test &key (stream t))
  (xindex train)
  (dolist (one (table-all test))
    (let* ((got     (bayes-classify (eg-features one) train))
           (want    (eg-class one))
           (success (eql got want)))
      (format stream "~a ~a ~a~%"  got want 
              (if (eql got want) "   " "<--")))))

 (defun make-weather (eg)
    (data :name    'weather 
          :columns '(forecast temp humidity windy play)  
          :egs     '((sunny    hot  high   TRUE  skip)
                	 (rainy    cool normal TRUE  skip)    
                	 (sunny    mild high   FALSE skip)
                	 (overcast cool normal TRUE  play)
                	 (overcast hot  high   FALSE play)
                	 (rainy    mild high   FALSE play)
                	 (rainy    cool normal FALSE play)
                	 (sunny    cool normal FALSE play)
                	 (rainy    mild normal FALSE play)
                	 (rainy    mild high   TRUE  skip)
                	 (sunny    mild normal TRUE  play)
                	 (overcast mild high   TRUE  play)
                	 (overcast hot  normal FALSE play))))
```
This produces:
```
CL-USER> (nb-simple  (make-weather egs) (make-weather egs))
PLAY PLAY    
PLAY PLAY    
PLAY PLAY    
SKIP SKIP    
PLAY PLAY    
PLAY PLAY    
PLAY PLAY    
PLAY PLAY    
PLAY PLAY    
PLAY PLAY    
PLAY SKIP <--
PLAY SKIP <--
SKIP SKIP    
SKIP SKIP    
```
Note that our learner nearly works in every case (see the arrowed lines).

But how does the learner work? Well, that requires a little data mining theory. To conclude this
walk through, all we need to
say at this time is that the classifier returns what it thinks is the mostly likely classification of one example.
```
(defun bayes-classify (one tbl &optional (m 2) (k 1))
  (let* ((classes        (klasses tbl))        ; all the class names
         (nclasses       (nklasses tbl))       ; number of classes 
         (n              (f        tbl))       ; number of instances
         (classi         (table-class tbl))    ; what column has the class
         (like           most-negative-fixnum)
         (classification (first classes)))     ; default classification
    (dolist (class classes)                      ; for all classes do...
      (let* ((prior (/ (+ (f tbl class) k)       ; again, we call "f".
                       (+  n (* k nclasses))))
             (tmp   (log prior)))
        (doitems (feature i one)
          (unless (= classi i)
            (unless (unknownp feature)
              (let ((delta (/ (+ (f tbl class i feature) ; note the call to "f"
                                 (* m prior))
                              (+ (f tbl class) m))))     ; note the call to "f"
                (incf tmp (log delta))))))
        (when (> tmp like)                      ; if you've got something better
          (setf like tmp
                classification class))))        ; switch to it
    classification))                          ; return the classification
```