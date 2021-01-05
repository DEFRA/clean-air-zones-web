Feature: Manage users
  In order to read the page
  As a user
  I want to manage my users

  Scenario: Visiting the manage users page
    Given I visit the Manage users page
    Then I should be on the Manage users page
      And I should see 'Manage Royal Mail account users'
      And I should see 'Add another user'
      And I should see 'Change' link

  Scenario: Visiting the manage users page with no users
    Given I visit the Manage users page with no users
    Then I should be on the Manage users page
      And I should see 'Add another user' button
      And I should not see 'Change' link
      And I should not see 'You have added the maximum amount of users to this business account.'
    Then I press 'Add another user' link
      And I should be on the Add user page
    Then I press 'Back' link
      Then I should be on the Dashboard page

  Scenario: Visiting the manage users page with more then 10 users
    Given I visit the Manage users page with more then 10 users
    Then I should be on the Manage users page
      And I should not see 'Add another user' button
      And I should see 'You have added the maximum amount of users to this business account.'

  Scenario: Visiting the manage users page as an owner
    Given I visit the Manage users page as an owner
    Then I should be on the Manage users page
      And I should not see 'test@example.com'
      And I should not see 'Change' link

  Scenario: Adding new user - nobody added user with the same email in the meantime
    Given I visit the Add user page after sign in
    Then I should be on the Add user page
      And I should see 'Add a user'
      And I should see 'Continue' button
    When I press 'Continue' button
    Then I should see "Enter the user's name"
      And I should see "Enter the user's email address"
    When I fill new user form with already used email
    Then I should see 'Email address already exists'
    When I fill new user form with correct data
    Then I should be on the Add user permissions page
    When I press 'Back' link
    Then I should be on the Add user page
      And I should see 'New User Name' as 'new_user_name' value
      And I should see 'new_user@example.com' as 'new_user_email' value
      And I press 'Continue' button
    Then I should be on the Add user permissions page
    When I press 'Continue' button and new user email is still unique
    Then I should see 'Select at least one permission type to continue'
    Then I should be on the Add user permissions page
      And I press 'Back' link
    Then I should be on the Add user page
      And I press 'Continue' button
    When I checked permissions correctly
    Then I should be on the User confirmation page
      And I should not see 'Back' link
    When I press 'Continue' link
    Then I should be on the Manage users page

  Scenario: Adding new user - somebody added user with the same email in the meantime
    Given I visit the Add user page after sign in
    Then I should be on the Add user page
      And I should see 'Add a user'
      And I should see 'Continue' button
    When I fill new user form with correct data
    Then I should be on the Add user permissions page
    When I press 'Continue' button and new user with email was added in the meantime
    Then I should see 'Email address already exists'

    Scenario: Not completing to adding a new user
    Given I visit the Add user page after sign in
      And I should be on the Add user page
    When I fill new user form with correct data
    Then I should be on the Add user permissions page
    When I press 'Back' link
    Then I should be on the Add user page
      And I should see what user input fields already filled
    When I fill new user form with correct data
      And I visit the Dashboard page
      And I visit the Add user page
    Then I should not see what user input fields already filled
