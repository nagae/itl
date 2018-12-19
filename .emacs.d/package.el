;; Package 
(require 'package)
;; MELPA
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)
;; パッケージ情報の更新
(package-refresh-contents)

;; インストールするパッケージ一覧
(defvar my/favorite-packages
  '(
    ;;;; シェルからのパスを引き継ぐ
    exec-path-from-shell
    
    ;;;; 日本語入力 ddskk
    ddskk
    
    ;;;; window関連
    zenburn-theme persp-mode 

    ;;;; 便利なパッケージ群
    flycheck flycheck-irony dired-filter helm session browse-kill-ring wc-mode sr-speedbar magit markdown-mode simplenote2
    company company-irony irony-eldoc

    ;;;; evil
    evil
    
    ;;;; org-mode
    org htmlize

    ;;;; tex関連
    auctex auctex-latexmk cdlatex
    )
  )
;; my/favorite-packages
(dolist (package my/favorite-packages)
  (unless (package-installed-p package)
    (package-install package)))
