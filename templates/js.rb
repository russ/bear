get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js",  "public/javascripts/jquery.js"
get_remote_https_file "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://html5shiv.googlecode.com/svn/trunk/html5.js", "public/javascripts/shiv.js"
run "rm public/javascripts/application.js"

create_file "public/javascripts/core.js" do
<<-FILE
(function($){
  var QL = QL || {};

  QL = {
    init: function QL_init(){
    // some code that needs to be executed after doc ready
    QL.bindEvents();
    },
    bindEvents: function QL_liveEvents(){
      $('a[rel*=external]').live('click',function(){
        window.open(this.href);
        return false;
      });

    // more globally bound events
  },
    helpers: function QL_helpers(){
      // helper for searching through arrays
      QL.helpers.arraySearch = function(a){
        var o = {};
        for(var i=0;i<a.length;i++){
          o[a[i]]='';
        }
        return o;
      };
      //j. resigs array remove overload
      Array.prototype.remove = function(from, to) {
        var rest = this.slice((to || from) + 1 || this.length);
        this.length = from < 0 ? this.length + from : from;
        return this.push.apply(this, rest);
      };
      // duck punch Array.indexOf into IE browsers
      if(!Array.indexOf){
        Array.prototype.indexOf = function(obj){
        for(var i=0; i<this.length; i++){
          if(this[i]==obj){
            return i;
          }
        }
        return -1;
      }
    }
  }
};

  window.QL = QL;
  $(document).ready(QL.init);

})(jQuery);
FILE
end
