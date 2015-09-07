

The truth of the matter is that most of the time spent in data mining is really spent on data pre-processing.

<img width='600' src='http://ourmine.googlecode.com/svn/trunk/share/img/effort.gif'>

So lets talk about pre-processing.<br>
<br>
<br>
<h1>What is an Instance?</h1>

In sample, classical learning, the input is usually a "flat file"; e.g.:<br>
<pre><code>(defun contact-lens ()<br>
  (data<br>
   :name 'contact-lens<br>
   :columns '(age prescription astigmatism tear-production lens)<br>
   :egs<br>
   '(<br>
     (young myope yes normal hard)<br>
     (young hypermetrope yes normal hard)<br>
     (presbyopic myope yes normal hard)<br>
     (pre-presbyopic myope yes normal hard)<br>
     <br>
     (young hypermetrope no reduced none)<br>
     (young hypermetrope yes reduced none)<br>
     (pre-presbyopic hypermetrope yes reduced none)<br>
     (pre-presbyopic hypermetrope yes normal none)<br>
     (young myope no reduced none)<br>
     (young myope yes reduced none)<br>
     (presbyopic myope no reduced none)<br>
     (presbyopic myope no normal none)<br>
     (presbyopic hypermetrope yes reduced none)<br>
     (presbyopic hypermetrope yes normal none)<br>
     (presbyopic myope yes reduced none)<br>
     (pre-presbyopic hypermetrope no reduced none)<br>
     (pre-presbyopic myope no reduced none)<br>
     (pre-presbyopic myope yes reduced none)<br>
     (presbyopic hypermetrope no reduced none)<br>
     <br>
     (pre-presbyopic myope no normal soft)<br>
     (pre-presbyopic hypermetrope no normal soft)<br>
     (young myope no normal soft)<br>
     (young hypermetrope no normal soft)<br>
     (presbyopic hypermetrope no normal soft)<br>
     )))<br>
</code></pre>

This data has the following properties:<br>
<ul><li>Denomormalized (i.e. joins across multiple separate data sources)<br>
</li><li>Not the best representation<br>
</li><li>e.g. trees are hard;<br>
<ul><li>Not everyone has parents. What to write into the file?<br>
</li><li>What about all the implicit relations; e,g, sister<br>
</li><li>Pre-compute and cache in the ARFF?<br>
</li><li>Bad! Massive blow-out of data size.</li></ul></li></ul>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/family_tree.jpg' />

<h1>Numeric Transforms</h1>

