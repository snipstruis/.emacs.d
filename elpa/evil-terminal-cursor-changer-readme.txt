Then add the following lines to ~/.emacs:

     (unless (display-graphic-p)
       (require 'evil-terminal-cursor-changer))


If want change cursor shape type, add below line. This is evil's setting.

     (setq evil-visual-state-cursor 'box) ; █
     (setq evil-insert-state-cursor 'bar) ; ⎸
     (setq evil-emacs-state-cursor 'hbar) ; _

Now, works on Gnome Terminal(Gnome Desktop), iTerm(Mac OS X), Konsole(KDE Desktop).
