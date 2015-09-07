

| <img src='http://www.ksu.edu.sa/sites/Colleges/AppliedMedicalSciences/PublishingImages/under-construction.jpg' align='right' width='200'><table><thead><th> <b>NOTE: This draft is not yet released.</b></th></thead><tbody></tbody></table>


<h1>Abstract</h1>

We distinguish "theories" (which are "true" in some global sense) from<br>
"models" (which may not be "true", be are useful for some local task).<br>
Software engineering research rarely produces externally valid theories.<br>
There are so very few examples of generalizable theories,<br>
despite there being so many examples of research groups trying to find them.<br>
To illustrate this point, we offer examples of these failures-to-generalize from the fields of:<br>
<ul><li>design of programming languages<br>
</li><li>software metrics definitions<br>
</li><li>and other SE domains, as well.</li></ul>

Even if SE can't generate theories, we can still find useful local models.  Data mining<br>
is a rich area of research that has generated long lists of methods that are simple to code and, usually, generate<br>
effective models.  This talk will offer:<br>
<ul><li>Examples of those local conclusions (as applied to software defect prediction), as well as<br>
</li><li>Catalogs of data mining methods that are simplest and fastest to apply, while often generating useful insights.</li></ul>

Advocating the generation of local models, that usually do not generalize to theories, runs counter to the positivist<br>
tradition of scientific development.  A detailed look of the mechanics of data mining will highlight the difficulty<br>
in producing generalizable theories.<br>
<br>
I am not the first to argue that this tradition is sterile- but I<br>
do not think that the SE culture fully acknowledges the failure of that approach.  If we did, then we would<br>
augment current methods with:<br>
<ul><li>studies on <i>stochastic stability</i>;<br>
</li><li><i>noise reduction operators</i>, to remove spurious signals;<br>
</li><li><i>anomaly detectors</i>. for determining when a model has gone "out of scope";<br>
</li><li>automatic model <i>repair tools</i>, to learn new models when the old ones are no longer relevant</li></ul>

The lesson on data mining is that while nothing is "true", many more things are "false".<br>
While multiple models can be generted from the available data, many models are unsupported by any data.<br>
Now the good news is that the space of possible models smaller than you might thing. XXX<br>
Rather, it is a claim that we still critically<br>
it turns out that there are general theories about finding locally useful models.<br>
To illustrate this point, this talk will:<br>
<ul><li>Discusses one such method from case-based reasoning, as applied to software effort estimation.</li></ul>

My conclusion will be that:<br>
<ul><li>While we should strive to build general theories of software engineering,<br>
</li><li>We should not be surprised or discouraged if we fail to do so.</li></ul>

More generally, rather than try to "clean up" empirical software engineering with more rigorous methods, we should<br>
instead explore methods for the faster generation and assessment of local models.<br>
<br>
<i>About the speaker</i> Dr. Tim Menzies (tim@menzies.us) has been working on advanced modeling and AI since 1986. He received his PhD from the University of New South Wales, Sydney, Australia and is the author of over 164 refereed papers.<br>
A former research chair for NASA, Dr. Menzies is now a associate professor at the West Virginia University's Lane Department of Computer Science and Electrical Engineering.<br>
For more information, visit his web page at <a href='http://menzies.us'>http://menzies.us</a>.<br>
<br>
<h1>Introduction</h1>

Remember of the old joke?<br>
<br>
<img src='http://ourmine.googlecode.com/svn/trunk/share/img/thenAMiracle.jpg' />

If you read the empirical SE literature, you can find a similar "missing link" in<br>
<a href='#Easterbrook07.md'>recent descriptions of how to conduct empirical SE studies</a>:<br>
<ul><li>3 pages: research questions<br>
</li><li>2 pages: different forms of "empirical truth"<br>
</li><li>1 page: role of theory building<br>
</li><li>9 pages: selecting methods<br>
</li><li>1 page: data collection techniques<br>
</li><li>0 pages: data analysis (and then a miracle happens)<br>
</li><li>2 pages: empirical validity<br>
</li><li>1 page: conclusions</li></ul>

