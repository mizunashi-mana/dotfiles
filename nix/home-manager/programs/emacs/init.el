(setq evil-want-keybinding nil)

(require 'evil)
(require 'magit)
(require 'evil-collection)

(evil-mode 1)
(evil-collection-init '(magit org))
