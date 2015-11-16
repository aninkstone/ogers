(require 'ox)
(require 'ob)
(require 'ob-table)
(require 'org)

(setq org-site-path "f:/Code/ogers/")

(setq org-navi-bar "
<nav class=\"navbar navbar-default\">
  <div class=\"container-fluid\">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class=\"navbar-header\">
      <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">
        <span class=\"sr-only\">Toggle navigation</span>
        <span class=\"icon-bar\"></span>
        <span class=\"icon-bar\"></span>
        <span class=\"icon-bar\"></span>
      </button>
      <a class=\"navbar-brand\" href=\"#\">Brand</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">
      <ul class=\"nav navbar-nav\">
        <li class=\"active\"><a href=\"#\">Link <span class=\"sr-only\">(current)</span></a></li>
        <li><a href=\"#\">Link</a></li>
        <li class=\"dropdown\">
          <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>
          <ul class=\"dropdown-menu\">
            <li><a href=\"#\">Action</a></li>
            <li><a href=\"#\">Another action</a></li>
            <li><a href=\"#\">Something else here</a></li>
            <li role=\"separator\" class=\"divider\"></li>
            <li><a href=\"#\">Separated link</a></li>
            <li role=\"separator\" class=\"divider\"></li>
            <li><a href=\"#\">One more separated link</a></li>
          </ul>
        </li>
      </ul>
      <form class=\"navbar-form navbar-left\" role=\"search\">
        <div class=\"form-group\">
          <input type=\"text\" class=\"form-control\" placeholder=\"Search\">
        </div>
        <button type=\"submit\" class=\"btn btn-default\">Submit</button>
      </form>
      <ul class=\"nav navbar-nav navbar-right\">
        <li><a href=\"#\">Link</a></li>
        <li class=\"dropdown\">
          <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>
          <ul class=\"dropdown-menu\">
            <li><a href=\"#\">Action</a></li>
            <li><a href=\"#\">Another action</a></li>
            <li><a href=\"#\">Something else here</a></li>
            <li role=\"separator\" class=\"divider\"></li>
            <li><a href=\"#\">Separated link</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
")

(setq org-publish-project-alist
      '(
        ("org-htmls"                                                  ;Used to export .org file
         :base-directory "f:/Code/ogers/"                  ;directory holds .org files 
         :base-extension "org"                                        ;process .org file only    
         :publishing-directory "f:/Code/ogers/publish-html/"            ;export destination
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-preamble ,(with-temp-buffer (insert-file-contents "~/.emacs.d/org-templates/html-preamble.html") (buffer-string))
         :html-postamble ""          ; your personal postamble
         )
        ("org-static"                ;Used to publish static files
         :base-directory "f:/Code/ogers/publish-html/static"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "f:/Code/ogers/publish-html/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("org" :components ("org-htmls" "org-static")) ;combine "org-htmls" and "org-static" into one function call
        ))

(defun org-html-template (contents info)
  "Return complete document string after HTML conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (concat
   (when (and (not (org-html-html5-p info)) (org-html-xhtml-p info))
     (let ((decl (or (and (stringp org-html-xml-declaration)
			      org-html-xml-declaration)
			 (cdr (assoc (plist-get info :html-extension)
				     org-html-xml-declaration))
			 (cdr (assoc "html" org-html-xml-declaration))

			 "")))
       (when (not (or (eq nil decl) (string= "" decl)))
	 (format "%s\n"
		 (format decl
		  (or (and org-html-coding-system
			   (fboundp 'coding-system-get)
			   (coding-system-get org-html-coding-system 'mime-charset))
		      "iso-8859-1"))))))
   (org-html-doctype info)
   "\n"
   (concat "<html"
	   (when (org-html-xhtml-p info)
	     (format
	      " xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"%s\" xml:lang=\"%s\""
	      (plist-get info :language) (plist-get info :language)))
	   ">\n")
   "<head>\n"
   (org-html--build-meta-info info)
   (org-html--build-head info)
   (org-html--build-mathjax-config info)
   "</head>\n"
   "<body>\n"
   "<div class='container'>\n"
   (let ((link-up (org-trim (plist-get info :html-link-up)))
	 (link-home (org-trim (plist-get info :html-link-home))))
     (unless (and (string= link-up "") (string= link-home ""))
       (format org-html-home/up-format
	       (or link-up link-home)
	       (or link-home link-up))))
   ;; Preamble.
   (org-html--build-pre/postamble 'preamble info)
   ;; Document contents.
   (format "<%s id=\"%s\">\n"
	   (nth 1 (assq 'content org-html-divs))
	   (nth 2 (assq 'content org-html-divs)))
   ;; Document title.
   (let ((title (plist-get info :title)))
     (format "<h1 class=\"title\">%s</h1>\n" (org-export-data (or title "") info)))
   contents
   (format "</%s>\n"
	   (nth 1 (assq 'content org-html-divs)))
   ;; Postamble.
   (org-html--build-pre/postamble 'postamble info)
   ;; Closing document.
   "</div></body>\n</html>"))