Pragmatically, the following transforms for numbers are very useful:<br>
<br>
<ul><li>Coarse-grain: if many numbers, bunch them up into a small set; e.g. below mean, above mean<br>
<ul><li>More generally, discretize them (see [#Discretization[).</li></ul></li></ul>

<ul><li>Log: if the numerics form an exponential distribution, convert all N to log(N)<br>
<ul><li>Used in the COCOMO example<br>
</li><li>pragmatics: missing values can't be "zero" (infinitely negative log values)<br>
</li><li>Apply some min value (e.g. 0.0001) and use:<br>
</li><li>new = (if old < min then log(min) else log(old))<br>
</li></ul></li><li>Remove outliers: suspiciously large/small values<br>
</li><li>Replace unknowns with most expected  value<br>
<ul><li>Numerics: use mean or median<br>
</li></ul></li><li>Discretes: use most common symbol<br>
<ul><li>?cluster first, then fill in from local neighborhood<br>
</li><li>Warning: maybe missing really means missing!<br>
</li><li>Also, some learners can handle missing valus.<br>
</li></ul></li><li>Bore: Best or Rest<br>
<ul><li>Sort: rename the top X% (best) values "good" and the rest "bad"; eg. X=25%<br>
</li><li>Scales to multi-variables (can be used to replace multiple numeric target classes with one binary classification)<br>
</li></ul></li><li>Time series<br>
<ul><li>Add attributes to record the moving average over the last N minutes, 5N minutes, 25N minutes, etc</li></ul></li></ul>

<h1>Sampling</h1>
Build data sets by sub-sampling real data<br>
<br>
<ul><li>Column sub-sampling: manual FeatureSelection<br>
<ul><li>Maybe there is domain knowledge that some columns are<br>
</li><li>More costly to use<br>
</li><li>Less trustworthy<br>
</li><li>E.g. in the MDP data: different measures from modules<br>
</li></ul></li><li>Row sampling: manual [<a href='Stratification.md'>Stratification</a>]<br>
<ul><li>Ignore all but the relevant data (how to judge? domain knowledge? nearest neighbor?).</li></ul></li></ul>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/samples.png' />

When the target class is rare,<br>
<br>
<ul><li>Sub-sample: create training sets that contain all the target instances and an equal number of randomly selected non-target instances (stand back! give the little guy some air!).<br>
</li><li>Super-sample: take the minority class and repeat it (build yourself up in the crowd).</li></ul>


Some experimental results:<br>
<br>
<ul><li>In one study, under-sampling beat over-sampling <a href='Drummond03.md'>Drummond03</a>.<br>
</li><li>In another, once again, over-sampling was useless and under-sampling did the same as no-sampling, but with much much less data <a href='Menzies08a.md'>Menzies08a</a>. The following results show balance results for the above data sets. NB= naive bayes. J48= a decision tree learner.</li></ul>

<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/overunder.png'>



<h1>Standard Text Transforms</h1>

Tokenize (kill white space).<br>
<br>
Send to lower case.<br>
<br>
Remove stop words (boring words like "a above above.." (see examples at <a href='http://www.dcs.gla.ac.uk/idom/irresources/linguisticutils/stop_words'>http://www.dcs.gla.ac.uk/idom/irresources/linguisticutils/stop_words</a>

<ul><li>Warning: don't remove words that are important to your domain.</li></ul>

Stemming<br>
<br>
<ul><li>These words are all "connect": connect, connected, connecting, connection,connections<br>
</li><li>PorterStemming: the standard stemming algorithm, available in multiple languages: <a href='http://www.tartarus.org/~martin/PorterStemmer/'>http://www.tartarus.org/~martin/PorterStemmer/</a>
<ul><li>Definition: <a href='http://www.tartarus.org/~martin/PorterStemmer/def.txt'>http://www.tartarus.org/~martin/PorterStemmer/def.txt</a></li></ul></li></ul>

Reject all but the top k most interesting words<br>
<br>
<ul><li>Interesting if frequent OR usually appears in just a few paragraphs<br>
</li><li>TF<code>*</code>IDF (term frequency, inverse document frequency)<br>
</li><li>Interesting =<br>
<blockquote>F(i,j) <code>*</code> log((Number of documents)/(number of documents including word i))<br>
</blockquote></li><li>F(i,j): frequency of word i in document j<br>
</li><li>Often, on a very small percentage of the words are high scorers, so a common transform is to just use the high fliers. e.g. here's data from five bug tracking systems a,b,c,d,e:</li></ul>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/tfidf.png' width='400'>

Build a symbol table of all the remaining words<br>
<br>
<ul><li>Convert strings to pointers into the symbol table<br>
</li><li>So "the cat sat on the cat" becomes 6 pointers to 4 words</li></ul>

<h1>Misc</h1>
Watch for one-letter typos<br>
<ul><li>Check all symbols that occur only once in the data.<br>
Add synthetic attributes<br>
</li><li>Capture domain knowledge<br>
</li><li>e.g. risk is age/weight*temperature<br>
Sample randomly<br>
</li><li>Useful when the whole data can't fit into ram.<br>
</li><li>Useful when building training/test sets<br>
Sample instances according to the mis-classification rate of its class<br>
</li><li>So focus more on the things that are harder to classify<br>
</li><li>Also called Boosting: discussed (much) later</li></ul>

<h1>Discretization</h1>


Think of learning like an accordion- some target concept is spread out across all the data and our task is to squeeze it together till it is dense enough to be visible. That is, learning is like a compression algorithm.<br>
<br>
One trick that helps compressions is discretization: i.e. clumping together observations taken over a continuous range into a small number of regions. Humans often discretize real world data. For example, parents often share tips for "toddlers"; i.e. humans found between the breaks of age=1 and age=3.<br>
<br>
Many researchers report that discretization improves the performance of a learner since it gives a learner a smaller space to reason about, with more examples in each part of the space<br>
(<a href='http://code.google.com/p/ourmine/wiki/Dd#Dou95'>Dou95</a>, <a href='http://code.google.com/p/ourmine/wiki/Yy#Yang03'>Yang03</a>, <a href='http://code.google.com/p/ourmine/wiki/Ff#Fayyad93'>Fayyad93</a>).<br>
What is Discretization?<br>
<br>
Formally, discretization can generally be described as a process of assigning data attribute instances to bins or buckets that they fit in according to their value or some other score:<br>
<br>
<ul><li>The general concept for discretization as a binning process is dividing up each instance of an attribute to be discretized into a number distinct buckets or bins.<br>
</li><li>The number of bins is most often a user-defined, arbitrary value.<br>
</li><li>However, some methods use more advanced techniques to determine an ideal number of bins to use for the values.<br>
</li><li>While others use the user-defined value as a starting point and expand or contract the number of bins that are actually used (based upon the number of data instances being placed in the bins).<br>
</li><li>Each bin or bucket is assigned a range of the attribute values to contain, and discretization occurs when the values that fall within a particular bucket (or bin) are replaced by identifier for the bucket into which they fall.</li></ul>

After <a href='http://code.google.com/p/ourmine/wiki/Gg#Gama06'>Gama and Pinto</a>, we say that<br>
<br>
<ul><li>Discretization is the process of converting a continuous range into a histogram with "k" break points<br>
</li><li>b<sub>1</sub> ... b<sub>k</sub> (where for all i < j : not(b<sub>i</sub> =  b<sub>j</sub>)).<br>
</li><li>The histogram divides a continuous range into bins (one for each break) and many observations from the range may fall between two break points b<sub>i</sub> and b<sub>i+1</sub> at frequency counts c<sub>i</sub>.</li></ul>

Simple discretizers are unsupervised methods that build their histograms without exploiting information about the target class; e.g.<br>
<ul><li>equal width discretization: (b<sub>i</sub> - b<sub>i</sub>-1) = (b<sub>j</sub> - b<sub>j</sub>-1)<br>
</li><li>equal frequency discretization: c<sub>i</sub> = c<sub>j</sub></li></ul>

<h2>How to discretize</h2>

Unsupervised discretization: ignore the class variable, just chop each column (this may seem dumb, but often works surprisingly well)<br>
<br>
Supervised discretization: separates the numerics according to the class variable<br>
<br>
<h3>Unsupervised methods</h3>

Nbins: divide data into N equal width bins<br>
<ul><li>Pass1: find min and max of each column. Find bin size for each column (max - min)/N.<br>
</li><li>Pass2: convert all numbers X to floor(X - min)/binsize.<br>
</li><li>N=10 is a commonly used number (but for Naive Bayes classifiers working on "n" instances, Yang and Webb <a href='http://code.google.com/p/ourmine/wiki/Yy#Yang03'>Yang03</a> advocate equal frequency with c<sub>i</sub>=c<sub>j</sub>=sqrt(n)).<br>
</li><li>Example:<br>
<ul><li>e.g. divide 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100 using 10bins<br>
<pre><code>0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100<br>
-------------------------------------------|--|--|--|--|---|<br>
bin1                                        b2 b3 b5 b9 b10<br>
</code></pre>
</li><li>one bucket would get numbers 1 to 25,<br>
</li><li>the last 4 numbers would get a bin each.<br>
</li><li>So our learner would have 5 bins with nothing in it,<br>
<ul><li>one bin with 83% of the data and<br>
</li><li>4 bins with 3.3% of the data in each.<br>
</li></ul></li><li>Simple variants:<br>
<ul><li>BinLogging: set N via the number of unique numerics N=max(1,log2(uniqueValues))<br>
<ul><li>Caution, for numbers generated from some random process and if you are using many significant figures, then you may need to round back.<br>
</li></ul></li><li>Logging filter: hit distributions like the above with X = log(X). This smoothes out the distributions across more of the buckets.</li></ul></li></ul></li></ul>

Percentile chop: diver data into N equal sized bins<br>
<br>
<ul><li>Pass1: collect all numbers for each column. Sort them. Break the sorted numbers into N equal frequency regions (checking that numbers each size of the break are different).<br>
</li><li>So the frequency counts in each bin is equal (flat histogram).<br>
</li><li>Example: In practice, not quite flat. e.g. 10 equal frequency bins on the above data:<br>
<pre><code>0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100<br>
-----|----|-----|-----|-----|-----|-----|------|---------|<br>
bin1  bin2 bin3  bin4  bin5  bin6  bin7  bin8   bin9<br>
</code></pre>
</li><li>Note the buckets with repeated entries. Its a design choice what to do with those.<br>
</li><li>We might squash them together such that there are no repeats in the numbers that are the boundaries between bins.<br>
<pre><code>0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100<br>
--------------|-------------|--------|----|-------|-------<br>
bin1           bin2          bin3     bin4 bin5     bin6<br>
</code></pre></li></ul>

<h3>Supervised Discretization</h3>

Find a cliff where there most change  in the class ditribution.  For example:<br>
<br>
<ul><li>class=dead (always) if age under 120; class=alive (sometimes) if age under 120<br>
<ul><li>120 is the cliff<br>
</li><li>The following graph shows the number of o-ring damage reports seen in the space shuttle prior to the Challenger launch. There is a cliff at X=65 degrees, below which all launches had o-ring damage.</li></ul></li></ul>


<img src='http://ourmine.googlecode.com/svn/trunk/share/img/orings.jpg' />

Some details on cliff learning (from <a href='https://list.scms.waikato.ac.nz/pipermail/wekalist/2004-October/002986.html'>https://list.scms.waikato.ac.nz/pipermail/wekalist/2004-October/002986.html</a>. Per numeric attribute, apply the following:<br>
<br>
<ul><li>Sort the instances on the attribute of interest<br>
</li><li>Look for potential cut-points.<br>
<ul><li>Cut points are points in the sorted list above where the class labels change.<br>
</li><li>Eg. if I had five instances with values for the attribute of interest and labels<br>
</li><li>(1.0,A), (1.4,A), (1.7, A), (2.0,B), (3.0, B), (7.0, A),<br>
</li><li>then there are two cut points of interest (mid-way between the points where the classes change from A to B or vice versa):<br>
<ul><li>1.85<br>
</li><li>5<br>
</li></ul></li></ul></li><li>Apply your favorite measure on each of the cuts, and choose the one with the maximum value<br>
<ul><li>Weight the measures by the same size; e.g.<br>
<ul><li>if 20% and 80% of the data fall left and right of the slot<br>
</li><li>measure = 0.2<code>*</code> rightMeasure + 0.8<code>*</code>leftMeasure<br>
</li></ul></li><li>e.g. variance,  info gain etc etc<br>
<ul><li>Common practice is to follow the lead of <a href='http://code.google.com/p/ourmine/wiki/Ff#Fayyad93'>Fayyad93</a> and use info gain<br>
<ul><li>Let classes X and Y occur on the right-hand-side (containing 20%) of the data<br>
</li><li>Let class frequency be F<sub>x</sub> and F<sub>y</sub> (and N=F<sub>x</sub> + F<sub>y</sub> numbers)<br>
</li><li>Let p<sub>x</sub> = F<sub>x</sub>/N<br>
</li><li>Let  p<sub>y</sub> = F<sub>y</sub>/N<br>
</li><li>Let entropy<sub>x</sub> = -p<sub>x</sub><code>*</code>log<sub>2</sub>(p<sub>x</sub>)<br>
</li><li>Let entropy<sub>y</sub> = -p<sub>y</sub><code>*</code>log<sub>2</sub>(p<sub>y</sub>)<br>
</li><li>Let weighted entropy<sub>right</sub> = -0.2<code>*</code> (entropy<sub>x</sub> + entropy<sub>y</sub>)<br>
</li><li>Return the split that minimizes entropy<sub>right</sub> + entropy<sub>left</sub><br>
</li></ul></li></ul></li></ul></li><li>Repeat recursively in both subsets (the ones less than and greater than the cut point) until either<br>
<ul><li>the subset is "pure" i.e. only contains instances of a single class<br>
</li><li>some stopping criterion is reached. e.g. too few examples to proceed</li></ul></li></ul>

<h2>Incremental Discretization</h2>

An interesting variant on discretization is incremental discretization. Suppose we are learning from an infinite data stream so we'll never know "the number of unique symbols" or the "max" and "min" of that data. How might we conduct discretization?<br>
<br>
Incremental discretization can be very simple. Below, we describe two schemes:<br>
<br>
<ul><li>D.J. Bolands' RBST method (a local favorite; sees 2007 WVU CSEE masters thesis;<br>
</li><li><a href='http://code.google.com/p/ourmine/wiki/Gg#Gama06'>Gamma and Pinto</a>'s PID method (more widely used).</li></ul>

<h3>RBSTs for Incremental Discretization</h3>

Consider this binary search tree BST, where everything on the left is less than everything on the right.<br>
<pre><code>          4<br>
         / \<br>
        2   6<br>
</code></pre>
We can add the number "5" in at least two places in this tree, and still preserve the search property that everything on the left is less than the stuff on the right. In case (a), we insert at root and in (b), we insert at leaf.<br>
<pre><code>    (a)   5          (b)  4<br>
         / \             / \<br>
        4   6           2   6<br>
       /                    /<br>
      2                    5<br>
</code></pre>
Internally, what we really do is always insert at leaf and sometimes bubble up the leaf to the root, switching sub-trees as we go to preserve the ordering. In random BST (RBST), we insert at root of a sub-tree with probability 1/(N+1), where "N" is the number of sub-tree nodes. RBST's tend to generate balanced trees.<br>
<br>
Why? Because we are reaching in at random to a distribution, and dividing into into two sets below and above a number. Repeat that a few times and you tend to get balanced trees. So you very rarely get this:<br>
<pre><code>                      7<br>
                     /<br>
                    6<br>
                   /<br>
                  5<br>
                 /<br>
                4<br>
               /<br>
              3<br>
             /<br>
            2<br>
</code></pre>
Rather, you tend to get this:<br>
<pre><code>                      5<br>
                     / \<br>
                    3   6<br>
                   / \   \<br>
                  2   4   7<br>
</code></pre>
So, what has all this got to do with incremental discretization?<br>
<br>
<ul><li>Note that if we had a balanced tree, we could perform discretization by just returning (say) the breaks at level 3 of the tree (below 2, 2 to 4, 4 to 7, above 7). To do this, we'd add a counter to each node and if something arrives T times at node N, then N's counter value is T. So balanced trees can be used for batched discretization.<br>
</li><li>But note that RBSTs adjust themselves after each insertion. So if used for an infinite stream of arrivals, they are always self-adjusting. This ability to react to new data and changes in the distribution of the new data reacting is exactly what we want from an incremental discretizer.<br>
</li><li>Infinite data streams cause memory problems (cannot store infinite memory). RBSTs support a simple garbage collection algorithm. If we are discretizing at level L (in the above case, L=3) then we can periodically throw away the subtrees below level (say) 2*L. Yes, we'll lose some details but those details are down in the weeds and we can live without them.</li></ul>

<h3>Pid</h3>
<a href='http://code.google.com/p/ourmine/wiki/Gg#Gama06'>Gama and and Pinto</a>'s Partition Incremental Discretization (PiD) maintains two sets of "break" points and "counts" of values that fall into each break:<br>
<br>
<ul><li>Layer two: the actual discretized ranges. Layer two is very small and is generated on demand from layer one.<br>
</li><li>Layer one: is very large (say, 30 times the number of bins you seek); Layer one just maintains counts on a large number of bins and if one bin gets too big (e.g. 1/(number of bins)), it is split in two (and all the breaks and counts arrays are pushed up by one index value).</li></ul>

That's nearly all there is too it. Layer one is initialized according to some wild guess about the min and max possible values (and if data arrives outside that range, then a new bin is added bottom or two of "breaks" and "counts"). Layer two could be generated in any number of ways (nbins, logbins, <a href='http://code.google.com/p/ourmine/wiki/Ff#Fayyad93'>FayyadIranni</a>, etc) and those methods could work by querying the layer one data.<br>
<br>
When should we recreate layer2? Here are three policies:<br>
<br>
<ul><li>For equal width discretization: if ever we split a bin, rebuild layer2.<br>
</li><li>For equal frequency discretization: if a layer1 bin gets two large, rebuild layer2. If we have seen "n" examples, and our bins have min and max counts of "cmin" and "cmax" then rebuild layer2 when we see an interval with:<br>
<ul><li>count below (1-beta)<code>*</code>cmin/n or<br>
</li><li>count above (1+beta)<code>*</code>cmax/n<br>
</li><li>Gama and Pinto comment that beta=1/100 seems to be a useful value.<br>
</li></ul></li><li>For other discretization policies, recreate layer2 after seeing N examples (say, N=100).</li></ul>

Here's the pseudo-code for updating layer1. Its a little tacky (a linear time operation to increase the size of an array) but it runs so fast than no one cares:<br>
<pre><code>Update-Layer1(x, breaks, counts, NrB, alfa, Nr) <br>
  x - observed value of the random variable <br>
  breaks - vector of actual set of break points <br>
  counts - vector of actual set of frequency counts <br>
  NrB - Actual number of breaks <br>
  alfa - threshold for Split an interval <br>
  Nr - Number of observed values <br>
<br>
If (x &lt; breaks[1]) k = 1; Min.x = x <br>
Else If (x &gt; breaks[NrB] k = NrB; Max.x = x <br>
Else k = 2 + integer((x - breaks[1]) / step) <br>
<br>
while(x &lt; breaks[k-1]) k &lt;- k - 1 <br>
while(x &gt; breaks[k]) k &lt;- k + 1 <br>
<br>
counts[k] = 1 + counts[k] <br>
Nr = 1 + Nr <br>
If ((1+counts[k])/(Nr+2) &gt; alfa) { <br>
  val = counts[k] / 2            <br>
  counts[k] = val <br>
  if (k == 1) { <br>
     breaks = append(breaks[1]-step, breaks) <br>
     counts &lt;- append(val,counts) <br>
  } <br>
  else { <br>
     if(k == NrB) { <br>
        breaks &lt;- append(breaks, breaks[NrB]+step) <br>
        counts &lt;- append(counts,val) <br>
     } <br>
     else { <br>
        breaks &lt;- Insert((breaks[k]+ breaks[k+1])/2, breaks, k) <br>
        counts &lt;- Insert(val, counts, k) <br>
     } <br>
  }   <br>
  NrB = NrB + 1 <br>
} <br>
</code></pre>
<h3>Applications of Incremental Discretization: Anomaly Detection and Repair</h3>

Curiously, the literature is silent on two obvious applications of incremental discretization:<br>
<br>
<ul><li>Anomaly detection: if the discretization boundaries in an incremental discretizer where stable, then start changing, then something is happening to the data generating phenomena. Incremental discretizers could alert when old knowledge needs to be thrown out and new learning initiated.<br>
</li><li>Repair: if we could track how discretization ranges changed, then we could take old knowledge, patch its ranges, and test the fixes. If that happened incrementally with changes to the discretization boundaries, then we'd be keeping the knowledge up to date with the underlying data generating phenomena.</li></ul>

<h2>What Works Best?</h2>
The following graph from <a href='http://code.google.com/p/ourmine/wiki/Dd#Dou95'>Dou95</a>, shows results from three experiments:<br>
<br>
<ul><li>Experiment 1: Running a standard Naive Bayes classifier<br>
</li><li>Experiment 2,3: Discretizing the data in one of two ways, then running Naive Bayes.</li></ul>

The y-axis of this graph shows the difference between experiment1 and the others. Any "y" value greater than one means that discretization increased accuracy. The data sets on the x-axis are sorted by the delta between the experiment 2,3 results (so, on the left, one discretizer is best and, on the right, the other is best).<br>
<br>
<img src='http://ourmine.googlecode.com/svn/trunk/share/img/diffnb.png' />

Note that:<br>
<br>
<ul><li>discretization rarely made things worse;<br>
</li><li>often made things much better;<br>
</li><li>and the exact nature of the discretizer was not so important.<br>
<pre><code>What        win loss ties<br>
----------  --- ---- ----<br>
fayyadIrani 4    0    0<br>
pkid        2    1    1<br>
disctree3   2    1    1<br>
tbin        1    3    0<br>
cat         0    4    0<br>
</code></pre></li></ul>

Here's another result, from Boland07. These are "win-loss-tie" tables showing a statistical analysis of the difference between several discretization methods:<br>
<br>
<ul><li>Some of the undiscretized methods shown below:<br>
<ul><li>"tbin" is Nbins (discussed below) with N=10<br>
</li><li>"disctree3" (a neat trick from Boland07);<br>
</li></ul></li><li>A supervised methods (discussed below) called "fayyadIrani" from <a href='http://code.google.com/p/ourmine/wiki/Ff#Fayyad93'>Fayyad93</a> (discussed below, see "cliff learning").<br>
</li><li>And other methods including "cat" (do nothing).</li></ul>

Note that there is an overall winner (fayyadIrani) and this is the discretizer in widest current use.<br>
<br>
But if you look at the raw numbers (say, for "balance"), a different picture emerges. This is one result, out of the hundreds explored by Boland07. Note, as before:<br>
<br>
<ul><li>discretization rarely made things worse (i.e. do worse than "cat";<br>
</li><li>can make things much better;<br>
</li><li>and the exact nature of the discretizer is not so important.</li></ul>

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/discrete.png' />

From the above, we conclude that discretization is important and that we not get too tense about exploring better discretizers. Time to move on.