# Project 1a #

In this project you will do some introductory LISP exercises.

Before following these instructions, follow the StartUpInstructions

# Study the Unit Test tool #

Familiarize yourself with the Ourmine unit test system.
Ourmine was written using  a test-driven development method. Much of the code has _deftest_ unit test
statements that checks what works. For more on deftest, see
http://code.google.com/p/ourmine/wiki/LispCode#tests.

For an example of a specific test, see
the last function in http://code.google.com/p/ourmine/source/browse/trunk/our/lib/lisp/tricks/string.lisp
This code checks that the _samep_ function compares strings without consideration of upper and lower case
or white space:
```
(deftest test-samep ()
    (check 
		(samep "4 Score and SEVEN years
                  ago our     fore-fathers"
                  "4 score and seven years ago our fore-fathers"))
```
It can be run via _(test-samep)_.
To see more examples, look though the sub-directories of http://code.google.com/p/ourmine/source/browse/trunk/our/lib/lisp/.

# Write Deftests #

Write 50 deftests showing your understand Paul Graham's text chapters

  * 2,3,4 :
  * 5 (but not 5.6)
  * 6.1,6.2,6.3,6.4,6.5,6.9,
  * 7,
  * 10.1,10.2,10.3,10.4,10.5,10.6,10.7
  * 14.5

30 tests should relate to basic stuff (chapters 2,3,4); no more
than 10 tests per chapter; and include at least one test for each
of figures 3.6/3.7,3.12,4.2,4.5,4.6,5.2,6.1,7.1,10.2,14.2

Note that some of Graham's code is on-line at
http://lib.store.yahoo.net/lib/paulgraham/acl2.lisp

Also, there are errors in some of his text. See http://www.paulgraham.com/ancomliser.html

# Bonus Work (5 marks) #

Implement HyperPipes. Hint: modify [nb.lisp](http://ourmine.googlecode.com/svn/trunk/our/lib/lisp/learn/nb.lisp).
To demonstrate the code, emulate the _deftest_ in nb.lisp but demonstrate the code using ten of the (smaller) datasets in
http://ourmine.googlecode.com/svn/trunk/our/lib/lisp/tests/data,

# How to Submit #

For this assignment, work outside of the repository. Then, on submission day,
write all your files into the directory
_svns/ourmine/branches/YourGroupNumber/our/etc/proj/1_. Write as
many files as you like but there should exist a file "main.lisp"
that loads all the other files. Note that that you should have NO
compilation errors/warnings at load time.

# How this will be marked #

I will change to the directory _svns/ourmine/branches/YourGroupNumber/our/etc/proj/1_, fire up emacs/slime, then
  * (load "main.lisp")
  * (tests)

I will expect to see "50 tests passed".