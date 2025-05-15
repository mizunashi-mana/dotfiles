(setq evil-want-keybinding nil)

(require 'evil)
(require 'magit)
(require 'evil-collection)

(evil-mode 1)
(evil-collection-init '(magit org))

(setq auto-mode-alist (delete (rassq 'git-rebase-mode auto-mode-alist) auto-mode-alist))
