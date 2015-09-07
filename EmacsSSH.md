# Background #

I'm often asked how to a LISP IDE for home use. There are two answers, one quite long and one quite short:
  1. The long answer: download and install x-windows, EMACS, SLIME, sbcl, and 100 add-ons to the above.
  1. The short answer SSH in to any decent UNIX installation and use the tools already installed there.

Note that option 1 takes days and option 2 is instant.

# Using SSH #

SSH-based EMACS can be quite powerful. For example, here is the EMACS screen I am working on right now, via SSH:

![![](http://ourmine.googlecode.com/svn/trunk/share/img/screen-emacs600.png)](http://ourmine.googlecode.com/svn/trunk/share/img/screen-emacs.png)

(If you want a bigger view, [click here](http://ourmine.googlecode.com/svn/trunk/share/img/screen-emacs.png).)

Note that:
  * Top-left I am running a UNIX shell (called using _M-x eshell_) so I can create directories, hunt for source code using _grep -R_, etc etc.
  * Bottom-left I am running a LISP shell so I can interactively run my code.
  * And on the right I can edit LISP source code.

And, this being EMACS, I can divide the screen up any way I want to edit multiple files:
  * Cntl-X-3 splits the current buffer vertically.
  * Cntl-X-2 splits the current buffer horizontally.
  * Cntl-X-0 kills the current buffer

Yes, you have to use ascii-based tools but get over it. Command keys are your friends. I've written and debugged very large and complex hunks of code this way- it really works quite well.

# Details #

If you want to avoid must frustration, use a decent terminal emulator. The default Terminal,Cmd for OS/X,Windows are not recommended.
  * For Windows, use [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).
  * For OS/X, [iTerm](http://iterm.sourceforge.net/download.shtml) is pretty good.
  * For LINUX, dear old XTERM is pretty darn good.

No matter which emulator you use, you still want to be able to mouse around the screen. Just add this to your `$HOME/.emacs` file:
```
(xterm-mouse-mode t)
```

The default color scheme for EMACS can really suck over SSH. So download and install the [EMACS color themes](http://code.google.com/p/ourmine/wiki/EMACScolorThemes).

And speaking of color, sometimes SLIME likes highlighting changed text. Which is all well and good but in SSH mode, this often means the underlying text is obscured. To disable this annyong behavior, add the  following code  to _$HOME/.emacs_. Then,  _M-x nope_  disables that highlighting.

```
(defun nope ()
   (interactive)
   (slime-highlight-edits-mode)
)
```

Alternatively, you can use a nil color for the highlight by editing your  _$HOME/.emacs_ file as follows:
```
'(slime-highlight-edits-face ((((class color) (background dark))
(:background "dimgray")))))
```
(This  removes the highlight since (:background "dimgray") is
nil. You should also be able to change the color there but I haven't
attempted that.)

There is a little dotconfig file editing required to get the LISP working- see
[Emacs LISP config](http://code.google.com/p/ourmine/wiki/EmacsLISPconfig).

# If you still want a local installation.... #

.... look for the packages SLIME, SBCL, Emacs in

  * CYGWIN for Windows
  * Darwin Ports or Fink for OS/X

And may the force be with you.


# Summary #

Before you spend days downloading and configuring your local machine, see if you can jump onto to a pre-configured one. It could save you a lot of time!