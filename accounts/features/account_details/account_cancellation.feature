Feature: Primary user account cancellation
  In order to close the organization account
  As a primary user
  I want to see the account cancellation form

  Scenario: Close the account
    Given I visit primary user Account Details page
      And I press 'Close account' link
    Then I should be on the Closing Account page
      And I should see 'Closing an account'
      And I press 'Continue' button
    Then I should be on the Closing Account page
      And I should see 'You must choose an answer'
    Then I select 'Yes'
      And I press 'Continue' button
    Then I should see 'Why do you want to close the account?'
    When I press 'Close account' button
    Then I should see 'You must choose an answer'
    When I select 'Other'
      And I press 'Close account' button
    Then I should be redirected to Account Closed page
      And I should see 'Account closed'
