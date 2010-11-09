require "net/http"
require "net/https"
require "uri"
require "rbconfig"

say "Building Application with Bear..."

def get_remote_https_file(source, destination)
  uri = URI.parse(source)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  path = File.join(destination_root, destination)
  File.open(path, "w") { |file| file.write(response.body) }
end

append_file ".gitignore" do
  ".DS_Store"
  ".bundle"
  "capybara-*.html"
  "config/database.yml"
  "coverage.data"
  "coverage/**/*"
  "log/*.log"
  "public/stylesheets/compiled/"
  "public/system/**/**/**/*"
  "public/uploads"
  "tmp/**/*"
end

git :init

run "rake db:drop"
run "rake db:create"

# Apply Gemfile
apply File.expand_path("../gemfile.rb", __FILE__)

# Apply Jammit
apply File.expand_path("../jammit.rb", __FILE__)

# Apply HAML generator
apply File.expand_path("../haml_generator.rb", __FILE__)

# Apply rails clean up
apply File.expand_path("../rails_clean.rb", __FILE__)

# Apply js
apply File.expand_path("../js.rb", __FILE__)

# Apply HTML5 Layout
apply File.expand_path("../application_layout.rb", __FILE__)

# Apply SASS 
apply File.expand_path("../sass.rb", __FILE__)

# Apply Test Suite
apply File.expand_path("../test_suite.rb", __FILE__)

# Apply Devise?
apply File.expand_path("../devise.rb", __FILE__) if ENV["BEAR_AUTH"]

# Apply admin
apply File.expand_path("../admin.rb", __FILE__) if ENV["BEAR_ADMIN"]

# Apply db create and migrations
apply File.expand_path("../db.rb", __FILE__)

# Apply db seeds
apply File.expand_path("../db_seed.rb", __FILE__)

# Make a home controller
apply File.expand_path("../home_controller.rb", __FILE__)

# Make initializers
apply File.expand_path("../initializers.rb", __FILE__)

# Clean up generated routes
apply File.expand_path("../clean_routes.rb", __FILE__)

# Remove RSpec stuff we are not gonna use right away
apply File.expand_path("../rspec_clean.rb", __FILE__)

login_msg = (ENV["BEAR_ADMIN"]) ? "Login to admin with email #{ENV["BEAR_USER_EMAIL"]} and password #{ENV["BEAR_USER_PASSWORD"]}" : ""

say <<-D




  ########################################################################

  Bear says RAWR!!!

  Next run...
  rake spec
  rake cucumber
  rails s

  #{login_msg}

  ########################################################################
D
