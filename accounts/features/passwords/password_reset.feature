Feature: Password reset
  As a User
  I want to be able to reset my password

  Scenario: Go to forgotten password page
    Given I am on the Sign in page
    Then I press "Forgotten your password?" link
      And I should see "Reset your password"
    When I click Send email button
      And I should see "There is a problem"
      And I should see "Enter your email address"
      And I should not see "Enter your email address in a valid format"
    When I enter valid email address
      And I should be on the email sent page

  Scenario: Visit passwords without the token
    Given I visit passwords without the token
    Then I should be on the invalid page
      And I should not see "Back" link

  Scenario: Changing password
    Given I visit passwords
    Then I should see "Please enter your new password below"
    When I enter only password
      And I press 'Update password' button
    Then I should see "Confirm your new password" 2 times
    When I enter not matching password and confirmation
      And I press 'Update password' button
    Then I should see "Enter a password and password confirmation that are the same" 3 times
    When I enter valid password and confirmation
      And I press 'Update password' button
    Then I should be on the success page

  Scenario: Not enough complex or reused password
    Given I visit passwords
    When I enter too easy password and confirmation
      And I press 'Update password' button
    Then I should see 'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and a special character' 2 times
    When I try to reuse old password
      And I press 'Update password' button
    Then I should see 'You have already used that password, choose a new one' 2 times
    When I enter valid password and confirmation
      And I press 'Update password' button
    Then I should be on the success page
