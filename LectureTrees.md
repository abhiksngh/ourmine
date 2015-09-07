In this lecture, we discuss "iterative dichotomization"
  * Split things up
  * Recurse on each split

# How to generate a tree #

  * Given a bag of mixed-up stuff.
    * Need a measure of "mixed-up"
  * Split: Find something that divides up the bag in two new sub-bags
    * And each sub-bag is less mixed-up;
    * Each split is the root of a sub-tree.
  * Recurse: repeat for each sub-bag
    * i.e. on just the data that falls into each part of the split
      * Need a Stop rule
      * Condense the instances that fall into each sub-bag
  * Prune back the generated tree.

Different tree learners result from different selections of

  * CART: (regression trees)
    * measure: standard deviation
      * Three "normal" curves with [different standard deviations](http://upload.wikimedia.org/wikipedia/commons/1/1b/Normal_distribution_pdf.png)
      * Expected values under the normal curve
> > <img src='http://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Standard_deviation_diagram.svg/350px-Standard_deviation_diagram.svg.png'>
<ul><li>condense: report the average of the instances in each bag.<br>
</li></ul></li></ul><ul><li>M5prime: (model trees)<br>
<ul><li>measure: standard deviation<br>
</li><li>condense: generate a linear model of the form a+b <code>*</code> x1 +c <code>*</code> x2 + d <code>*</code> x3 +...<br>
</li></ul></li><li>J48: (decision trees)<br>
<ul><li>measure: "entropy"<br>
</li></ul></li></ul><blockquote><img src='http://upload.wikimedia.org/math/a/e/f/aef122e9c7f64d071b2acb4d17e88000.png'>
<ul><li>condense: report majority class</li></ul></blockquote>

# Example: C4.5 (a.k.a. J48) #

<img width='500' src='http://www.csee.wvu.edu/~timm/cs591o/old/images/splits.jpg'>

Q: which attribute is the best to split on?<br>
<br>
A: the one which will result in the smallest tree:<br>
<br>
Heuristic: choose the attribute that produces the "purest" nodes (purity = not-mixed-up)<br>
<br>
e.g. Outlook= sunny<br>
<br>
<ul><li>info((2,3))= entropy(2/5,3/5) = -2/5 <code>*</code> log(2/5) - 3/5 <code>*</code> log(3/5) = 0.971 bits</li></ul>

Outlook = overcast<br>
<br>
<ul><li>info((4,0)) = entropy(1,0) = -1 <code>*</code> log(1) - 0 <code>*</code> log(0) = 0 bits</li></ul>

Outlook = rainy<br>
<br>
<ul><li>info((3,2)) = entropy(3/5, 2/5) = -3/5 <code>*</code> log(3/5) - 2/5 <code>*</code> log(2/5) = 0.971 bits</li></ul>

Expected info for Outlook = Weighted sum of the above<br>
<br>
<ul><li>info((3,2),(4,0),(3,2)) = 5/14 <code>*</code> 0.971 + 4/14 <code>*</code> 0 + 5/14 <code>*</code> 0.971 = 0.693</li></ul>

Computing the information gain<br>
<br>
<ul><li>e.g. information before splitting minus information after splitting<br>
</li><li>e.g. gain for attributes from weather data:<br>
</li><li>gain("Outlook") = info([9,5]) - info([2,3],[4,0],[3,2]) = 0.940 - 0.963 = 0.247 bits<br>
</li><li>gain("Temperature") = 0.247 bits<br>
</li><li>gain("Humidity") = 0.152 bits<br>
</li><li>gain("Windy") = 0.048 bits</li></ul>

<h2>Problem: Numeric Variables</h2>

No problem:<br>
<ul><li>use <a href='http://code.google.com/p/ourmine/wiki/LecturePrep#Supervised_Discretization'>cliff learning</a> to split the numerics<br>
</li><li>Standard method proposed by <a href='http://code.google.com/p/ourmine/wiki/Ff#Fayyad93'>Fayyad</a>.</li></ul>


<h2>Problem: Highly-branching attributes</h2>

Problematic:<br>
<br>
<ul><li>attributes with a large number of values (extreme case: ID code)<br>
</li><li>Subsets are more likely to be pure if there is a large number of values<br>
</li><li>Information gain is biased towards choosing attributes with a large number of values<br>
</li><li>This may result in over fitting (selection of an attribute that is non-optimal for prediction); e.g.<br>
<pre><code>          ID code    Outlook     Temp.    Humidity    Windy    Play<br>
            A          Sunny       Hot      High        False    No<br>
            B          Sunny       Hot      High        True     No<br>
            C          Overcast  Hot        High        False    Yes<br>
            D          Rainy       Mild     High        False    Yes<br>
            E          Rainy       Cool     Normal      False    Yes<br>
            F          Rainy       Cool     Normal      True     No<br>
            G          Overcast    Cool     Normal      True     Yes<br>
            H          Sunny       Mild     High        False    No<br>
            I          Sunny       Cool     Normal      False    Yes<br>
            J          Rainy       Mild     Normal      False    Yes<br>
            K          Sunny       Mild     Normal      True     Yes<br>
            L          Overcast    Mild     High        True     Yes<br>
            M          Overcast    Hot      Normal      False    Yes<br>
            N          Rainy       Mild     High        True     No%%<br>
</code></pre>
</li><li>If we split on ID we get N sub-trees with one class in each;<br>
</li><li>info("ID code")= info((0,1)) + info((0,1)) + ... + info((0,1)) = 0 bits<br>
</li><li>So the info gain is 0.940 bits</li></ul>

Solution 1: Ignore columns with more than N unique values (where N = m<code>*</code>NumberOfRows).<br>
Solution 1: the gain ratio<br>
<br>
<ul><li>Gain ratio: a modification of the information gain that reduces its bias<br>
</li><li>Gain ratio takes number and size of branches into account when choosing an attribute<br>
</li><li>It corrects the information gain by taking the intrinsic information of a split into account<br>
</li><li>Intrinsic informations: entropy of distribution of instances into branches (i.e. how much info do we need to tell which branch an instance belongs to)</li></ul>

<h2>Problem: Conclusion Instability</h2>

Recall the shape of a log curve <img width='300' src='http://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Logarithms.svg/456px-Logarithms.svg.png'>.<br>
<br>
Now play with small values of -p<code>*</code>log(p); consider what happens if I change those values by plus/minus 30%.<br>
<br>
The great ones say:<br>
<ul><li>It is well known that the error rate of a tree on the cases from which it was constructed (the re-substitution error rate) is much lower than the error rate on unseen cases (the predictive error rate).<br>
</li><li>For example, on a well-known letter recognition dataset with 20,000 cases, the re-substitution error rate for C4.5 is 4%, but the error rate from a leave-one-out (20,000-fold) cross-validation is 11.7%.<br>
</li><li>As this demonstrates, leaving out a single case from 20,000 often affects the tree that is constructed!</li></ul>

<h2>Problem: Comprehension</h2>

Trees can hide simple rules<br>
<br>
Naive conversion<br>
<br>
<ul><li>One rule for each leaf:<br>
</li><li>Antecedent contains a condition for every node on the path from the root to the leaf</li></ul>

Problems with Naive Conversion<br>
<br>
Example 1: Simple rules, complex tree<br>
<br>
<ul><li>Rules:<br>
<pre><code>      If a and b then x <br>
      If c and d then x<br>
</code></pre>
</li><li>Tree:<br>
<pre><code>      if a == y <br>
      then if b == y <br>
           then x<br>
           else if b == n<br>
                then if c == y<br>
                     then if d == y <br>
                          then x<br>
      else if b == n<br>
           then if c == y <br>
                then if d == y<br>
                     then x<br>
</code></pre></li></ul>

Example 2: Simple tree, complex rules<br>
<ul><li>Tree:<br>
<pre><code>      if x == 1<br>
         then if y == 1<br>
              then b<br>
              else a<br>
         else if y == 1<br>
              then a<br>
              else b<br>
</code></pre>
</li><li>Rules (unaware of structure)<br>
<pre><code>      if x == 1 and y == 0 then a<br>
      if x == 0 and y == 1 then a<br>
      if x == 0 and y == 0 then b<br>
      if x == 1 and y == 1 then b<br>
</code></pre></li></ul>

Example 3: the replicated subtree problem<br>
<ul><li>Rules:<br>
<pre><code>      if x == 1 and y == 1 then a<br>
      if z == 1 and w == 1 then a<br>
      otherwise b<br>
</code></pre>
</li><li>Tree:<br>
<pre><code>      if x == 1<br>
      then if y == 1<br>
           then a<br>
           else if y == 2<br>
                then SUB<br>
                else if y == 3<br>
                     then SUB<br>
       else if y == 2<br>
            then SUB<br>
            else if y == 3<br>
                 then SUB<br>
<br>
      SUB : ( if z == 1<br>
              then if w == 1<br>
                   then a<br>
                   else if w == 2<br>
                         then b<br>
                         else if w == 3<br>
                               then b<br>
               else if z == 2<br>
                     then b<br>
                     else if z == 3<br>
                          then b <br>
      )<br>
</code></pre>
<h1>Other tree learning</h1>
<h2>Regression trees</h2></li></ul>

<ul><li>Differences to decision trees:<br>
</li><li>Splitting criterion: minimizing intra-subset variation<br>
</li><li>Pruning criterion: based on numeric error measure<br>
</li><li>Leaf node predicts average class values of training instances reaching that node<br>
</li><li>Can approximate piecewise constant functions<br>
</li><li>Easy to interpret:<br>
<pre><code>          curb-weight &lt;= 2660 :<br>
          |   curb-weight &lt;= 2290 :<br>
          |   |   curb-weight &lt;= 2090 :<br>
          |   |   |   length &lt;= 161 : price=6220<br>
          |   |   |   length &gt;  161 : price=7150<br>
          |   |   curb-weight &gt;  2090 : price=8010<br>
          |   curb-weight &gt;  2290 :<br>
          |   |   length &lt;= 176 : price=9680<br>
          |   |   length &gt;  176 :<br>
          |   |   |   normalized-losses &lt;= 157 : price=10200<br>
          |   |   |   normalized-losses &gt;  157 : price=15800<br>
          curb-weight &gt;  2660 :<br>
          |   width &lt;= 68.9 : price=16100<br>
          |   width &gt;  68.9 : price=25500<br>
</code></pre></li></ul>

<ul><li>More sophisticated version: model trees</li></ul>

<h2>Model trees</h2>

<ul><li>Regression trees with linear regression functions at each node<br>
<pre><code>          curb-weight &lt;= 2660 :<br>
          |   curb-weight &lt;= 2290 : LM1<br>
          |   curb-weight &gt;  2290 :<br>
          |   |   length &lt;= 176 : LM2<br>
          |   |   length &gt;  176 : LM3<br>
          curb-weight &gt;  2660 :<br>
          |   width &lt;= 68.9 : LM4<br>
          |   width &gt;  68.9 : LM5<br>
          .<br>
          LM1:  price = -5280 + 6.68 * normalized-losses<br>
                              + 4.44 * curb-weight<br>
                              + 22.1 * horsepower - 85.8 * city-mpg<br>
                              + 98.6 * highway-mpg<br>
          LM2:  price = 9680<br>
          LM3:  price = -1100 + 91 * normalized-losses<br>
          LM4:  price = 9940 + 47.5 * horsepower<br>
          LM5:  price = -19000 + 13.2 * curb-weight<br>
</code></pre></li></ul>

<ul><li>Linear regression applied to instances that reach a node after full regression tree has been built<br>
</li><li>Only a subset of the attributes is used for LR<br>
</li><li>Attributes occurring in subtree (+maybe attributes occurring in path to the root)<br>
</li><li>Fast: overhead for LR not large because usually only a small subset of attributes is used in tree</li></ul>

Building the tree<br>
<br>
<ul><li>Splitting criterion: standard deviation reduction into i bins<br>
</li><li>SDR = sd(T) - sum( ( |Ti| / |T| <code>*</code> sd(Ti) ) )<br>
<ul><li>where (|T| = number of instances in that tree).<br>
</li></ul></li><li>Termination criteria (important when building trees for numeric prediction):<br>
</li><li>Standard deviation becomes smaller than certain fraction of sd for full training set (e.g. 5%)<br>
</li><li>Too few instances remain (e.g. less than four)</li></ul>

Smoothing (Model Trees)<br>
<br>
<ul><li>Naive method for prediction outputs value of LR for corresponding leaf node<br>
</li><li>Performance can be improved by smoothing predictions using internal LR models<br>
</li><li>Predicted value is weighted average of LR models along path from root to leaf<br>
</li><li>Smoothing formula: p' = (np+kq)/(n+k)<br>
</li><li>p' is what gets passed up the tree<br>
</li><li>p is what got passed from down the tree<br>
</li><li>q is the value predicted by the linear models at this node<br>
</li><li>n is the number of examples that fall down to here<br>
</li><li>k magic smoothing constant; default=2</li></ul>

