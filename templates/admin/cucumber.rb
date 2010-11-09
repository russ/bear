inject_into_file 'features/support/paths.rb', :after => "case page_name\n" do
<<-'FILE'

      when /the admin/
        '/admin'

      when /the add user page/
        '/admin/users/new'
FILE
end

create_file 'features/user_admin.feature' do
<<-'FILE'
Feature: Administer users
  As an administrator
  I want to manage the users
  So that I can provide support for them

  Scenario: Create, update, delete a user in the admin
    Given a logged in admin user
    When I am on the add user page
    And I fill in "Name" with "Big Boi"
    And I fill in "Email" with "big@sirluciousleftfoot.com"
    And I fill in "Password" with "Ch!coDusty$"
    And I fill in "Password confirmation" with "Ch!coDusty$"
    And I press "Create User"
    Then I should see "User created!"
    And I should see "Big Boi"

    When I follow "Big Boi"
    Then the "Name" field should contain "Big Boi"
    And the "Email" field should contain "big@sirluciousleftfoot.com"

    Then I fill in "Name" with "Bigger Boi"
    And I fill in "Email" with "bigger@sirluciousleftfoot.com"
    And I press "Update User"
    Then I should see "Successfully updated Bigger Boi."

    Then I follow "Delete"
    Then I should see "User deleted."
    And I should not see "Bigger Boi"
FILE
end
