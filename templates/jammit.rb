create_file "config/assets.yml" do
<<-FILE
embed_assets: on

javascripts:
  common:
    - public/javascripts/jquery.js
    - public/javascripts/rails.js
    - public/javascripts/application.js

stylesheets:
  main:
    - public/stylesheets/reset.css
    - public/stylesheets/grid.css
    - public/stylesheets/common.css
    - public/stylesheets/application.css
  admin:
    - public/stylesheets/admin.css
FILE
end
