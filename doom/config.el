

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "雷家兴"
      user-mail-address "leij49456@gmail.com")

;; Configure mail sending for mu4e
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;

;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Fira Code" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 18)
      doom-big-font (font-spec :family "Fira Code" :size 28 :weight 'regular)
      doom-symbol-font (font-spec :family "Fira Code" :size 18)
      doom-serif-font (font-spec :family "Fira Code" :size 18))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; shell compatition
(setq shell-file-name (executable-find "zsh"))
(setq-default vterm-shell "/usr/bin/fish")
(setq-default explicit-shell-file-name "/usr/bin/fish")



;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; mu4e gmail configuration
(after! mu4e
  (setq mu4e-maildir "~/Mail"
        mu4e-get-mail-command "mbsync -a"
        mu4e-drafts-folder "/leij49456@gmail/[Gmail].Drafts"
        mu4e-refile-folder "/leij49456@gmail/[Gmail].All Mail"
        mu4e-sent-folder "/leij49456@gmail/[Gmail].Sent Mail"
        mu4e-trash-folder "/leij49456@gmail/[Gmail].Trash"

        ;; SMTP configuration (credentials in ~/.authinfo.gpg)
        smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
        smtpmail-smtp-user "leij49456@gmail.com"
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        ))

(after! elfeed
  (setq elfeed-feeds
        '(("https://www.kernel.org/feeds/all.atom.xml" linux kernel)
          ("https://lwn.net/headlines/newrss" linux kernel)
          ("https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/atom/" linux kernel git)
          ("https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/atom/" linux kernel git)
          ("https://www.phoronix.com/rss.php" linux hardware)
          ("http://www.archlinux.org/feeds/news/" linux arch)

          ("https://blog.llvm.org/index.xml" programming compiler llvm)
          ("https://this-week-in-rust.org/rss.xml" programming rust)

          ("https://arxiv.org/rss/cs.DS" cs algorithms paper)
          ("https://stackoverflow.com/feeds/tag/algorithm" programming algorithms)
          ("https://www.vcla.at/feed/" cs theory)
          ("https://feeds.feedburner.com/PetrMitrichev" competitive-programming algorithms)

          ("https://www.smashingmagazine.com/feed/" web frontend)
          ("https://hacks.mozilla.org/feed/" web browser mozilla)
          ("http://blog.patrickmeenan.com/feeds/posts/default" web performance)
          ("https://daverupert.com/atom.xml" web frontend)

          ("https://dotfyle.com/neovim/plugins/rss.xml" editor neovim)
          ("https://neandertech.netlify.app/blog/rss.xml" editor neovim)

          ("https://hnrss.org/frontpage" news tech)
          ("http://feeds.bbci.co.uk/news/rss.xml" news world)

          ("https://writings.stephenwolfram.com/feed/" math science essays)
          ("https://mathwithbaddrawings.com/feed/" math essays)
          ("https://terrytao.wordpress.com/feed/" math science))))
