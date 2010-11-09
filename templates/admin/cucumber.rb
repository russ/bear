inject_into_file 'features/support/paths.rb', :after => "case page_name\n" do
<<-'FILE'

      when /the admin/
        '/admin'

      when /the add user page/
        '/admin/users/new'
FILE
end

create_file 'features/admin.feature' do
<<-'FILE'
Feature: Admin dashboard
  As an administrator
  I want to manage the application
  So that I can have full control over the site

  Scenario: Login as an admin
    Given a logged in admin user
    When I am on the admin
    Then I should see "Admin"
FILE
end

create_file 'features/user_admin.feature' do
<<-'FILE'
Feature: Administer users
  As an administrator
  I want to manage the users
  So that I can provide support for them

  Background:
    Given the following role records
    | name   |
    | Member |

  Scenario: Create, update, delete a user in the admin
    Given a logged in admin user
    When I am on the add user page
    And I fill in "user_name" with "Big Boi"
    And I fill in "user_email" with "big@yoursite.com"
    And I fill in "user_password" with "Ch!coDusty$"
    And I fill in "user_password_confirmation" with "Ch!coDusty$"
    And I press "Create User"
    Then I should see "User created!"
    And I should see "Big Boi"

    When I follow "Big Boi"
    Then the "user_name" field should contain "Big Boi"
    And the "user_email" field should contain "big@yoursite.com"

    When I follow "Bigger Boi"
    Then the "user_name" field should contain "Bigger Boi"
    And the "user_email" field should contain "bigger@yoursite.com"
    Then I press "Update User"

    Then I follow "Delete"
    Then I should see "User deleted."
    And I should not see "Bigger Boi"
FILE
end
