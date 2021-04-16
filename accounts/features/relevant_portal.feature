Feature: Relevant portal
  In order to read choose relevant portal
  As a user
  I want to fill the form

  Scenario: User has multiple vehicles to check
    Given I am on the Relevant portal form page
    Then I should see 'What would you like to do?'
      And I should not see 'beta This is a new service – your feedback'
      And I should see 'Check a single vehicle'
      And I should see 'Pay a charge for a single vehicle'
      And I should not see 'Sign in'
      When I press 'Continue' button
    Then I should see 'You must choose an answer'
      And I should see 'There is a problem'
      And I should not see 'Sign in'
      And I choose 'Check and pay for multiple vehicles'
      And I press 'Continue' button
    Then I should be on the Root path
      And I should see 'Sign in'
