(IMPORTANT NOTE: **DO NOT** following the OURMINE install instructions from http://code.google.com/p/ourmine/. Those instructions are for those that want read-only access to Ourmine. You, on the other hand, want read-write access. So you should follow the notes shown below.)

# Preliminaries #
  * Get a gmail account.
  * Join the class google group : http://groups.google.com/group/csx73
  * Join the class repository by asking an administrator of that group to add you:
    * Tim Menzies
    * Adam Nelson
    * Aaron Riesbeck
    * Zack Murray

# Downloads #
  * Edit $HOME/.bashrc and add the line
    * export SVN\_EDITOR="`which nano` -m"
  * Make room. Clean your CSEE account. The following download will consume up to 135M.
  * Find your ICCLE password (look for "googlecode.com password") in http://code.google.com/p/ourmine/source/checkout
  * Run these commands:

```
mkdir $HOME/svns
cd svns
svn checkout https://ourmine.googlecode.com/svn ourmine --username your.gmail.user,name
```

Notes:

  * Last year, this was a very slow process due to file server problems- which should be fixed.
  * Once you've got a full check out, you'll never want to do that again. Only update svns/ourmine/wiki and svns/ourmine/branches/YourGroupNumber.

# Uploads #

  * Get a picture of yourself (less than 100KB) and add it to svns/ourmine/trunk/share/img
  * Add that picture to the repository
    * svn add svns/ourmine/trunk/share/img/MyPic.jpg
  * Commit those changes
    * svn commit -m "my picture added"

# Create Your Group #
<ul>
<li> Find some like-minded folks, form a group of three.<br>
</li><li> Get your group number (from me).<br>
</li><li> Create a branch for your work:<br>
<blockquote><ul>
<blockquote><li>cd svns/ourmine; svn cp trunk/our branches/Number; svn commit -m "branch Number created"</li>
</blockquote></ul>
</li><li> Create your own personnel page:  svns/ourmine/wiki/YourName. Note that your picture is accessible at <img src='http://ourmine.googlecode.com/svn/trunk/share/img/MyPic.jpg' />. For example, the source of my <a href='Timm.md'>Timm</a> page is:<br>
<pre><code>#summary About Tim Menzies<br>
<br>
&lt;img width=300 src="http://ourmine.googlecode.com/svn/trunk/share/img/TimM.jpg"&gt;<br>
<br>
 * Assoc prof, CSEE.<br>
 * I belong to GroupZero.<br>
 * For more information, see my [http://menzies.us home page]<br>
</code></pre>
<p>Note that I do not list my email and neither should you (death to spammers). </p>
</li><li>
With your group, add your group  page svns/ourmine/wiki/GroupNumber. For example, I am in GroupZero so I wrote this page:<br>
<pre><code>#summary This is the admin group.<br>
<br>
&lt;img width=300 src="http://ourmine.googlecode.com/svn/trunk/share/img/captain_zero.jpg"&gt;<br>
<br>
= Members =<br>
<br>
 * [Timm Tim Menzies]<br>
</code></pre>
</li>
</ul>
Note that the wiki pages are NOT in your branch but can be found in svns/ourmine/wiki. To edit pages, you can either:</blockquote>

  * create and edit them on-line (at http://code.google.com/p/ourmine/w/list)
  * or edit them on your local machine (at svns/ourmine/wiki/SomeNewPage) then commit the changes:
```
cd $HOME/svns/ourmine/wiki
Edit SomeNewPage.wiki
svn add SomeNewPage.wiki
svn commit -m "some new page"
```
Most of your assignments will be submitted via the wiki (this simplifies word processing).
If you want word-processing tips for the wiki, see
http://code.google.com/p/support/wiki/WikiSyntax.

# LISPing #

  * Follow the instructions in DotConfig to adjust your LISP environment with two exceptions:
    * Do not run the install instructions at http://code.google.com/p/ourmine/ (see note at top of page).
    * Near the bottom, where it mentions the path to color-themes, replace that path with _$HOME/svns/ourmine/branches/YourGrouNumber/our/etc/color-themes/6.6.0_

If all that works, then the following should work:

```
cd $HOME/svns/ourmine/branches/YourGroupNumber/lib/lisp
emacs
M-x slime
(load "miner")
(tests)
```
This should produce a screen that looks (somewhat) like this:

<img src='http://ourmine.googlecode.com/svn/trunk/share/img/lispworking.png'>

Note the last lines: 18 PASSES tests. The system works. Hooray!