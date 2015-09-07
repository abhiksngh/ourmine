
```
For all classes c in C 
Create a R with an empty condition that predicts for class C . 
Until R is pure (or there are no more features) do 
  (a) For each feature F not mentioned in R 
          For each value v in F , consider adding F = v to the condition of R 
  (b) Select F and v to maximize p/t where 
         - t is total number of examples of class C 
         -  and p is the number of examples of class C selected by F = v. 
      Break ties by choosing the condition with the largest p. 
  (c) Add F = v to R 
Print R 
Remove the examples covered by R. 
If there are examples left, go back to start
```
Example:
```
@relation weather.nominal

@attribute outlook {sunny, overcast, rainy}
@attribute temperature {hot, mild, cool}
@attribute humidity {high, normal}
@attribute windy {TRUE, FALSE}
@attribute play {yes, no}

@data
rainy,    cool, normal,  TRUE,  no
rainy,    mild,   high,  TRUE,  no
sunny,    mild,   high, FALSE,  no
sunny,     hot,   high, FALSE,  no
sunny,     hot,   high,  TRUE,  no
sunny,    cool, normal, FALSE, yes
sunny,    mild, normal,  TRUE, yes
rainy,    cool, normal, FALSE, yes
rainy,    mild, normal, FALSE, yes
rainy,    mild,   high, FALSE, yes
overcast, cool, normal,  TRUE, yes
overcast, mild,   high,  TRUE, yes
overcast,  hot, normal, FALSE, yes
overcast,  hot,   high, FALSE, yes
```


OUTPUT:
```
     if outlook = overcast                       then yes
else if humidity = normal and windy = FALSE      then yes
else if temperature = mild and humidity = normal then yes
else if outlook = rainy and windy = FALSE        then yes
else if outlook = sunny and humidity = high      then no
else if outlook = rainy and windy = TRUE         then no
```

Note that PRISM suffers from over-fitting. This problem is addressed in

  * [Induct](AlgorithmInduct.md) : explores each rule-condition in reverse order of addition, and removes conditions which seem dull.
  * [Ripper](AlgorithmRipper.md) : builds then prunes rule conditions; then builds and prunes sets of rules; then does some other optimizations to see if rules can be replaced by the simplest dumbest alternative.