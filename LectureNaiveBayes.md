

# Introduction #

A Bayes classifier is a simple statistical-based learning scheme.

Advantages:

  * Tiny memory footprint
  * Fast training, fast learning
  * Simplicity
  * Often works surprisingly well

Assumptions

  * Learning is done best via statistical modeling
  * Attributes are
    * equally important
    * statistically independent (given the class value)
    * This means that knowledge about the value of a particular attribute doesn't tell us anything about the value of another attribute (if the class is known)
  * Although based on assumptions that are almost never correct, this scheme works well in practice [Domingos97](http://code.google.com/p/ourmine/wiki/Dd#Domingoes97)

![http://ourmine.googlecode.com/svn/trunk/share/img/bayesVsOthers.png](http://ourmine.googlecode.com/svn/trunk/share/img/bayesVsOthers.png)

It has some drawbacks: it can offer conclusions put it is poor at explaining how those conclusions were reached. But that is something we'll get back to below.

# Example #

```
weather.symbolic.arff

outlook  temperature  humidity   windy   play
-------  -----------  --------   -----   ----
rainy    cool         normal     TRUE    no
rainy    mild         high       TRUE    no
sunny    hot          high       FALSE   no
sunny    hot          high       TRUE    no
sunny    mild         high       FALSE   no
overcast cool         normal     TRUE    yes
overcast hot          high       FALSE   yes
overcast hot          normal     FALSE   yes
overcast mild         high       TRUE    yes
rainy    cool         normal     FALSE   yes
rainy    mild         high       FALSE   yes
rainy    mild         normal     FALSE   yes
sunny    cool         normal     FALSE   yes
sunny    mild         normal     TRUE    yes
```
This data can be summarized as follows:

```
           Outlook            Temperature           Humidity
====================   =================   =================
          Yes    No            Yes   No            Yes    No
Sunny       2     3     Hot     2     2    High      3     4
Overcast    4     0     Mild    4     2    Normal    6     1
Rainy       3     2     Cool    3     1
          -----------         ---------            ----------
Sunny     2/9   3/5     Hot   2/9   2/5    High    3/9   4/5
Overcast  4/9   0/5     Mild  4/9   2/5    Normal  6/9   1/5
Rainy     3/9   2/5     Cool  3/9   1/5

            Windy        Play
=================    ========
      Yes     No     Yes   No
False 6      2       9     5
True  3      3
      ----------   ----------
False  6/9    2/5   9/14  5/14
True   3/9    3/5
```
So, what happens on a new day:
```
Outlook       Temp.         Humidity    Windy         Play
Sunny         Cool          High        True          ?%%
```
First find the likelihood of the two classes

  * For "yes" = 2/9 `*` 3/9 `*` 3/9 `*` 3/9 `*` 9/14 = 0.0053
  * For "no" = 3/5 `*` 1/5 `*` 4/5 `*` 3/5 `*` 5/14 = 0.0206
  * Conversion into a probability by normalization:
    * P("yes") = 0.0053 / (0.0053 + 0.0206) = 0.205
    * P("no") = 0.0206 / (0.0053 + 0.0206) = 0.795

So, we aren't playing golf today.

# Bayes' rule #

More generally, the above is just an application of Bayes' Theorem.
  * Probability of event H given evidence E:
```
                   Pr(E | H ) * Pr(H)
      Pr(H | E) =  -------------------
                        Pr(E)
```
  * A priori probability of H= Pr(H)
    * Probability of event before evidence has been seen
  * A posteriori probability of H= Pr[H|E]
    * Probability of event after evidence has been seen
  * Classification learning: what's the probability of the class given an instance?
    * Evidence E = instance
    * Event H = class value for instance
  * Naive Bayes assumption: evidence can be split into independent parts (i.e. attributes of instance!
```
                  Pr(E1 | H )* Pr(E2 | H ) * ....  *Pr(En | H ) * Pr(H )
      Pr(H | E) = ---------------------------------------------------
                                     Pr(E)
```

  * We used this above. Here's our evidence:
```
      Outlook       Temp.         Humidity    Windy         Play
      Sunny         Cool          High        True          ?
```

  * Here's the probability for "yes":
```
      Pr( yes | E) = Pr(Outlook     = Sunny | yes) *
                     Pr(Temperature = Cool  | yes) *
                     Pr(Humidity     = High  | yes) * Pr( yes)
                     Pr(Windy       = True  | yes) * Pr(yes) / Pr(E)
                   = (2/9 * 3/9 * 3/9 * 3/9)       * 9/14)   / Pr(E)
```
Return the classification with highest probability

  * Probability of the evidence Pr(E)
    * Constant across all possible classifications;
    * So, when comparing N classifications, it cancels out

## Numerical errors ##

From multiplication of lots of small numbers

  * Use the standard fix: don't multiply the numbers, add the logs

## Missing values ##

Missing values are a problem for any learner. Naive Bayes' treatment of missing values is particularly elegant.

  * During training: instance is not included in frequency count for attribute value-class combination
  * During classification: attribute will be omitted from calculation
```
Example: Outlook    Temp.    Humidity    Windy    Play
         ?          Cool     High        True     ?%%
```

  * Likelihood of "yes" = 3/9 `*` 3/9 `*` 3/9 `*` 9/14 = 0.0238
  * Likelihood of "no" = 1/5 `*` 4/5 `*` 3/5 `*` 5/14 = 0.0343
  * P("yes") = 0.0238 / (0.0238 + 0.0343) = 41%
  * P("no") = 0.0343 / (0.0238 + 0.0343) = 59%

## The "low-frequencies problem" ##

What if an attribute value doesn't occur with every class value (e.g. "Humidity = high" for class "yes")?

  * Probability will be zero!
  * Pr(Humidity = High | yes) = 0
  * A posteriori probability will also be zero! Pr( yes | E) = 0 (No matter how likely the other values are!)

So use an estimators for low frequency attribute ranges

  * Add a little "m" to the count for every attribute value-class combination
    * The Laplace estimator
    * Result: probabilities will never be zero!

And use an estimator for low frequency classes

  * Add a little "k" to class counts
    * The M-estimate

Magic numbers: m=2, k=1

And we'll return to the low frequency problem, below.

# Pseudo-code #

Here's the pseudo code of the the Naive Bayes classifier preferred by
[Yang03](http://code.google.com/p/ourmine/wiki/Yy#Yang03) (p4).
```
function train(   i) {
   Instances++
   if (++N[$Klass]==1) Klasses++
   for(i=1;i<=Attr;i++)
     if (i != Klass)
      if ($i !~ /\?/)
         symbol(i,$i,$Klass)
}
function symbol(col,value,klass) {
   Count[klass,col,value]++;
}
```
When testing, find the likelihood of each hypothetical class and return the one that is most likely.

## Simple version ##
```
function likelihood(l,         klass,i,inc,temp,prior,what,like) {
   like = -10000000000;    # smaller than any log
   for(klass in N) {
      prior=N[klass] / Instances;
      temp= prior
      for(i=1;i<=Attr;i++) {
         if (i != Klass)
            if ( $i !~ /\?/ )
                temp *= Count[klass,i,$i] / N[klass]
      }
      l[klass]= temp
      if ( temp >= like ) {like = temp; what=klass}
   }
   return what
}
```
## More Complex ##
More realistic version (handles certain low-frequency cases).
```
function likelihood(l,         klass,i,inc,temp,prior,what,like) {
   like = -10000000000;    # smaller than any log
   for(klass in N) {
      prior=(N[klass]+K)/(Instances + (K*Klasses));
      temp= log(prior)
      for(i=1;i<=Attr;i++) {
         if (i != Klass)
            if ( $i !~ /\?/ )
                temp += log((Count[klass,i,$i]+M*prior)/(N[klass]+M))
      }
      l[klass]= temp
      if ( temp >= like ) {like = temp; what=klass}
   }
   return what
}
```
# Handling Numerics #

The above code assumes that the attributes are discrete. The usual approximation is to assume a "Gaussian" (i.e. a "normal" or "bell-shaped" curve) for the numerics.

The probability density function for the normal distribution is defined by the mean and standardDev (standard deviation)

Given:

  * n: the number of values;
  * sum: the sum of the values; i.e. sum = sum + value;
  * sumSq: the sum of the square of the values; i.e. sumSq = sumSq + value\*value

Then:
```
    function mean(sum,n)  {
        return sum/n
    }
    function standardDeviation(sumSq,sum,n)  {
        return sqrt((sumSq-((sum*sum)/n))/(n-1))
    }
    function gaussianPdf(mean,standardDev,x) {
       pi= 1068966896 / 340262731; #: good to 17 decimal places
       return 1/(standardDev*sqrt(2*pi)) ^
                    (-1*(x-mean)^2/(2*standardDev*standardDev))
    }
```
For example:
```
outlook  temperature humidity windy play
-------  ----------- -------- ----- ---
sunny    85          85        FALSE no
sunny    80          90        TRUE  no
overcast 83          86        FALSE yes
rainy    70          96        FALSE yes
rainy    68          80        FALSE yes
rainy    65          70        TRUE  no
overcast 64          65        TRUE  yes
sunny    72          95        FALSE no
sunny    69          70        FALSE yes
rainy    75          80        FALSE yes
sunny    75          70        TRUE  yes
overcast 72          90        TRUE  yes
overcast 81          75        FALSE yes
rainy    71          91        TRUE  no
```
This generates the following statistics:
```
             Outlook           Temperature               Humidity
=====================    =================      =================
           Yes    No             Yes    No            Yes      No
Sunny       2      3             83     85             86      85
Overcast    4      0             70     80             96      90
Rainy       3      2             68     65             80      70
          -----------            ----------            ----------
Sunny     2/9    3/5    mean     73     74.6  mean     79.1   86.2
Overcast  4/9    0/5    std dev   6.2    7.9  std dev  10.2    9.7
Rainy     3/9    2/5

              Windy            Play
===================     ===========
           Yes   No     Yes     No
False       6     2      9       5
True        3     3
            -------     ----------
False     6/9   2/5     9/14  5/14
True      3/9   3/5
```
Example density value:

  * f(temperature=66|yes)= gaussianPdf(73,6.2,66) =0.0340
  * Classifying a new day:
```
Outlook    Temp.    Humidity    Windy    Play
Sunny      66       90          true     ?%%
```
  * Likelihood of "yes" = 2/9 `*` 0.0340 `*` 0.0221 `*` 3/9 `*` 9/14 = 0.000036
  * Likelihood of "no" = 3/5 `*` 0.0291 `*` 0.0380 `*` 3/5 `*` 5/14 = 0.000136
    * P("yes") = 0.000036 / (0.000036 + 0. 000136) = 20.9%
    * P("no") = 0. 000136 / (0.000036 + 0. 000136) = 79.1%

Note: missing values during training: not included in calculation of mean and standard deviation

BTW, an alternative to the above is apply some discretization policy to the data; e.g. [Yang03](Yang03.md). Such discretization is good practice since it can dramatically improve the performance of a Naive Bayes classifier (see [Dougherty95](Dougherty95.md).


# Simple Extensions #

## From Naive Bayes to Hyper Pipes ##

When NaiveBayes sees a new value, it increments a count.
  * When HyperPipes sees a  value, it just sets the count for that value to "one".

So NaiveBayes remembers _how often we see "X" in class "C"_
  * While HyperPipes just remembers that _at least once, I've seen "X" in class "K"_

Also:
  * For numeric columns, HyperPipes needs to remember the Min/Max ever seen in column "C" for class "K".

```
function symbol(col,value,klass) {
   # Count[klass,col,value]++;
  if (Numericp[col]) }
	if (value < Min[klass,col]) Min[klass,col] = value;
	if (value > Max[klass,col]) Max[klass,col] = value;
  } else {
   		Count[klass,col,value] = 1 ;
  }
}
```
So, to classify a test instance:
  * For each class, ask how what percentage of the columns  "fall into" that class;
  * Return the class with the highest percentage cover
```
function oneColumnFallsIntoKlass(klass,col,value) { 
	if (Numericp[col])  
		return Max[klass,col] >= val && Min[klass,col] <= val : 
	else {
		return Count[klass,col,value] > 0
    }
}
```
## From NaiveBayes to Incremental Learning ##

Batch learners read all data, the  given performance results.
  * Incremental learners give intermediate results

In theory, batch is smarter than incremental
  * Since it sees more data before having to make decisions.

In practice, the incremental performance of many learners, including NaiveBayes,
asymptotes to an performance plateau in a few hundred instances:

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/plateau.png' width='500'>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/plateaus.png' width='500'>

Building an incremental version of NaiveBayes is a trivial task:<br>
<ul><li>Just classify each new instance <i>before</i> its counts are added to the frequency tables.</li></ul>

Batch process:<br>
<pre><code>Pass="train" { train() }<br>
Pass="test"  { Klass=likelihood(L); print $NF "," L[Klass] }<br>
</code></pre>
Incremental process:<br>
<pre><code># don't classify till after seeing a few instances<br>
NR&gt;=30 { Klass = likelihood(L) <br>
         print "want= " $NF " got= " Klass <br>
       }<br>
# but always train<br>
       { train() } <br>
</code></pre>
Note that the above scheme applies to HyperPipes as well as NaiveBayes.<br>
<br>
<h2>From NaiveBayes to Anomaly Detection</h2>

In anomaly detection, we report "we have not seen this before".<br>
<br>
Inside a NaiveBayes classifier, there is a loop that combines frequency counts for different ranges.<br>
If we have not seen "it" before, then some of those frequency counts will drop.<br>
<br>
If we take (say) 10 attributes, and three of them halve their frequency count (cause we have not seen this<br>
before) then the product of their likelihoods will decrease to 0.5^3=12.5%.  So all we need to do is:<br>
<ul><li>Assign each train instance to some class "All"<br>
</li><li>Track the likelihoods of "All".<br>
</li><li>Complain if this number drops by orders of magnitudes.<br>
<pre><code># don't classify till after seeing a few instances<br>
NR&gt;=30 { Klass = likelihood(L) <br>
         print "want= " $NF " got= " Klass " track= " L["All"]<br>
       } <br>
# but always train<br>
       { train(); <br>
         $NF="All"; <br>
         train() <br>
       } <br>
</code></pre>
Here's a trace of the log of the "All" likelihood for five flight simulators, divided into "eras" of 100 samples.<br>
</li><li>From era=1 to era=8, all planes fly the same commissioning exercise;<br>
</li><li>Form era=9 to era=14, all planes fly different missions, repeating the same maneuver over and over again.<br>
</li><li>At era=15, all the planes were hit with different faults (engine flame up, flaps not working, etc)<br>
</li><li>In all cases, at era=15, log(likelihood("All")) dropped two orders of magnitude.<br>
</li><li>Note that, at no time, was the classier given a list of specific  error conditions of the plane.<br>
<ul><li>So it learned "I have not seen <i>that</i> before", even though we never told it what was <i>that</i>.<br>
</li><li>Magic! (but so simple)</li></ul></li></ul>


<img src='http://ourmine.googlecode.com/svn/trunk/share/img/sawtooth.png' width='300'>

<h1>The Explanation Problem</h1>

All learners are performance systems that make conclusions. But only some can explain how they reach those conclusions.<br>
<br>
The internal data structures of a Bayes classifier are not very pleasant to look at when listed in a table. Moreover, the particulars of that data are not what really matter.<br>
<br>
<a href='Mm#Mozina04.md'>Mozina04</a> argue that what really matters is the effect of a cell on the output variables. With knowledge of this goal, it is possible to design a visualization, called a nomogram, of that data. Nomograms do not confuse the user with needless detail. For example, here's nomogram describing who survived and who died on the Titanic:<br>
<br>
<img src='http://ourmine.googlecode.com/svn/trunk/share/img/titanic.png'>

Of 2201 passengers on Titanic, 711 (32.3%) survived. To predict who will survive, the contribution of each attribute is measured as a point score (topmost axis in the nomogram), and the individual point scores are summed to determine the probability of survival (bottom two axes of the nomogram).<br>
<br>
The nomogram shows the case when we know that the passenger is a child; this score is slightly less than 50 points, and increases the posterior probability to about 52%. If we further know that the child traveled in first class (about 70 points), the points would sum to about 120, with a corresponding probability of survival of about 80%.<br>
<br>
It is simple to calculate nomogram values for single ranges. All we want is something that is far more probable in a goal class than in other classes.<br>
<br>
<ul><li>Suppose there is a class you like C and a bunch of others you hate.<br>
</li><li>Let the bad classes be combined together into a group we'll call notC<br>
</li><li>Let the frequencies of C and notC be N1 and N2.<br>
</li><li>Let two attribute range appears with frequency F1 and F2 in C1 and notC.<br>
</li><li>Then the log(OR) = log ( (N1 / H1) / (N2 / H2) )</li></ul>

We use logs since products can be visualized via simple addition. This addition can be converted back to a probability as follows. If the sum is "f" and the target class occurs "N" times out of "I" instances, then the probability of that class is "p=N/I" and and the sum's probability is:<br>
<pre><code>function points2p(f,p) { return 1 / (1 + E^(-1*log(p/(1 - p)) - f )) }<br>
</code></pre>
(For the derivation of this expression, see equation 7 of <a href='Mm#Mozina04.md'>Mozina04</a>. Note that their equation has a one-bracket typo.)<br>
<br>
Besides enabling prediction, the nomogram reveals the structure of the model and the relative influences of attribute values on the chances of surviving. For the Titanic data set:<br>
<br>
<ul><li>Gender is an attribute with the biggest potential influence on the probability of survival: being female increases the chances of survival the most (100 points), while being male decreases it (about 30 points). The corresponding line in the nomogram for this attribute is the longest.<br>
</li><li>Age is apparently the least influential, where being a child increases the probability of survival.<br>
</li><li>Most lucky were also the passengers of the first class for which, considering the status only, the probability of survival was much higher than the prior.</li></ul>

Therefore, with nomograms, we can play cost-benefit games. Consider the survival benefits of<br>
<br>
<ul><li>sex=female (72%)<br>
</li><li>sex=female and class=first (92%)<br>
</li><li>sex=female and class=first and age=child (95%)</li></ul>

Note that pretending to be a child has much less benefit than the other two steps. This is important since the more elaborate the model, the more demanding it becomes. Simpler models are faster to apply, use less resources (sensors and actuators), etc. So when the iceberg hits, get into a dress and buy a first-class ticket. But forget the lollipop.<br>
<br>
<h1>A Second Look at the Low-Frequency Problem</h1>

<a href='Rr#Rennie03.md'>Rennie03</a> report an interesting extension to standard Naive Bayes to handle data sets with very very low frequency counts. For example, in text mining applications, "d" documents are often expressed as a matrix of counting the frequency of terms "dij" of the frequency of words "i" in document "j". The matrix "d" is often sparse; i.e. many empty cells and many cells with very small frequency counts. The reason for this is simple: while there are many terms in the English language, only a small number of them are used in a particular document.<br>
<br>
In some text mining applications, there are documents grouped into a large number of classes. To classify a new document as one of the old, then<br>
<br>
The "d" matrix is often too big for processing and is pruned back<br>
to just the most relevant terms. One way to find the most relevant<br>
terms is the Tf<code>*</code>Idf measure:<br>
<br>
<ul><li>Tf<code>*</code>idf is shorthand for term frequency times inverse document frequency:<br>
</li><li>This weight is a statistical measure used to evaluate how important a word is to a document in a collection or corpus.<br>
</li><li>The importance increases proportionally to the number of times a word appears in the document but is offset by the frequency of the word in the corpus.<br>
</li><li>The term frequency in the given document is simply the number of times a given term appears in that document.<br>
</li><li>The inverse document frequency is a measure of the general importance of the term (obtained by dividing the number of all documents by the number of documents containing the term, and then taking the logarithm of that quotient).<br>
</li><li>If there are Words number of document and each word I appears Word(I) number of times inside a set of Documents and if Document(I) are the documents containing I, then:<br>
<pre><code>      Tf*idf = Word(i) / Words*log(Documents/Document(i)) <br>
</code></pre>
The standard way to use this measure is to cull all but the k top tf<code>*</code>idf words. <a href='Rr#Rennie03.md'>Rennie03</a> report that a variant of this score, used with a Naive Bayes classifier performs nearly as well as far more complicated schemes. Note that the following scheme was designed using the engineering judgment (so there are probably any number of variants of the following that are worthwhile to explore):</li></ul>

Their method is based on the following notion. If a class is rare then every other class is less rare. So instead of checking what you are, check what you aren't (since there are more counts of the other guys than you).<br>
<br>
In their scheme:<br>
<br>
<ul><li>There are "k" documents and "d<sub>ij</sub>" denotes the count of word "i" in document "j". The expression <i>delta<sub>ij</sub></i> evaluates to one if word "i" appears in document "j", or zero otherwise.<br>
</li><li><i>alpha</i> is a smoothing factor, often set to one.<br>
</li><li>They apply logs to their numbers so small numbers don't disappear under the weight of larger numbers (see steps 3,5).<br>
</li><li>Further, they normalize their counts by summing over the space of all counts. In step (3) they even divide by the square root of the sum (so that large sums don't disproportion-ally reduce the effects of small numbers).<br>
</li><li><i>theta</i> is a frequency count of the number of word "i" appears in every other class.<br>
</li><li>Their decision procedure (step 8) returns the class that you are least likely to not belong too.</li></ul>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/twcnb.png'>

<a href='Rr#Rennie03.md'>Rennie03</a> report that this scheme works very well compared to much more complex state-of-the-art techniques. And all the above steps (1-8) take linear time and space so the this method is fast and scales to large data sets.<br>
<br>
The meta-lesson of their work is that data mining algorithms are toolkits that can be modified to new purposes. Don't get too hung up on specific algorithms. Instead, view each new algorithm as a bag of tricks that you can break up and mix-and-match for your next application.<br>
<br>
<h1>Not so "Naive" Bayes</h1>

Why does Naive Bayes work so well? <a href='Dd#Domingoes97.md'>Domingos97</a> offer one analysis:<br>
<br>
<ul><li>They offer one example with three attributes where the performance where a "Naive" and a "optimal" Bayes perform nearly the same.<br>
</li><li>They generalized that to conclude that "Naive" bayes is only really Naive in a vanishingly small number of cases.</li></ul>

Their three attribute example is given below. For the generalized case, see <a href='Dd#Domingoes97.md'>Domingos97</a>.<br>
<br>
Consider a Boolean concept, described by three attributes A, B and C .<br>
<br>
Assume that the two classes, denoted by + and - are equiprobable<br>
<pre><code> P(+) = P(-) = 1/2   <br>
</code></pre>
Let A and C be independent, and let A = B (i.e., A and B are completely dependent). Therefore B should be ignored, and the optimal classification procedure for a test instance is to assign it to (i) class + if<br>
<pre><code> P(A|+) * P(C|+) -  P(A|-) * P(C|-) &gt; 0, <br>
</code></pre>
and (ii) to class (if the inequality has the opposite sign), and (iii) to an arbitrary class if the two sides are equal.<br>
<br>
Note that the Bayesian classifier will take B into account as if it was independent from A, and this will be equivalent to counting A twice. Thus, the Bayesian classifier will assign the instance to class + if<br>
<pre><code> P(A|+)^2 *  P(C|+) -  P(A|-)^2  * P(C|-) &gt; 0, <br>
</code></pre>
and to - otherwise.<br>
<br>
Applying Bayes' theorem, P(A|+) can be re-expressed as<br>
<pre><code> P(A) * P(+|A)/P(+) <br>
</code></pre>
and similarly for the other probabilities.<br>
<br>
Since P(+) = P(-), after canceling like terms this leads to the equivalent expressions<br>
<pre><code> P(+|A) * P(+|C ) - P(-|A) * P(-|C ) &gt; 0 <br>
</code></pre>
for the optimal decision, and<br>
<pre><code> P(+|A)^2 *  P(+|C ) - P(-|A)^2 * P(-|C) &gt; 0  <br>
</code></pre>
for the Bayesian classifier. Let<br>
<pre><code>P(+|A) = p<br>
P(+|C) = q.<br>
</code></pre>
Then class + should be selected when<br>
<pre><code> pq - (1 - p)*(1 - q) &gt; 0    <br>
</code></pre>
which is equivalent to<br>
<pre><code> q &gt; 1 - p   [Optimal Bayes] <br>
</code></pre>
With the Bayesian classifier, it will be selected when<br>
<pre><code> p^2 * q  - (1 - p)^2 *  (1 - q) &gt; 0  <br>
</code></pre>
which is equivalent to<br>
<pre><code>q &gt;  (1 - p)^2 *  p^2 +(1 - p)^2    [Simple  Bayes]<br>
</code></pre>
The two curves are shown in following figure. The remarkable fact is that, even though the independence assumption is decisively violated because B = A, the Bayesian classifier disagrees with the optimal procedure only in the two narrow regions that are above one of the curves and below the other; everywhere else it performs the correct classification.<br>
<br>
<img src='http://ourmine.googlecode.com/svn/trunk/share/img/optimalBayes.png'>

Thus, for all problems where (p, q) does not fall in those two small regions, the Bayesian classifier is effectively optimal.