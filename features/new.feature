@disable-bundler
Feature: Generate new bear app
  In order to start a new project with bear
  As a CLI
  I want to generate a rails3 app with bear

  Scenario: Run bear new my_app
    When I run "bear new my_app"
    Then the output should contain "Building authentication"
    And the output should contain "Building admin"
    And the output should contain "Bear says RAWR!!!"

  Scenario: Run bear new my_app --no-auth
    When I run "bear new my_app --no-auth"
    Then the output should not contain "Building authentication"
    And the output should not contain "Building admin"
    And the output should contain "Bear says RAWR!!!"

  Scenario: Run bear new my_app --no-admin
    When I run "bear new my_app --no-admin"
    Then the output should contain "Building authentication"
    And the output should contain "Building roles"
    And the output should not contain "Building admin"
    And the output should contain "Bear says RAWR!!!"
