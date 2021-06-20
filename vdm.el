(defvar previous-buffer-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map [left] 'previous-buffer)
    map)
  "Keymap to repeat previous-window key sequences.  Used in `repeat-mode'.")
(put 'previous-buffer 'repeat-map 'previous-buffer-repeat-map)

(defvar next-buffer-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map [right] 'next-buffer)
    map)
  "Keymap to repeat next-window key sequences.  Used in `repeat-mode'.")
(put 'next-buffer 'repeat-map 'next-buffer-repeat-map)

(repeat-mode 1)

(use-package vterm
  :load-path  "lib/vterm")