Speaking as a data mining researcher, I'm here to say that selecting <i>data analysis</i> methods deserves more than 0 pages:<br>
<br>
<ul><li>There are <a href='http://promisedata.org/2010/'>entire conferences</a> devoted to just "data analysis";<br>
</li><li>A detailed study of "data analysis" reveals:<br>
<ul><li>Data analysis may never produce generalizable SE theories<br>
<ul><li>Shock! Horror!<br>
</li><li>(And if such generalizations exist, shouldn't we have found them by now?)<br>
</li></ul></li></ul></li><li>Methods of "data analysis" are close to methods of "control"<br>
<ul><li>So "empirical methods" becomes "how to control a project".</li></ul></li></ul>

<hr />
<img src='http://ourmine.googlecode.com/svn/trunk/share/img/death2powerpoint.png' align='right'>
<h1>Why Aren't we Looking at Powerpoint?</h1>


Like many before me, (<a href='#Tufte05.md'>#Tufte05</a>, <a href='#Tufte06.md'>#Tufte06</a>),<br>
I distrust Powerpoint:<br>
<ul><li>Powerpoint is a tool for a one-way broadcast of completed ideas<br>
</li><li>Knowledge diamonds;<br>
</li><li>Dressed to impress.</li></ul>

This format is faster to write.<br>
<ul><li>Faster to hyperlink to references<br>
</li><li>You can write comments on this material, below.</li></ul>

Anyway,  this talk comes from a different intellectual tradition:<br>
<ul><li>Knowledge relativism<br>
<ul><li>Using the hammer changes the hammer.</li></ul></li></ul>

Seems inappropriate to dress it up in Powerpoint<br>
<br>
<br><br>
<br><br>
<br><br>
<br><br>
<br><br>
<br><br>
<br><br>
<hr />
<h1>The Current (Poor) State of Empirical AI</h1>

<pre><code>From: Tim Menzies<br>
To:   David Budgen<br>
Date: Mon, Sep 7, 2009 at 10:19 AM<br>
<br>
This question may sound somewhat abrupt (even, rude) to you, so I<br>
preface it with:<br>
<br>
- Your CSEET talk completely turned my thinking around. I think about<br>
  it more than anything else i've seen in the last decade.<br>
<br>
- I am a strong advocate of ebse and, where possible, I support its<br>
  goals (e.g. I made structured abstract mandatory for PROMISE 2010)<br>
<br>
Anyway, here's my question (about empirical SE):<br>
<br>
- Where are the results?<br>
<br>
Thanks!<br>
t<br>
</code></pre>
Some prominent examples where initial attempts to clarify empirical SE did not produce results.<br>
<br>
<h2>Example1:   Fenton's famous book on <a href='#Fenton98.md'>Software Metrics</a></h2>

<ul><li>Fenton, 2007: "... much of the current software metrics research is inherently irrelevant to the<br>
<blockquote>industrial mix ..... any software metrics program that depends on some extensive metrics collection is doomed to failure ...".<br>
</blockquote></li><li>Now, he builds Bayesian models based on expert intutions.</li></ul>

<h2>Example2: how best to assess software written at another site?</h2>
<ul><li>This is the <i>Independent V&V</i> task<br>
</li><li>Over a hundred tasks proposed by different authors for IV&V.<br>
</li><li>At NASA, from 2005 to 2007, the list was as follows.<br>
</li><li>In 2007, I found <a href='#Menzies07a.md'>very few attempts</a> to assess the relative cost-benefits of these tasks.</li></ul>

<pre><code>phase           wbs                                     factor   RANK  <br>
--------------  ---    ---------------------------------------   ---- <br>
concept         2.1                             Reuse Analysis   11<br>
                2.2           Software Architecture Assessment    9<br>
                2.3                 System Requirements Review   10<br>
                2.4                Concept Document Evaluation    8<br>
                2.5   SW/User Requirements Allocation Analysis    6<br>
                2.6                      Traceability Analysis    7<br>
--------------  ---    ---------------------------------------    <br>
requirements    3.1      Traceability Analysis -  Requirements    4<br>
                3.2           Software Requirements Evaluation    5<br>
                3.3          Interface Analysis - Requirements    3<br>
                3.4                  System Test Plan Analysis    2<br>
                3.5              Acceptance Test Plan Analysis    1   &lt;====<br>
                3.6                 Timing and Sizing Analysis        ?<br>
--------------  ---    ---------------------------------------    <br>
design          4.1             Traceability Analysis - Design   16 <br>
                4.2                 Software Design Evaluation   15 <br>
                4.3                Interface Analysis - Design   14 <br>
                4.4                 Software FQT Plan Analysis   17 <br>
                4.5    Software Integration Test Plan Analysis   12 <br>
                4.6                          Database Analysis   13<br>
                4.7               Component Test Plan Analysis        ?<br>
--------------  ---    ---------------------------------------    <br>
implementation  5.1               Traceability Analysis - Code   22 <br>
                5.2   Source Code and Documentation Evaluation   23 <br>
                5.3                  Interface Analysis - Code   21 <br>
                5.4                  System Test Case Analysis   19 <br>
                5.5                 Software FQT Case Analysis   20 <br>
                5.6          SW Integration Test Case Analysis        ?<br>
                5.7              Acceptance Test Case Analysis        ?<br>
                5.8     SW Integration Test Procedure Analysis        ?<br>
                5.9       SW Integration Test Results Analysis        ?<br>
                5.10              Component Test Case Analysis        ?<br>
                5.11            System Test Procedure Analysis   18 <br>
                5.12           Software FQT Procedure Analysis        ?<br>
--------------  ----   ---------------------------------------    <br>
test            6.1               Traceability Analysis - Test   27 <br>
                6.2                   Regression Test Analysis        ?<br>
                6.3                        Simulation Analysis   25 <br>
                6.4               System Test Results Analysis   24 <br>
                6.5              Software FQT Results Analysis   26 <br>
--------------  ---    ---------------------------------------    <br>
other           7.1             Operating Procedure Evaluation        ?<br>
                7.2                         Anomaly Evaluation        ?<br>
                7.3                       Migration Assessment        ?<br>
                7.4                      Retirement Assessment        ?<br>
</code></pre>

(BTW, the numbers on the RHS show the result of a six month study with some NASA civil servants who performed<br>
several pieces of magic with their databases. Rankings are based on how many high severity issues were found<br>
using the least cost. For more details, see <a href='#Menzies07a.md'>here</a>).<br>
<br>
<h2>Example3: What is the Best Computer Programming Language?</h2>

No termination on that debate; increased diversity in that conclusion, as time goes by:<br>
<br>
<img src='http://unbox.org/wisp/var/timm/09/310/share/img/tiobe-index.png' />













see, i recently had to review an IEEE standard on IV&V. 83 supposedly<br>
"best practices" and i could only find empirical evidence  comment on<br>
just a handful of those practices.<br>
<br>
Effort estimation research has made<br>
some<br>
excellent attempts at recording those best practices<br>
[#Jørgensen04 Jørgensen04]  <a href='#.md'>#</a>Kitchenham07 Kitchenham07]:<br>
but even those do not offer clear guidelines:<br>
<ul><li>[#Jørgensen04 Jørgensen04] reports that expert estimates are better/worse/same as model estimates in5/5/5 reported cases studies<br>
</li><li><a href='#.md'>#</a>Kitchenham07 Kitchenham07]: reports that the jury is out on the value of using local vs imported data for building estimates.</li></ul>

Is SE is so diverse, so fundamentally weird, that:<br>
<b>there are no "general principles".</b>

What i suspect is that the are not general SE<br>
principles:<br>
<ul><li>but there might be general methods for finding the local</li></ul>



Mon, Sep 7, 2009 at 10:19 AM<br>
<h1>References</h1>

<h2>Easterbrook07</h2>

Easterbrook, S. M., Singer, J., Storey, M, and Damian, D. Selecting Empirical Methods for Software Engineering Research. Appears in F. Shull and J. Singer (eds) "Guide to Advanced Empirical Software Engineering", Springer, 2007.<br>
<a href='http://www.cs.toronto.edu/~sme/papers/2007/SelectingEmpiricalMethods.pdf'>http://www.cs.toronto.edu/~sme/papers/2007/SelectingEmpiricalMethods.pdf</a>

<h2>Fenton98</h2>

Software Metrics: A Rigorous Approach<br>
by Norman E. Fenton, Shari Lawrence Pfleeger.<br>
PWS, 1998 (second edition).<br>
<br>
<br>
<h2>Jørgensen04</h2>

“A Review of Studies on Expert Estimation of Software<br>
M. Jørgensen, “A Review of Studies on Expert Estimation of Software<br>
Development Effort,” J. Systems and Software, vol. 70, nos. 1–2, 2004,<br>
pp.  37–60;<br>
<br>
<h2>Kitchenham07</h2>

B.A. Kitchenham, E. Mendes, and G.H. Travassos Cross versus<br>
Within-Company Cost Estimation Studies: A Systematic Review,  IEEE<br>
Transactions on Software Engineering archive Volume 33 , <a href='https://code.google.com/p/ourmine/issues/detail?id=5'>Issue 5</a>
May 2007, Pages 316-329<br>
<br>
<h2>Menzies07a</h2>
"Learning Better IV&V Practices" by T. Menzies and M. Benson and K. Costello and C. Moats and M. Northey and J. Richarson. Innovations in Systems and Software Engineering March 2008 . Available from <a href='http://menzies.us/pdf/07ivv.pdf'>http://menzies.us/pdf/07ivv.pdf</a>.<br>
<br>
<h2>Tufte05</h2>

Tufte, E. Powerpoint Does Rocket Science--and Better Techniques for Technical Reports.  September 6, 2005.<br>
<a href='http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001yB&topic_id=1&topic=Ask+E.T'>http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001yB&amp;topic_id=1&amp;topic=Ask+E.T</a>.<br>
<br>
<h2>Tufte06</h2>
Tufte, E. The Cognitive Style of Powerpoint: Pitching Out Corrupts Within, 2006.<br>
<a href='http://www.edwardtufte.com/tufte/books_pp'>http://www.edwardtufte.com/tufte/books_pp</a>