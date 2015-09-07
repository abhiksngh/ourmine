All learning is biased. After {search, language, over-fitting, sampling} bias comes a new one:

  * evaluation bias
  * the way we evaluate a learned theory determines what theories we accept or reject.

This lecture - some of the issues associated with evaluating a theory.

Anyway, how to evaluate learning output:

  * Answer #1: assume something about the distributions, then use "t-tests" and "win-loss" tables.
  * Answer #2: use non-parametric methods (that make no such assumptions).
    * e.g. quartile charts
    * e.g. ranked statistical methods (Mann-Whitney, Wilcoxon)

But before we can evaluate N learners, we need to gather performance statistics from one learner.

# Performance Statistics #

## Discrete classes ##

Simplest case: two discrete classes.
```
                  truth = no   truth = yes  
                 |-----------|-------------|
detector = silent|     A     |       B     |
detector = loud  |     C     |       D     |
                 |-----------|-------------|
```
  * precision = D / (C+D)
  * accuracy = (A+D) / (A+B+C+D)
  * probability of detection = D / (B+D) (a.k.a. recall)
  * probability of false alarm = C / (A+C)

<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/rocsheet.png'>

Harder case:<br>
<br>
<ul><li>more than two classes<br>
</li><li>repeat the above, one for each pair of (class X) / (not class X).</li></ul>

<img width='300' src='http://ourmine.googlecode.com/svn/trunk/share/img/rocsheets.png'>

<h1>Continuous classes</h1>

Evaluation measures include RE, MRE, MMRE, PRED(N), correlation, etc.<br>
<br>
<ul><li>RE = relative error = (predicted - actual) / actual<br>
</li><li>MRE = magnitude of relative error = absolute value of RE<br>
</li><li>PRED(N) = % of cases where MRE up to N%<br>
<ul><li>e.g. MRE from ten instances = 11,15,18,20,23,25,29,31,100,100<br>
<ul><li>then the PRED(30) = 80%<br>
</li></ul></li></ul></li><li>MMRE = mean magnitude of relative error = average MRE over N test instances = sum(MRE)/N<br>
<ul><li>e.g. MRE from ten instances = 11,15,18,20,23,25,29,31,100,100<br>
<ul><li>then the MMRE = 37.2%<br>
</li></ul></li></ul></li><li>correlation = corr<br>
<ul><li>if corr =0, no connection dependent on independents<br>
</li><li>if corr = 1, perfect dependence of dependent on independents<br>
</li><li>if corr = -1, perfect negative dependence of dependent on independents<br>
</li><li>if corr in -0.5 .. 0.5 then correlation is not strong<br>
</li><li>calculating correlation for N items stored in arrays x and y:</li></ul></li></ul>

<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/correlation.png'>
<pre><code>sum_sq_x = 0<br>
sum_sq_y = 0<br>
sum_coproduct = 0<br>
mean_x = x[1]<br>
mean_y = y[1]<br>
for i in 2 to N:<br>
      sweep = (i - 1.0) / i<br>
      delta_x = x[i] - mean_x<br>
      delta_y = y[i] - mean_y<br>
      sum_sq_x += delta_x * delta_x * sweep<br>
      sum_sq_y += delta_y * delta_y * sweep<br>
      sum_coproduct += delta_x * delta_y * sweep<br>
      mean_x += delta_x / i<br>
      mean_y += delta_y / i <br>
pop_sd_x = sqrt( sum_sq_x / N )<br>
pop_sd_y = sqrt( sum_sq_y / N )<br>
cov_x_y = sum_coproduct / N<br>
correlation = cov_x_y / (pop_sd_x * pop_sd_y)<br>
</code></pre>

<h1>Evaluation bias (again)</h1>

How to combine (say) PD and PF (different applications have different cost/dependability requirements).<br>
<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/roc.png'>

