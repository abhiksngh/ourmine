<img width='250' align='right' src='http://ourmine.googlecode.com/svn/trunk/share/img/raisinBread.jpg'>
Instance-based methods don't <i>think</i>, they don't build models from data. Instead, they take new things and float them nearest the older things.<br>
<br>
In this approach:<br>
<br>
<ul><li>testing means taking new things, then finding their nearby older things<br>
</li><li>training means stuffing the older things into some raisin bread (the analogy isn't perfect: raisin bread is  3-dimensional object and a data set with N columns makes for an N-dimensional space.... mmmm, N-dimensional bread.... so tasty).</li></ul>

<pre><code>dev_mode,   rely   ,data   ,cplx  ... ,loc ,time2Develop<br>
========    ====    ====    ====       ===  ============<br>
embedded,   0.75   ,0.94   ,1.3   ... , 13   ,82<br>
embedded,   0.88   ,1.16   ,0.7,  ... ,113 ,2040<br>
embedded,   0.88   ,1.16   ,0.85, ... ,293 ,1600<br>
embedded,   0.94   ,1      ,0.85, ... , 48 , 387<br>
embedded,   1      ,1.16   ,1.15, ... ,252 ,2455<br>
embedded,   1.15   ,0.94   ,1.3,      , 22 ,1075<br>
</code></pre>

<h1>How to find your nearest raisin?</h1>

Euclidean distance :<br>
<br>
<ul><li>sqrt( (x2-x1)<sup>2</sup> + (y2-y1)<sup>2</sup> + ... )<br>
</li><li>for non-numerics:<br>
<ul><li>distance = 0 if the same<br>
</li><li>distance = 1 if different<br>
</li></ul></li><li>normalize: replace X with (X - MinX)/(MaxX - MinX).<br>
</li><li>distort some dimensions if they are more important that others</li></ul>

Squared Euclidean :<br>
<br>
<ul><li>Place progressively greater weight on objects that are further apart.</li></ul>

City-block (Manhattan) :<br>
<br>
<ul><li>Average difference across dimensions.<br>
<ul><li>sum(abs(x2 - x1) + abs(y2 - y1) + ..)<br>
</li></ul></li><li>Usually, same results as Euclidean<br>
<ul><li>But dampens effect of single large differences (outliers) is dampened</li></ul></li></ul>

Chebychev distance :<br>
<br>
<ul><li>Maximum(abs(x2 - x1) + abs(y2 - y1) + ..)<br>
</li><li>Things are "different" if they are different on any dimensions.</li></ul>

<h1>Example (sorting out the Raisins)</h1>

Find the nearest neighbor of the training data. Build one "pretend" instance half-way between each instance:<br>
<br>
<ul><li>For numeric data, half-way is (x1-x2)/2, (y1-y2)/2, etc<br>
</li><li>For all the discrete columns with different values, flip half of them (picked at random) to the value in the other instance.</li></ul>

<img width='350' align='right' src='http://ourmine.googlecode.com/svn/trunk/share/img/Binary_tree.png'>

Now repeat to form a binary tree whose leaves (in green) are the real data and the rest is made-up stuff. This is called GAC: <i>Greedy Agglomerative Clustering</i>. Warning: it is very slow.<br>
<br>
Premise of instance-based learning is that it is local neighborhoods are <i>better</i> than casting a wider net. In terms of recursively descending the tree, this premise is true if the variance of sub-trees is less than the super tree.<br>
<br>
<ul><li>variance: <img src='http://upload.wikimedia.org/math/6/c/8/6c84cac9b183bb78e05fb51205f7f7a0.png'>
</li><li>variance of a sub-tree: go to the instances in the leaves and compute the variance of their output variable.<br>
</li><li>weighted variance beneath a node: give three subtrees containing N=N1+N2+N3 leaf nodes with variance V1,V2,V3 then the weighted variance is<br>
<ul><li><code> V1*N1/N + V2*N2/N + V3*N3/N </code></li></ul></li></ul>

To make a prediction, take a test instance<br>
<ul><li>move it to the sub-tree with the closest root.<br>
</li><li>stop descending when<br>
<ul><li>the size of the sub-tree is "k" (some fixed constant)<br>
</li><li>the weighted-variance of the subtree is greater than the current tree<br>
</li></ul></li><li>After stopping, return the median performance statistic of the leaves in the sub-tree.</li></ul>

How big should "k" be?<br>
<ul><li>k = 10<br>
</li><li>k = sqrt(leaf nodes)<br>
</li><li>try k = 1 to size of tree and use the k that has the smaller error<br>
</li><li>Jacky's rules (for software effort estimation).<br>
<ul><li>If more than 50 instances, k=3,4,5.<br>
</li><li>If less than 50 instances, k=1,2<br>
</li><li>If less than 20 instances, try to collect more instances!</li></ul></li></ul>

By the way<br>
<ul><li>Selection of k is irrelevant if stopping using weighted sub-tree variance.<br>
</li><li>And it doesn't matter so much (in the results below, nearly the same behavior for k=2,4,8,16)</li></ul>

<h1>Trust (what raisins are hard to swallow?)</h1>

Nice features of this approach<br>
<ul><li>In some data sets, there is a relationship between prediction error and variance of the performance statistic in the sub-tree<br>
</li><li>So we can return not just the estimate, but an <i>trust</i> measure of how much we should believe that estimate.</li></ul>

In the following experiments, 20 times, we took out one training instance, GAC the remaining, then estimated the set-aside. Note that after some critical value of variance (on the x-axis), the error spikes (on the y-axis). So, if your test instance falls into sub-trees with that variance, <b>do not trust the estimate</b>.<br>
<br>
E.g. <a href='http://promisedata.org/repository/data/coc81/coc81_1_1.arff'>Coc81</a>:<br>
<br>
<ul><li>x-axis: weighted variance of sub-tree<br>
</li><li>y-axis: log of error = magnitude of relative error = abs(actual - predicted)/ actual</li></ul>


<img width='500' align='center' src='http://ourmine.googlecode.com/svn/trunk/share/img/coc81mreVar.jpg'>



<a href='http://promisedata.org/repository/data/nasa93/nasa93.arff'>Nasa93</a>

<ul><li>x-axis: weighted variance of sub-tree<br>
</li><li>y-axis: log of error = magnitude of relative error = abs(actual - predicted)/ actual</li></ul>


<img width='500' align='center' src='http://ourmine.googlecode.com/svn/trunk/share/img/nasa93mreVar.jpg'>

<a href='http://promisedata.org/repository/data/desharnais/desharnais_1_1.arff'>Desharnis</a>

<ul><li>x-axis: weighted variance of sub-tree<br>
</li><li>y-axis: log of error = magnitude of relative error = abs(actual - predicted)/ actual</li></ul>

<img width='600' align='center' src='http://ourmine.googlecode.com/svn/trunk/share/img/desharnaisMreVar.jpg'>