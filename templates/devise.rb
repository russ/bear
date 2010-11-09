say "Building authentication"
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

run 'rails generate devise:install'
run 'rails generate devise:views'

gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '### ActionMailer Config'

gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
<<-RUBY
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
RUBY
end

inject_into_file 'config/environments/test.rb', :after => "config.action_controller.allow_forgery_protection    = false\n" do
<<-RUBY
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
RUBY
end

gsub_file 'config/environments/production.rb', /config.i18n.fallbacks = true/ do
<<-RUBY
  config.i18n.fallbacks = true
  config.action_mailer.default_url_options = { :host => 'yourhost.com' }
  ### ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
RUBY
end

run 'rails generate devise User'
run 'rm app/models/user.rb'

create_file 'app/models/user.rb' do
<<-RUBY
class User < ActiveRecord::Base
  devise :database_authenticatable, :token_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false, :scope => :deleted_at

  default_scope :conditions => { :deleted_at => nil }

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  def destroy
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def self.find_with_destroyed(*args)
    self.with_exclusive_scope { find(*args) }
  end

  def self.find_only_destroyed
    self.with_exclusive_scope(:find => { :conditions => "deleted_at IS NOT NULL" }) do
      all
    end
  end
end
RUBY
end

generate(:migration, "AddNameToUsers name:string")
generate(:migration, "AddDeletedAtToUsers deleted_at:datetime")

inject_into_file 'app/views/layouts/application.html.haml', :after => "%li= link_to(\"Home\", root_path)\n" do
<<-'FILE'
            - if user_signed_in?
              %li
                = link_to('Logout', destroy_user_session_path)
            - else
              %li
                = link_to('Login', new_user_session_path)
            %li
              User:
              - if current_user
                = current_user.name
              - else
                (not logged in)
FILE
end

devise_migration = Dir['db/migrate/*_devise_create_users.rb'].first

gsub_file devise_migration, /# t.confirmable/, 't.confirmable'
gsub_file devise_migration, /# t.token_authenticatable/, 't.token_authenticatable'
gsub_file devise_migration, /# add_index :users, :confirmation_token,   :unique => true/, 'add_index :users, :confirmation_token,   :unique => true'

append_file 'db/seeds.rb' do
<<-FILE

# Setup initial user so we can get in
user = User.create!(
  :name => '#{ENV['BEAR_USER_NAME']}',
  :email => '#{ENV['BEAR_USER_EMAIL']}',
  :password => '#{ENV['BEAR_USER_PASSWORD']}',
  :password_confirmation => '#{ENV['BEAR_USER_PASSWORD']}')
user.confirmed_at = user.confirmation_sent_at
user.save!
FILE
end

# make cukes and websteps for devise
apply File.expand_path("../devise/cucumber.rb", __FILE__)