<ul><li>A <a href='http://code.google.com/p/ourmine/wiki/Mm#Menzies07a'>recent study</a> of defect detectors used:<br>
<ul><li>Note: generalizes to N-dimensional evaluation (divide by sqrt(N))<br>
<img width='300' src='http://ourmine.googlecode.com/svn/trunk/share/img/balance.png'>
</li><li>More generally, it may be useful to weight {PD,PF} according to their relative importance.<br>
</li></ul></li><li>Also, if we have N theories (say <i>defects1 > T1 and defects2 > T2</i>), each with their own ROC-curve shape, we can use them in combination to design learners with some desired ROC curves.<br>
<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/rocs.png'></li></ul>

<h1>Cross-Validation</h1>

Self-tests (testing the learned theory on its own training data) is deprecated by the data mining community since such self-tests can grossly over-estimate performance.<br>
<br>
<ul><li>If the goal is to understand how well a defect predictor will work on future projects, it is best to evaluate the predictor via hold out instances not used in the generation of that predictor.</li></ul>

One such hold-out study is an M*N-way cross-val.<br>
<br>
<ul><li>Usually, M=N=10<br>
</li><li>This requires M<code>*</code>N+1 runs to the learner.<br>
<ul><li>run1 : generate a theory from all the data<br>
</li><li>remaining runs: find an estimate for the error of that theory<br>
</li><li>repeat M times<br>
<ul><li>randomize order of data (avoid order effects)<br>
</li><li>10 times, generate 1/N test and (N-1)/N training sets<br>
</li><li>train on training, apply learned theory to testing<br>
</li></ul></li></ul></li><li>note: error on test sets will over-estimate error of the training set<br>
<ul><li>R= number of training instances<br>
</li><li>h= a learned specific parameter (often, not knowable)<br>
</li><li>At probability 1-n:<br>
<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/vc.png'>
<ul><li>That is, larger training sets reduce error</li></ul></li></ul></li></ul>

Incremental M*N-way (a.k.a. sequence studies)<br>
<br>
<ul><li>Learn on more and more of the data<br>
</li><li>Report "plateau" (where learning improvement stops)<br>
</li><li>Repeat M times<br>
<ul><li>Divide data into buckets on N items<br>
</li><li>For I = 2 to N<br>
<ul><li>Training on buckets 1..I-1<br>
</li><li>Test on bucket I</li></ul></li></ul></li></ul>

In many of the standard UCI data sets, learning plateaus long before data is exhausted. Often, 200 instances are enough:<br>
<br>
<img width='600' src='http://ourmine.googlecode.com/svn/trunk/share/img/plateau.png'>

<img width='600' src='http://ourmine.googlecode.com/svn/trunk/share/img/plateaus.png'>

(BTW: the conclusion that learners plateau after a few hundred instances has not been reported widely in the literature. Use this conclusion with care, with a pinch of salt, with healthy scepticism.)<br>
<br>
<h1>Comparatively Evaluate N learners</h1>
<h2>Quartile Charts</h2>

Returning now to the point of this lecture (how to evaluate results from multiple learners):<br>
<br>
<ul><li>Previously, this class has been shown how to generate deltas in the behavior of different learners/pre-processors in cross-validation studies.<br>
</li><li>To generate these charts, the performance deltas for some method were sorted to find the lowest and highest quartile as well as the median value.</li></ul>

For example, suppose we generates this log file:<br>
<br>
<pre><code>    #data, learner, goal, train, test, repeats, bin, accuracy,    pd,    pf, precision<br>
q2s/sonar,   bayes, Mine,   139,   69,       1,   1,    63.77, 61.29, 34.21,     59.38<br>
q2s/sonar,    oneR, Mine,   139,   69,       1,   1,    68.12, 61.90, 22.22,     81.25<br>
q2s/sonar,   bayes, Mine,   139,   69,       1,   2,    60.87, 73.08, 46.51,     48.72<br>
q2s/sonar,    oneR, Mine,   139,   69,       1,   2,    68.12, 68.89, 33.33,     79.49<br>
q2s/sonar,   bayes, Mine,   139,   69,       1,   3,    73.91, 86.67, 35.90,     65.00<br>
q2s/sonar,    oneR, Mine,   139,   69,       1,   3,    69.57, 72.09, 34.62,     77.50<br>
etc <br>
</code></pre>

