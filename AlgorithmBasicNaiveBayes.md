(Note that these are introductory notes only. For more details, see AlgorithmNaiveBayes.)

# The method #

To classify a new example:
  * Break it up into its parts
  * Count how often the parts have appeared in the past for class C1,C2,C3,etc
  * Return the class where the parts appear most frequently.

Important techniques:
  * Express all counts as ratios of the class frequencies (see below).
  * Use the counts to _tune_ prior expectations (i.e. the raw class frequencies).

# Example #
Will we play golf? Here is our new example:
```
Outlook       Temp.         Humidity    Windy         Play
Sunny         Cool          High        True          ?%%
```
Here is our old data:
```
outlook  temperature  humidity   windy   play
-------  -----------  --------   -----   ----
rainy    cool        normal    TRUE    no
rainy    mild        high      TRUE    no
sunny    hot         high      FALSE   no
sunny    hot         high      TRUE    no
sunny    mild        high      FALSE   no
overcast cool        normal    TRUE    yes
overcast hot         high      FALSE   yes
overcast hot         normal    FALSE   yes
overcast mild        high      TRUE    yes
rainy    cool        normal    FALSE   yes
rainy    mild        high      FALSE   yes
rainy    mild        normal    FALSE   yes
sunny    cool        normal    FALSE   yes
sunny    mild        normal    TRUE    yes%%
```
How often have we seen stuff in the past?
```
           Outlook            Temperature           Humidity
====================   =================   =================
          Yes    No            Yes   No            Yes    No
Sunny       2     3     Hot     2     2    High      3     4
Overcast    4     0     Mild    4     2    Normal    6     1
Rainy       3     2     Cool    3     1

            Windy        Play
=================    ========
      Yes     No     Yes   No
False 6      2       9     5
True  3      3
```
Remember to express all counts as ratios of the class frequencies:
```
           Outlook            Temperature           Humidity
====================   =================   =================
          Yes    No            Yes   No            Yes    No
Sunny     2/9   3/5     Hot   2/9   2/5    High    3/9   4/5
Overcast  4/9   0/5     Mild  4/9   2/5    Normal  6/9   1/5
Rainy     3/9   2/5     Cool  3/9   1/5

            Windy        Play
=================    ========
      Yes     No     Yes   No
False  6/9    2/5   9/14  5/14
True   3/9    3/5
```
Use the counts to _tune_ prior expectations (play=9/14; do not play=5/14):
  * For "yes": `2/9 * 3/9 * 3/9 * 3/9 * 9/14 = 0.0053`
  * For "no":  `3/5 * 1/5 * 4/5 * 3/5 * 5/14  = 0.0206`

Return the class where the parts appear most frequently:
  * "No" is four times more likely than "yes"

# Issues #

For notes on the following, see [AlgorithmNaiveBayes](AlgorithmNaiveBayes.md)
  * Correlated variables:
  * Handling numeric
  * Explanation
  * This scheme works surprisingly well. Why?

Handling low-frequency counts (one "zero" can really cause a problem).

Extreme approach: see [AlgorithmTWCNB](AlgorithmTWCNB.md).

More usual approach (much simpler):
  * Add lower bounds on the counts to handle low frequency counts

Handling low frequency   priors:
  * Before:
    * `(#ofClass / # instances) = (5/14)`
  * Now:
    * `(#ofClass + K) / (#instances + K*#Classes) = (5+K) /(14 + K*2)`
  * Default, K=1 so prior(no) = 6/16 = 0.375
  * Note as #ofClass gets larger, influence of K disappears

Handling low frequency counts:
  * Before:
    * `(count / #ofClass) = (0 /5)` for  no.outlook=overcast
  * Now:
    * `(count + M*prior) / (#ofClass + M) = (0 + M*0.375) / (2 + M)`
  * Default, M=2 so count(outlook=overcast given "n") = 0.1875
  * Note as count gets larger or #ofClass gets larger, influence of M disappears.

Note wh