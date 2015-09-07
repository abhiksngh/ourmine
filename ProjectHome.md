<img src='http://ourmine.googlecode.com/svn/trunk/share/img/mining155.gif' align='right'>

<h2>What is Ourmine?</h2>

Ourmine is a data mining toolkit built to be easily learned/taught. It implements a variety of languages constructed in a modular way, providing the opportunity for easy extendability.<br>
<br>
<p><br><p><br>

<h2>Ourmine features</h2>

<ul><li>Easily obtained and can be run from any UNIX based operating system, including OSX & Linux<br>
</li><li>Without the complications of a GUI, advanced data mining concepts can be taught effectively through the use of just a few commands<br>
</li><li>Ourmine utilizes a modulated structure, allowing experiments to be easily conducted using Ourmine by adding any custom code<br>
</li><li>Along with its many data preparation and formatting functions, Ourmine allows the power of interactive bash scripting to be conducted on the fly, providing a higher level of understanding and productivity<br>
</li><li>And much more...</li></ul>

<h2>How to install Ourmine</h2>

Installing Ourmine is very quick and simple. From the command line, change to any directory and enter the following:<br>
<br>
<pre><code>$ wget -O INSTALL ourmine.googlecode.com/svn/trunk/our/INSTALL; bash INSTALL<br>
</code></pre>

This will run the install script, and will place everything in the correct directories.<br>
If working, the output should look something like this:<br>
<br>
<pre><code>Install beginning. About to zap any existing /Users/timm/opt/ourmine.<br>
Enter to continue, Control-C to abort.<br>
<br>
Downloading... On slow connections, this may take a few minutes.<br>
Downloaded.<br>
Ourmine installed to: /Users/timm/opt/ourmine.<br>
To run, enter "cd /Users/timm/opt/ourmine"' then "./ourmine".<br>
To remove, enter "rm -rf /Users/timm/opt/ourmine."<br>
Testing for correct installation... You should see the OURMINE prompt.<br>
Ourmine - Copyright 2009 by Tim Menzies, Adam Nelson, Gregory Gay<br>
OURMINE&gt; <br>
</code></pre>


<h2>How to test Ourmine</h2>

At the prompt, type <code>demo000</code> to show the <code>weather.arff</code> data set<br>
<br>
<pre><code>OURMINE&gt; demo000<br>
@relation weather<br>
<br>
@attribute outlook {sunny, overcast, rainy}<br>
@attribute temperature real<br>
@attribute humidity real<br>
@attribute windy {TRUE, FALSE}<br>
@attribute play {yes, no}<br>
<br>
@data<br>
sunny,85,85,FALSE,no<br>
sunny,80,90,TRUE,no<br>
overcast,83,86,FALSE,yes<br>
rainy,70,96,FALSE,yes<br>
rainy,68,80,FALSE,yes<br>
rainy,65,70,TRUE,no<br>
overcast,64,65,TRUE,yes<br>
sunny,72,95,FALSE,no<br>
sunny,69,70,FALSE,yes<br>
rainy,75,80,FALSE,yes<br>
sunny,75,70,TRUE,yes<br>
overcast,72,90,TRUE,yes<br>
overcast,81,75,FALSE,yes<br>
rainy,71,91,TRUE,no<br>
</code></pre>
To see a decision tree learned from this data, type:<br>
<pre><code>OURMINE&gt; j4810 $Data/discrete/weather.arff | para 1 3<br>
 <br>
outlook = sunny<br>
|   humidity &lt;= 75: yes (2.0)<br>
|   humidity &gt; 75: no (3.0)<br>
outlook = overcast: yes (4.0)<br>
outlook = rainy<br>
|   windy = TRUE: no (2.0)<br>
|   windy = FALSE: yes (3.0)<br>
</code></pre>
To exit Ourmine, type control-d.<br>
<br>
<h2>How to run Ourmine</h2>

To run Ourmine from the command line, enter:<br>
<br>
<pre><code>$ cd $HOME/opt/ourmine/our<br>
$ ./ourmine<br>
</code></pre>

<b>Note: On some systems, Ourmine will be directly installed to</b> <code>$HOME/opt/ourmine</code>

From here you will be given the Ourmine prompt.<br>
<br>
<h2>How to Uninstall Ourmine</h2>

Uninstalling Ourmine is even simpler than installing it. From the command line, enter:<br>
<br>
<pre><code>$ rm -rf $HOME/opt/ourmine<br>
</code></pre>