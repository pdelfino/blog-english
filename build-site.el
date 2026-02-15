;; build-site.el --- Org-publish configuration for pedrodelfino.com -*- lexical-binding: t; -*-

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install htmlize for syntax highlighting in code blocks
(package-install 'htmlize)

(require 'ox-publish)

;; Customize HTML output
(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-doctype "html5"
      org-html-html5-fancy t)

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "blog-content"
             :base-directory "./"
             :base-extension "org"
             :publishing-directory "./public/"
             :publishing-function 'org-html-publish-to-html
             :recursive t
             :exclude "drafts\\|\\.packages\\|public"
             :with-author nil
             :with-creator nil
             :with-toc nil
             :section-numbers nil
             :time-stamp-file nil

             :html-head "<link rel=\"stylesheet\" href=\"/style.css\" />
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<link rel=\"icon\" href=\"/img/favicon.svg\" type=\"image/svg+xml\" />"

             :html-preamble "<a href=\"/\">~/pedrodelfino.com</a>
<a href=\"/posts\">posts</a>
<a href=\"https://github.com/pdelfino\" target=\"_blank\">github</a>"

             :html-postamble "<p>Built with Emacs Org-mode</p>")

       (list "blog-static"
             :base-directory "./"
             :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|svg\\|ico\\|woff\\|woff2\\|ttf\\|eot"
             :publishing-directory "./public/"
             :recursive t
             :exclude "drafts\\|\\.packages\\|public"
             :publishing-function 'org-publish-attachment)

       (list "blog" :components '("blog-content" "blog-static"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
