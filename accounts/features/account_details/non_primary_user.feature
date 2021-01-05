Feature: Non-primary user account management
  In order to manage my name and password
  As a non-primary user
  I want to see the account details page

  Scenario: View Account details page
    Given I visit non-primary user Account Details page
      Then I should see 'Account details'
      And I should see 'Change' 2 times

  Scenario: Change name
    Given I visit non-primary user Account Details page
      And I click change name link
      Then I should see 'Update name'
    When I fill in name with empty string
      And I press 'Save changes' button
      Then I should see 'Enter your name' 2 times
    When I press 'Exit without saving' link
      Then I should be on the non-primary user Account Details page
    When I click change name link
      And I fill in name with new name
      And I press 'Save changes' button
    Then I should be on the non-primary user Account Details page
