# Before you Start #

  * Create a directory $HOME/opt/tmp/backup
  * If you want some of the config files described below, then do the [Ourmine install](http://code.google.com/p/ourmine/) before everything else.

# Getting Started with EMACS #

It is recommended that you add the following lines to your $HOME/.emacs.

```
 (setq backup-directory-alist nil) 
  (setq backup-directory-alist ; get the backups out of the working directories 
      (cons (cons "\\.*$" (expand-file-name "~/opt/tmp/backup")) backup-directory-alist)) 
(transient-mark-mode t)          ; show incremental search results
(setq scroll-step 1)             ; don't scroll in large jumps
(setq require-final-newline   t) ; every file has at least one new line
(setq inhibit-startup-message t) ; disable start up screen
(global-font-lock-mode t 1)      ; enable syntax highlighting
(line-number-mode t)             ; show line numbers and time in status line
(setq display-time-24hr-format nil) ; show line numbers and time in status line
(display-time)

(xterm-mouse-mode t)             ; make mouse work in text windows     
```

That last line (about _xterm-mouse-mode_) is really handy. It means you can SSH into a UNIX installation and still use a mouse as you click around EMACS. Very nice.

## Getting Started with SLIME ##

S.L.I.M.E. = superior LISP interaction mode for emacs.

It is my recommendation for writing, running, and debugging LISP code (though some people prefer the CUSP SBCL plugin for ECLIPSE).

If you want to get started on slime on a CSEE Linux machine, edit your $HOME/.emacs and add these lines.

```
(setq inferior-lisp-program "/usr/bin/sbcl --noinform")
(add-to-list 'load-path "/usr/share/common-lisp/source/slime/") ;; this path is WVU CSEE specific
(setq slime-path "/usr/share/common-lisp/source/slime/")        ;; this path is WVU CSEE specific
(require 'slime)
(slime-autodoc-mode)
(slime-setup)
(add-hook 'lisp-mode-hook (lambda ()  
	(slime-mode t) 
	(local-set-key "\r" 'newline-and-indent)
	(setq lisp-indent-function 'common-lisp-indent-function)
	(setq indent-tabs-mode nil)))

(global-set-key "\C-cs" 'slime-selector)
; color themes
  (setq load-path 
      (cons "~/opt/ourmine/our/etc/color-themes/6.6.0" load-path))
  (require 'color-theme) 
  
(color-theme-initialize) 
(color-theme-hober)    ; default color theme . For others, see M-x color-theme-selector
```

Then fire up emacs and type M-x slime. After that, any .lisp file you edit will have some cool LISP bindings (see http://common-lisp.net/project/slime/doc/html/Compilation.html#Compilation).

If all the above EMACS/SLIME configuration works then you should be able to SSH into your account and generate a screen that looks like this:

![![](http://ourmine.googlecode.com/svn/trunk/share/img/screen-emacs600.png)](http://ourmine.googlecode.com/svn/trunk/share/img/screen-emacs.png)