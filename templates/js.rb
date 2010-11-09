get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js",  "public/javascripts/jquery.js"
get_remote_https_file "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://html5shiv.googlecode.com/svn/trunk/html5.js", "public/javascripts/shiv.js"
run "rm public/javascripts/application.js"
