run "rails generate rspec:install"
run "rails generate cucumber:install --capybara --rspec"
run "rails generate pickle --email"

inject_into_file "config/application.rb", :after => "g.template_engine :haml\n" do
<<-RUBY
      g.test_framework :rspec
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
RUBY
end

inject_into_file "features/support/env.rb", :after => "ENV[\"RAILS_ENV\"] ||= \"test\"\n" do
<<-RUBY
$VERBOSE = nil
RUBY
end

inject_into_file "spec/spec_helper.rb", :before => "# This file is copied to spec/ when you run 'rails generate rspec:install'" do
<<-RUBY
require 'cover_me'
RUBY
end

inject_into_file "spec/spec_helper.rb", :after => "require 'rspec/rails'\n" do
<<-RUBY
$VERBOSE = nil
require 'remarkable/active_model'
require 'fabrication'
require 'carrierwave/test/matchers'
RUBY
end

gsub_file "spec/spec_helper.rb", /# config.mock_with :mocha/, 'config.mock_with :mocha'
gsub_file "spec/spec_helper.rb", /config.mock_with :rspec/, '#config.mock_with :rspec'
gsub_file "spec/spec_helper.rb", /config.fixture_path = \"\#{::Rails.root\}\/spec\/fixtures\"/, ""

gsub_file "features/support/env.rb",/require 'cucumber\/rails\/capybara_javascript_emulation'/,'#require \'cucumber/rails/capybara_javascript_emulation\''

run "mkdir spec/fabricators"

create_file "features/step_definitions/helper_steps.rb" do
<<-'FILE'
When /^I confirm a js popup on the next step$/ do
  page.evaluate_script("window.alert = function(msg) { return true; }")
  page.evaluate_script("window.confirm = function(msg) { return true; }")
end
FILE
end

create_file "features/step_definitions/fabrication_steps.rb" do
<<-'FILE'
Given /^the following (.+) records?$/ do |fabrication, table|
  table.hashes.each do |hash|
    Fabricate(fabrication.to_sym, hash)
  end
end
FILE
end
