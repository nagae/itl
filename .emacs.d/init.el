;; ============================================================
;;
;; Emacs 設定ファイル
;; 
;; ============================================================

;; MELPA
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)
;; パッケージ群をインストールする方法：
;; emacs を起動し,
;; M-x load-file RET ~/.emacs.d/package.el RET

;; viper-mode にしない
(setq viper-mode nil)

;; 基本的な入出力
(load "~/.emacs.d/init-emacs.el")
;; SKK
(load "~/.emacs.d/init-ddskk.el")
;; org-mode
(load "~/.emacs.d/init-org.el")
;; tex
(load "~/.emacs.d/init-tex.el")

;; 追加すべきパスの一覧
(exec-path-from-shell-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cdlatex auctex-latexmk auctex irony-eldoc company-irony company simplenote2 markdown-mode magit sr-speedbar wc-mode browse-kill-ring session helm dired-filter flycheck-irony flycheck persp-mode zenburn-theme ddskk exec-path-from-shell)))
 '(session-use-package t nil (session)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