We can convert this into quartile charts. To generate these charts, the performance differences for some method on the same data subsets are sorted to find the lowest and highest quartile as well as the median value; e.g<br>
<br>
<br>
This produces a little ascii bar chart where:<br>
<br>
<ul><li>the median is shown as a vertical bar "|".<br>
</li><li>the first and fourth quartiles are shown as starts "<b>".<br>
</li><li>the second and third quartiles are the gaps between the stars and the median.</li></ul></b>


<pre><code>        #rx, mean,   sd, n,  min,   q1,median,   q3,  max,....................0....................<br>
   oneR/cat,  1.2,  8.0,54,-21.7, -4.3,   4.3,  6.2,  8.7,................****.|...................<br>
 oneR/nbins,  0.0,  0.0, 3,  0.0,  0.0,   0.0,  0.0,  0.0,....................|....................<br>
  bayes/cat,  0.0,  0.0,18,  0.0,  0.0,   0.0,  0.0,  0.0,....................|....................<br>
bayes/nbins, -1.2,  8.0,54, -8.7, -6.2,  -4.9,  4.3, 21.7,..................*|.****................<br>
</code></pre>

This is a little hard to read so we can use a little latex magic to generate a pdf. The preamble<br>
contains:<br>
<pre><code>\usepackage{colortbl}<br>
<br>
\newcommand{\boxplot}[5]{<br>
\begin{picture}(100, 7)<br>
\put(#1, 2){\line(0, 1){4}}<br>
\put(#1, 4){\line(1, 0){#2}}<br>
\put(#3, 4){\circle*{3}}<br>
\put(#3, 4){\line(1, 0){#4}}<br>
\put(#5, 2){\line(0, 1){4}}<br>
\put(50, 3){\line(0, 1){4}}<br>
\end{picture}<br>
}<br>
</code></pre>
Then we can generate this:<br>
<br>
<img width='600' src='http://ourmine.googlecode.com/svn/trunk/share/img/latexQuartiles.png'>
<pre><code>\begin{figure}[!t]<br>
\renewcommand{\baselinestretch}{0.5}<br>
\noindent<br>
{\scriptsize<br>
\begin{tabular}{c r  @{} c }<br>
\multicolumn{3}{c}{Flight} \\\hline<br>
<br>
Rank &amp; Change  &amp; 50\% \\<br>
\hline<br>
\rowcolor[rgb]{0.8,0.8,0.8}1 &amp; flight2reuse, &amp; \boxplot{17.700000}{3.500000}{21.200000}{12.100000}{33.300000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; improveteam, &amp; \boxplot{20.800000}{4.500000}{25.300000}{9.100000}{34.400000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; none, &amp; \boxplot{20.100000}{6.200000}{26.300000}{11.800000}{38.100000} \\<br>
3 &amp; reducefunc, &amp; \boxplot{18.700000}{8.500000}{27.200000}{11.000000}{38.200000} \\<br>
3 &amp; improveprecflex, &amp; \boxplot{22.400000}{7.700000}{30.100000}{11.800000}{41.900000} \\<br>
3 &amp; flight4reuse, &amp; \boxplot{23.000000}{7.200000}{30.200000}{12.400000}{42.600000} \\<br>
4 &amp; relaxschedule, &amp; \boxplot{21.000000}{7.500000}{28.500000}{18.400000}{46.900000} \\<br>
4 &amp; archriskresl, &amp; \boxplot{21.900000}{7.900000}{29.800000}{10.200000}{40.000000} \\<br>
5 &amp; improvepmat, &amp; \boxplot{21.200000}{10.000000}{31.200000}{15.100000}{46.300000} \\<br>
6 &amp; flight3reuse, &amp; \boxplot{23.800000}{10.600000}{34.400000}{10.400000}{44.800000} \\<br>
7 &amp; reducequality, &amp; \boxplot{30.600000}{5.500000}{36.100000}{11.400000}{47.500000} \\<br>
8 &amp; improvepcap, &amp; \boxplot{29.600000}{9.800000}{39.400000}{8.100000}{47.500000} \\<br>
9 &amp; improvetooltechplat, &amp; \boxplot{40.800000}{13.000000}{53.800000}{18.400000}{72.200000} \\<br>
10&amp; flight1reuse, &amp; \boxplot{31.400000}{35.500000}{66.900000}{14.700000}{81.600000} \\<br>
<br>
\end{tabular}~\begin{tabular}{|c r    @{} c  }<br>
\multicolumn{3}{|c}{Ground} \\\hline<br>
<br>
Rank &amp; Change &amp;  50\% \\<br>
\hline<br>
\rowcolor[rgb]{0.8,0.8,0.8}1 &amp; ground1reuse, &amp; \boxplot{15.400000}{5.100000}{20.500000}{28.500000}{49.000000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; ground4reuse, &amp; \boxplot{22.700000}{6.400000}{29.100000}{6.500000}{35.600000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; ground3reuse, &amp; \boxplot{23.300000}{6.000000}{29.300000}{7.300000}{36.600000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; improvepmat, &amp; \boxplot{22.700000}{9.400000}{32.100000}{5.100000}{37.200000} \\<br>
\rowcolor[rgb]{0.8,0.8,0.8}2 &amp; improveteam, &amp; \boxplot{21.900000}{10.400000}{32.300000}{9.900000}{42.200000} \\<br>
3 &amp; archriskresl, &amp; \boxplot{26.100000}{7.800000}{33.900000}{11.100000}{45.000000} \\<br>
4 &amp; none, &amp; \boxplot{29.100000}{5.000000}{34.100000}{7.600000}{41.700000} \\<br>
4 &amp; relaxschedule, &amp; \boxplot{30.800000}{2.700000}{33.500000}{7.800000}{41.300000} \\<br>
4 &amp; improveprecflex, &amp; \boxplot{24.400000}{13.700000}{38.100000}{7.500000}{45.600000} \\<br>
4 &amp; improvepcap, &amp; \boxplot{25.500000}{10.800000}{36.300000}{10.600000}{46.900000} \\<br>
5 &amp; reducefunc, &amp; \boxplot{27.800000}{6.900000}{34.700000}{8.000000}{42.700000} \\<br>
6 &amp; reducequality, &amp; \boxplot{27.200000}{10.700000}{37.900000}{6.900000}{44.800000} \\<br>
7 &amp; ground2reuse, &amp; \boxplot{25.700000}{23.300000}{49.000000}{30.400000}{79.400000} \\<br>
8 &amp; improvetooltechplat, &amp; \boxplot{38.800000}{20.100000}{58.900000}{6.000000}{64.900000} \\<br>
\end{tabular}<br>
}<br>
<br>
\caption{EFFORT: staff months (normalized 0..100\%):  top-ranked changes are shaded.}<br>
\label{fig:effort}<br>
\end{figure}<br>
</code></pre>


In a recent study of defect detectors this code was used to plot 100,000s of results into a very small space:<br>
<br>
<img width='500' src='http://ourmine.googlecode.com/svn/trunk/share/img/quartile.png'>



From this diagram, we seek stand-out results.<br>
<ul><li>A stand-out effect is a large and positive median with a highest quartile bunched up towards the maximum figure.<br>
</li><li>A negative stand-out is similar, but highly skewed towards the negative.</li></ul>

In the above diagram, the logNums.nb are a stand-out effect since:<br>
<ul><li>it has much higher medians than all the rest<br>
</li><li>the upper quartile is highly skewed towards the maximum</li></ul>

The oneR results are a negative stand-out since:<br>
<ul><li>it is highly skewed towards the negative.<br>
</li><li>In fact, it never does better than anything else, ever (since none of its deltas are positive).</li></ul>

My preference for quartile charts stems from several factors:<br>
<ul><li>They can summarize very large experiments very succinctly;<br>
</li><li>Unlike t-tests (discussed below), they make no assumptions the underlying distributions;<br>
</li><li>They only show that method1 is better than method2 if method1 exhibits stand-out effects.</li></ul>

T-tests, on the other hand, condone conclusions like "at the 95% confidence level a difference of 2% in this methods was shown to be statistically significant".<br>
<ul><li>Sometimes, "statistically significant" is actually quite insignificant and unimpressive.<br>
</li><li>And t-tests have their own subtle problems.</li></ul>

Students of data mining should be aware that this view of mine is an (extremely) minority view. So, unless you want to be an army of one, I'd best teach you about the standard way the performance of different learners are evaluated; i.e. t-tests and win-loss tables.<br>
<br>
<h1>T-Tests & Win-loss tables</h1>

When Hall & Holmes report the results of their feature subset selectors, they present the following table of mean performances:<br>
<br>
<img width='500' src='http://ourmine.googlecode.com/svn/trunk/share/img/resultshh.png'>

Note the white and black circles comparing the column one figures to the rest. This show results that are significantly different- a concept we will explore in just a second.<br>
<br>
Hall & Holmes also report their studies in terms of win-loss tables that compare pairs of performance between learners.<br>
<br>
<ul><li>If the results are not significantly different, there is a tie (one point to each item in the pair)<br>
</li><li>If the results are significantly different, then someone losses (one point) and someone wins (one point).<br>
<pre><code>      function winLossTie(i,j,n,sum,sumSq, comp) {<br>
          comp= compare(mean(n,sum), sd(n,sum,sumSq), n, n-1)<br>
          if (comp == 0) { Tie[i]++;  Tie[j]++;  }<br>
          if (comp &gt;  0) { Win[i]++;  Loss[j]++; }<br>
          if (comp &lt;  0) { Loss[i]++; Win[j]++;  }<br>
      }<br>
</code></pre>
</li><li>These results are sorted in the order win - loss<br>
<img width='300' src='http://ourmine.googlecode.com/svn/trunk/share/img/winloss.png'></li></ul>

Such win-loss tables :<br>
<br>
<ul><li>Are succinct (very)<br>
</li><li>But:<br>
<ul><li>They ignore the size of the wins and losses (something featured in the quartile charts)<br>
<ul><li>on the other hand, some argue that this is a feature, not a bug<br>
</li></ul></li><li>They makes certain assumptions about the underlying distributions<br>
<ul><li>and, just recently, I have been badly burned by blindly applying t-tests without looking at the underlying distribution.<br>
</li><li>So I do both quartile charts and win-loss tables.</li></ul></li></ul></li></ul>

Anyway, what does statistically different mean?<br>
<br>
<ul><li>When testing for different distributions, the higher the confidence, the more we demand that the distributions don't overlap. Standard practice is to try either a 95% or 99% confidence levels.<br>
</li><li>This test requires making an assumption of the underlying distribution. If we assume a normal or Gaussian curve, then we can compute the mean and spread (a.k.a. standard deviation) of that distribution in a single pass of the data as follows:<br>
<ul><li>let n be the number of values;<br>
</li><li>let sum be the sum of the values; i.e. sum = sum + value;<br>
</li><li>let sumSq be the sum of the square of the values; i.e. sumSq = sumSq + value*value<br>
</li><li>let the mean and standard deviation be calculated as follows:<br>
<pre><code>function mean(sum,n)  {<br>
     return sum/n <br>
}<br>
function standardDeviation(sumSq,sum,n)  {<br>
     return sqrt((sumSq-((sum*sum)/n))/(n-1)) <br>
}<br>
</code></pre>
(BTW, A "normal" or Gaussian distribution has a middle value (the mean) and spreads out evenly on both sides by an amount controlled by the standard deviation: large deviations lead to broad curves (e.g. the blue curve) and small deviations lead to sharply falling curves (e.g. the red curve).<br>
)</li></ul></li></ul>

<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/normals.png'>

To test if two distributions are different, we assume that they are normal curves and seek all pairs of performance deltas and study the mean and standard deviation as follows:<br>
<pre><code>function tval(mean,sd,n)  { <br>
    return mean/(sd/sqrt(n)) <br>
}<br>
</code></pre>
If this fraction is small enough, then:<br>
<br>
<ul><li>the mean of the differences is small, so the two distributions are the same;<br>
</li><li>OR the standard deviation is large so you can't really distinguish the two distributions;<br>
</li><li>OR the sample sample size n is very large so even if we have small mean differences and large standard deviations, there are enough examples around to show that even small observed differences denote actual differences in the distribution.</li></ul>

But what does small enough mean? The answer depends on how large is your sample and how confident you want to be. High confidence and small sample sizes need LARGE tval differences to demonstrate their differences:<br>
<pre><code>BEGIN { <br>
    ## T[k,c]<br>
    #  k = degrees of freedom = n = 1<br>
    #  if c = 0.05, then confidence = 95%<br>
    #  if c = 0.01, then confidence = 99%<br>
    T2[1,0.05] = 12.706;    T2[1,0.01] = 63.6570;<br>
    T2[2,0.05] = 4.3030;    T2[2,0.01] = 9.9250;<br>
    T2[3,0.05] = 3.1820;    T2[3,0.01] = 5.8410;<br>
    T2[4,0.05] = 2.7760;    T2[4,0.01] = 4.6040;<br>
    T2[5,0.05] = 2.5710;    T2[5,0.01] = 4.0320;<br>
    T2[6,0.05] = 2.4470;    T2[6,0.01] = 3.7070;<br>
    T2[7,0.05] = 2.3650;    T2[7,0.01] = 3.4990;<br>
    T2[8,0.05] = 2.3060;    T2[8,0.01] = 3.3550;<br>
    T2[9,0.05] = 2.2620;    T2[9,0.01] = 3.2500;<br>
    T2[10,0.05] = 2.2280;   T2[10,0.01] = 3.1690;<br>
    T2[11,0.05] = 2.2010;   T2[11,0.01] = 3.1060;<br>
    T2[12,0.05] = 2.1790;   T2[12,0.01] = 3.0550;<br>
    T2[13,0.05] = 2.1600;   T2[13,0.01] = 3.0120;<br>
    T2[14,0.05] = 2.1450;   T2[14,0.01] = 2.9770;<br>
    T2[15,0.05] = 2.1310;   T2[15,0.01] = 2.9470;<br>
    T2[16,0.05] = 2.1200;   T2[16,0.01] = 2.9210;<br>
    T2[17,0.05] = 2.1100;   T2[17,0.01] = 2.8980;<br>
    T2[18,0.05] = 2.1010;   T2[18,0.01] = 2.8780;<br>
    T2[19,0.05] = 2.0930;   T2[19,0.01] = 2.8610;<br>
    T2[20,0.05] = 2.0860;   T2[20,0.01] = 2.8450;<br>
    T2[21,0.05] = 2.0800;   T2[21,0.01] = 2.8310;<br>
    T2[22,0.05] = 2.0740;   T2[22,0.01] = 2.8190;<br>
    T2[23,0.05] = 2.0690;   T2[23,0.01] = 2.8070;<br>
    T2[24,0.05] = 2.0640;   T2[24,0.01] = 2.7970;<br>
    T2[25,0.05] = 2.0600;   T2[25,0.01] = 2.7870;<br>
    T2[26,0.05] = 2.0560;   T2[26,0.01] = 2.7790;<br>
    T2[27,0.05] = 2.0520;   T2[27,0.01] = 2.7710;<br>
    T2[28,0.05] = 2.0480;   T2[28,0.01] = 2.7630;<br>
    T2[29,0.05] = 2.0450;   T2[29,0.01] = 2.7560;<br>
    T2[30,0.05] = 2.0420;   T2[30,0.01] = 2.7500;<br>
    T2[35,0.05] = 2.03;     T2[35,0.01] = 2.72;<br>
    T2[40,0.05] = 2.02;     T2[40,0.01] = 2.7;<br>
    T2[45,0.05] = 2.01;     T2[45,0.01] = 2.69;<br>
    T2[50,0.05] = 2.01;     T2[50,0.01] = 2.68;<br>
    T2[55,0.05] = 2;        T2[55,0.01] = 2.67;<br>
    T2[60,0.05] = 2;        T2[60,0.01] = 2.66;<br>
    T2[65,0.05] = 2;        T2[65,0.01] = 2.65;<br>
    T2[70,0.05] = 1.99;     T2[70,0.01] = 2.65;<br>
    T2[75,0.05] = 1.99;     T2[75,0.01] = 2.64;<br>
    T2[80,0.05] = 1.99;     T2[80,0.01] = 2.64;<br>
    T2[85,0.05] = 1.99;     T2[85,0.01] = 2.63;<br>
    T2[90,0.05] = 1.99;     T2[90,0.01] = 2.63;<br>
    T2[95,0.05] = 1.99;     T2[95,0.01] = 2.63;<br>
    T2[100,0.05] = 1.98;    T2[100,0.01] = 2.63;<br>
    T2[200,0.05] = 1.97;    T2[200,0.01] = 2.6;<br>
    T2[500,0.05] = 1.96;    T2[500,0.01] = 2.59;<br>
    T2[1000,0.05] = 1.96;   T2[1000,0.01] = 2.58;<br>
    T2["inf",0.05] = 1.96;  T2["inf",0.01] = 2.58;<br>
}<br>
</code></pre>
<h1>Evaluation traps</h1>
An excessive obsession with evaluation can stunt the development of novel ideas.<br>
<br>
<ul><li>Sadly, this is a rare problem.</li></ul>

<h1>Not enough browsing</h1>

Running scripts and equations is no substitute for looking at the raw distributions:<br>
<br>
<ul><li>Often, there are surprises in the data that the standard statistical methods never see.<br>
<ul><li>e.g. MRE from ten instances = 11,15,18,20,23,25,29,31,100,100<br>
<ul><li>then the PRED(30) = 80%<br>
</li><li>and the evaluation misses two disasters (100% MRE- total error).<br>
</li></ul></li></ul></li><li>e.g. all the following plots have a correlation between {x,y} of 0.81</li></ul>

<h1>Mis-guided measures of success</h1>

Some evaluation methods are actually quite uninformative<br>
<br>
<ul><li>e.g. PRED(N)<br>
<ul><li>rewards theories that predict close to actual (says nothing about how bad the bad cases are)<br>
</li></ul></li><li>e.g. MMRE<br>
<ul><li>insults theories where predictions are far away from actual (says nothing about how good the good cases are)<br>
</li></ul></li><li>e.g. Accuracy a very poor measure of theory performance when the target class is very rare.<br>
<ul><li>e.g. 10 target classes in 990 instances<br>
</li><li>if we miss all the target, and be silent all the time, A=990, B=10, D=0 , A+B+C+D=1000<br>
</li><li>accuracy = (A+D) / (A+B+C+D) = (990+0)/1000 = 99.9% accuracy<br>
</li><li>e.g. the above roc-sheet where A=395, B=67, C=19, D=39<br>
</li><li>accuracy = 83% but the probability of finding the target is only 37%.<br>
</li><li>e.g. here's one study were hundreds of detectors were built many ways for one data set (including LSR, model trees, Attribute over threshold, etc,etc) and scored by {accuracy,pd,pf,effort} (effort being what % of the code was falgged as "defect-prone").<br>
<ul><li>note how accuracy can remain constant while PD, PF change dramatically.</li></ul></li></ul></li></ul>

<h1>The World is Not Normal</h1>

For non-normal distributions, use signed ranked tests instead of raw numbers.<br>
<br>
Suppose some treatment A generates N1=5 values<br>
{5,7,2,0,4} and treatment B<br>
generates N2=6 values<br>
{4,8,2,3,6,7}, then these sort as<br>
follows:<br>
<pre><code>Samples A A B B A B A B A B B <br>
Values  0 2 2 3 4 4 5 6 7 7 8 <br>
</code></pre>


<pre><code>Samples A A   B   B A   B   A B A   B   B <br>
Values  0 2   2   3 4   4   5 6 7   7   8 <br>
Ranks   1 2.5 2.5 4 5.5 5.5 7 8 9.5 9.5 11 <br>
</code></pre>
Then, for <i>paired</i> experiments (same data, different treatments) use Wilcoxon and for <i>non-paired</i>
use Mann-Whitney (shown below):<br>
<br>
<img width='400' src='http://ourmine.googlecode.com/svn/trunk/share/img/mwu.png'>

For full source  see <a href='http://ourmine.googlecode.com/svn/trunk/our/lib/awk/ranked.awk'>http://ourmine.googlecode.com/svn/trunk/our/lib/awk/ranked.awk</a>.