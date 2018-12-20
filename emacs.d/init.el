;; ============================================================
;;
;; Emacs 設定ファイル
;; 
;; ============================================================

;; MELPA
(require 'package)
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
