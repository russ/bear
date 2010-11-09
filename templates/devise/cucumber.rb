run 'rm spec/fabricators/users_fabricator.rb'

create_file 'spec/fabricators/users_fabricator.rb' do
<<-'FILE'
Fabricator(:user) do
  name { Fabricate.sequence(:name) { |i| "Bear #{i}" } }
  email { Fabricate.sequence(:email) { |i| "user#{i}@yoursite.com" } }
  password "password"
  confirmed_at Time.new.to_s
  confirmation_sent_at Time.new.to_s
  password_confirmation "password"
end

Fabricator(:admin, :from => :user) do
  email "admin@yoursite.com"
  password "password"
end

Fabricator(:member, :from => :user) do
  email "member@yoursite.com"
  password "password"
end
FILE
end

create_file 'features/step_definitions/devise_steps.rb' do
<<-'FILE'
When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  visit(new_user_session_path)
  fill_in("user[email]", :with => email)
  fill_in("user[password]", :with => password)
  click_button("Sign in")
end

Given /^a logged in admin user$/ do
  Fabricate(:admin)
  visit(new_user_session_path)
  fill_in("user[email]", :with => "admin@yoursite.com")
  fill_in("user[password]", :with => "password")
  click_button("Sign in")
end

Given /^a logged in member user$/ do
  Fabricate(:member)
  visit(new_user_session_path)
  fill_in("user[email]", :with => "member@yoursite.com")
  fill_in("user[password]", :with => "password")
  click_button("Sign in")
end

When /^I log out$/ do
  visit(destroy_user_session_path)
end

Given /^a user "([^\"]*)"$/ do |email|
  Fabricate(:user, :email => email)
end
FILE
end

inject_into_file 'features/support/paths.rb', :after => "case page_name\n" do
<<-'FILE'
      
      when /logout/
        '/users/sign_out'

      when /login/
        '/users/sign_in'
FILE
end

create_file 'features/forgot_password.feature' do
<<-'FILE'
Feature: Forgot password
  As an user
  I want to secure way to reset my password
  So that I can still login if I forget it

  Scenario: Follow forget your password link
    Given the following user records
    | email                |
    | forgot@yoursite.com |
    When I am on the login page
    And I follow "Forgot your password?"
    And I fill in "Email" with "forgot@yoursite.com"
    And I press "Send me reset password instructions"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
    And 1 emails should be delivered to forgot@yoursite.com
    When I click the first link in the email
    And I fill in "Password" with "myNewP@ssword"
    And I fill in "Password confirmation" with "myNewP@ssword"
    And I press "Change my password"
    Then I should see "Your password was changed successfully. You are now signed in."
FILE
end

create_file 'features/resend_verification_email.feature' do
<<-'FILE'
Feature: Resend Verification
  As an user
  I want to resend my verification email
  So that I can activate my account if I lost the original email

  Scenario: Follow resend verification email
    Given the following user records
    | email                | confirmed_at |
    | resend@yoursite.com | nil          |
    When I am on the login page
    And I follow "Didn't receive confirmation instructions?"
    And I fill in "Email" with "resend@yoursite.com"
    And I press "Resend confirmation instructions"
    Then I should see "You will receive an email with instructions about how to confirm your account in a few minutes."
    And 2 emails should be delivered to resend@yoursite.com
    When I click the first link in the email
    Then I should see "Your account was successfully confirmed. You are now signed in."
FILE
end
