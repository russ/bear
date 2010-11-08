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
    And I fill in "Name" with "Big Boi"
    And I fill in "Email" with "big@sirluciousleftfoot.com"
    And I fill in "Password" with "Ch!coDusty$"
    And I fill in "Password confirmation" with "Ch!coDusty$"
    And I check "Member"
    And I press "Save"
    Then I should see "User created!"
    And I should see "Big Boi"

    When I follow "Big Boi"
    Then the "Name" field should contain "Big Boi"
    And the "Email" field should contain "big@sirluciousleftfoot.com"
    And the "Member" checkbox should be checked
    And the "Admin" checkbox should not be checked

    Then I fill in "Name" with "Bigger Boi"
    And I fill in "Email" with "bigger@sirluciousleftfoot.com"
    And I uncheck "Member"
    And I check "Admin"
    And I press "Save"
    Then I should see "Successfully updated Bigger Boi."

    When I follow "Bigger Boi"
    Then the "Name" field should contain "Bigger Boi"
    And the "Email" field should contain "bigger@sirluciousleftfoot.com"
    And the "Member" checkbox should not be checked
    And the "Admin" checkbox should be checked
    Then I press "Save"

    Then I follow "Delete"
    Then I should see "User deleted."
    And I should not see "Bigger Boi"


FILE
end