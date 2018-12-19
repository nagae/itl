;; ========================================
;; 
;; ddskk 用の設定
;; 
;; ========================================
;; システムにコントロールキーを渡さない
(setq mac-pass-control-to-system nil)
;; C-j の機能を別のキーに割り当て
(global-set-key (kbd "C-m") 'newline-and-indent)

;; C-\ でも SKK に切り替えられるように設定
(setq default-input-method "japanese-skk")
;; 送り仮名が厳密に正しい候補を優先して表示
(setq skk-henkan-strict-okuri-precedence t)
;;漢字登録時、送り仮名が厳密に正しいかをチェック
(setq skk-check-okurigana-on-touroku t)

;; 辞書ファイルは Dropbox 上に置く
(setq skk-jisyo "~/.emacs.d/.skk-jisyo")
(setq skk-backup-jisyo "~/.emacs.d/.skk-jisyo.backup")
(setq skk-record-file "~/.emacs.d/.skk-record")

;; AquaSKKとの連携
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)

;;モードで RET を入力したときに確定のみ行い、改行はしない
(setq skk-egg-like-newline t)

;;モードで BS を押した時に一つ前の候補を表示
(setq skk-delete-implies-kakutei nil)

;; "「"を入力したら"」"も自動で挿入する
(setq skk-auto-insert-paren t)

;; 句読点
(setq skk-kuten-touten-alist '(
	(jp . ("．" . "，")) 
	(en . ("." . ","))
;	(ya . ("。" . ", "))
))
(setq skk-toggle-kutouten nil)

;; インクリメント検索
(add-hook 'isearch-mode-hook
          #'(lambda ()
              (when (and (boundp 'skk-mode)
                         skk-mode
                         skk-isearch-mode-enable)
                (skk-isearch-mode-setup))))
(add-hook 'isearch-mode-end-hook
          #'(lambda ()
              (when (and (featurep 'skk-isearch)
                         skk-isearch-mode-enable)
                (skk-isearch-mode-cleanup))))

;; 日本語で $ を入力した時に対応する $ と合わせて表示
(add-hook 'skk-mode-hook
	  '(lambda ()
	     (define-key skk-j-mode-map "$" 'self-insert-command)
	     (define-key skk-j-mode-map "\\" 'self-insert-command)
	     )
	  )
