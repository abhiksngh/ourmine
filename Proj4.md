Demos: Monday, Tuesday first week of December. Note: grade for these = 0 marks but attendance is compulsory.

Presentations: class time, second week of December.

Final report (cs573 only): Monday third week of November

# CS473 #

Your mission is to report what works best. Please try to try a 5x5 cross-val of combinations of your pre-processors, clusterers, discretizers, FSSers, classifiers to see which generates most PDs and least PFs. Compare all results using the Mann-Whitney "winLossTie" script.


## To do ##

  * Run the 5x5 experiment
    * Note: you cannot do this one at the last minute since there may not be enough CPU between now and end of term to do all combos, 5x5.  Your task is the make the pragmatically best comparison, with full regard to the practical realities of such a large experiment.
  * Make the output conform to the input of the winLossTie scripts
    * To remind yourself what that is, see the Proj2 spec
  * Generate quartiles and win-loss-tie charts
  * Generate a 3' by 4' landscape poster
    * Poster should take half its space (succinctly) describing the pre-processors, clusterers, discretizers, FSSers, and classifiers.
    * Poster should also include a table describing the data used in the experiment:
      * name
      * number of discrete attributes
      * number of continuous attributes
    * class data (e.g. number of discrete classes or, for numeric classes, min, max, median, std dev.)
      * (Remember to select your data sets using the selection rules offered in Proj2).
      * How to write posters
        * For a sample poster, see http://ourmine.googlecode.com/svn/trunk/share/pdf/poster.pdf
        * You can write this using
          * Latex (use "svn export http://unbox.org/wisp/var/09/pom2/doc/ase09/poster/pom2poster/ poster" then run "make")
          * Powerpoint : layup one page in 5pt text. Won't look as good as the Latex, but some will find it easier.
          * Open Office, etc (see the Powerpoint advice)
        * Basement of library can print these; you can print non-gloss ($6) or full gloss ($12).
          * For test prints, A3 sheets are readable, and cheap to produce
      * Note: remember to commit your poster.pdf somewhere in ourmine/branches/yourgroup/../etc/proj/4
  * Each group must make one  presentation (second week of December in class time)
    * Hand out gray scale A4 copies of your poster to the class (warning: so make sure your color scheme works well in gray scale).
    * Prepare "slides" contain just large versions of all the graphics in the posters.
    * In 15 minutes, walk us through the poster, showing the graphics on the overhead when appropriate

Note: there is no "final report document": the poster will suffice.

# CS573 #

You too must generate posters and give a presentation using the same format as the cs473 people.

Note: you must also generate a "final report document".

# Errata #
S
Definition of nomograms: log(b/r) not log(b)/log(r).