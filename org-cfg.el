(require 'ox)
(require 'ob)
(require 'ob-table)
(require 'org)

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(setq org-log-done 'time)
(setq org-log-done 'note)

;;(org-indent-mode 1)

(setq org-site-path "~/Development/ogers/")
;;(setq org-default-notes-file (concat org-directory "/note.org"))

(setq org-publish-project-alist
      '(
        ("org-htmls"                                             ;Used to export .org file
         :base-directory "~/Development/ogers/"                  ;directory holds .org files 
         :base-extension "org"                                   ;process .org file only    
         :publishing-directory "~/Development/ogers/"            ;export destination
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 3          ; Just the default for this project.
         :auto-preamble nil          ; Disable auto preamble 
         :html-preamble "
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
</nav>"
         :auto-sitemap nil             ; Generate sitemap.org automagically...
         ;;:sitemap-filename "sitemap.org"    ; call it sitemap.org (it's the default)...
         ;;:sitemap-title "Sitemap"           ; with title 'Sitemap'.
         :export-creator-info nil    ; Disable the inclusion of "Created by Org" in the postamble.
         :export-author-info nil     ; Disable the inclusion of "Author: Your Name" in the postamble.
         :auto-postamble nil         ; Disable auto postamble 
         ;;:table-of-contents nil      ; Set this to "t" if you want a table of contents, set to "nil" disables TOC.
         :section-numbers t          ; Set this to "t" if you want headings to have numbers.
         :html-postamble ""          ; your personal postamble
         :style-include-default nil  ; Disable the default css style
         )
        ("org-static"                ;Used to publish static files
         :base-directory "~/Development/ogers/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Development/ogers/"            ;export destination
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("org" :components ("org-htmls" "org-static")) ;combine "org-htmls" and "org-static" into one function call
        ))
