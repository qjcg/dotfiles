;; See https://github.com/karthink/gptel/wiki/Tools-collection

;;; Filesystem

(gptel-make-tool
 :function (lambda (directory)
             (mapconcat #'identity
                        (directory-files directory)
                        "\n"))
 :name "list_directory"
 :description "List the contents of a given directory"
 :args (list '(:name "directory"
		     :type string
		     :description "The path to the directory to list"))
 :category "filesystem")

(gptel-make-tool
 :function (lambda (parent name)
             (condition-case nil
                 (progn
                   (make-directory (expand-file-name name parent) t)
                   (format "Directory %s created/verified in %s" name parent))
	       (error (format "Error creating directory %s in %s" name parent))))
 :name "make_directory"
 :description "Create a new directory with the given name in the specified parent directory"
 :args (list '(:name "parent"
		     :type string
		     :description "The parent directory where the new directory should be created, e.g. /tmp")
             '(:name "name"
		     :type string
		     :description "The name of the new directory to create, e.g. testdir"))
 :category "filesystem")


;;; Emacs

(gptel-make-tool
 :function (lambda (text)
             (message "%s" text)
             (format "Message sent: %s" text))
 :name "echo_message"
 :description "Send a message to the *Messages* buffer"
 :args (list '(:name "text"
		     :type string
		     :description "The text to send to the messages buffer"))
 :category "emacs")

;;; Web

(gptel-make-tool
 :function (lambda (url)
             (with-current-buffer (url-retrieve-synchronously url)
               (goto-char (point-min))
               (forward-paragraph)
               (let ((dom (libxml-parse-html-region (point) (point-max))))
                 (run-at-time 0 nil #'kill-buffer (current-buffer))
                 (with-temp-buffer
                   (shr-insert-document dom)
                   (buffer-substring-no-properties (point-min) (point-max))))))
 :name "read_url"
 :description "Fetch and read the contents of a URL"
 :args (list '(:name "url"
               :type string
               :description "The URL to read"))
 :category "web")


(provide 'jg-gptel-tools)
