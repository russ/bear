run "rm Gemfile"

create_file "Gemfile", "source \"http://rubygems.org\"\n"

gem "rails", "~> 3.0.0"
gem "autotest", :group => [ :test ]
gem "autotest-rails", :group => [ :test ]
gem "bistro_car"
gem "cancan" if ENV["BEAR_ROLES"]
gem "capybara", "0.4.0", :group => [ :cucumber ]
gem "carrierwave", "0.5.0"
gem "cover_me", ">= 1.0.0.rc4", :group => [ :test ]
gem "css_sprite", "1.4.10"
gem "cucumber", :group => [ :cucumber ]
gem "cucumber-rails", :group => [ :cucumber ]
gem "database_cleaner", :group => [ :test, :cucumber ]
gem "devise", ">= 1.1.3" if ENV["BEAR_AUTH"]
gem "fabrication", :group => [ :development, :test, :cucumber ]
gem "faker", :group => [ :test ]
gem "formtastic", "1.1.0"
gem "haml", ">= 3.0.21"
gem "haml-rails"
gem "hoptoad_notifier"
gem "hpricot", :group => [ :development ]
gem "jammit"
gem "launchy", :group => [ :cucumber ]
gem "mocha", :group => [ :test ]
gem "mysql2"
gem "pickle", :group => [ :test, :cucumber ]
gem "rails3-generators", :group => :development
gem "remarkable_activemodel", ">=4.0.0.alpha4", :group => :test
gem "rspec-rails", "~> 2.0.0", :group => [ :test, :development ]
gem "ruby_parser", :group => [ :development ]
gem "shoulda", :git => "git://github.com/thoughtbot/shoulda.git", :group => [ :test ]
gem "spork", :group => [ :cucumber ]
gem "thin", :group => [ :test, :cucumber, :development ]
gem "timecop", :group => [ :test, :cucumber ]
gem "will_paginate", "~> 3.0.pre2"

run "bundle install"
