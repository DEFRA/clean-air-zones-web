Feature: Manage user
  In order to read the page
  As a owner
  I want to manage my user

  Scenario: Editing a user
    Given I visit the Manage users page and want to edit user permissions
      And I should be on the Manage users page
    Then I press 'Change' link
      And I should be on the Manage user page
      And I should see 'Edit user details' title
      And I should see what proper user permissions already checked
      And I should see 'test@example.com'
      And I should see 'Remove' link
    Then I uncheck 'View payment history'
      And I press 'Save changes' button
    Then I should be on the Manage user page
      And I should see 'Select at least one permission type to continue'
    Then I check 'Manage vehicles'
      And I press 'Save changes' button
    Then I should be on the Manage users page
