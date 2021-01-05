Feature: Password reset
  As a User
  I want to be able to update my password if it is outdated

  Scenario: View dashboard page when password expires in 1 day
    Given I navigate to a Dashboard page
      And I enter email and password that is about to expire in 1 days and press Continue
    Then I should see 'Your password will expire in 1 day.'

  Scenario: View dashboard page when password expires in 10 days
    Given I navigate to a Dashboard page
      And I enter email and password that is about to expire in 10 days and press Continue
    Then I should see 'Your password will expire in 10 days.'

  Scenario: View dashboard page when password expires in 50 days
    Given I navigate to a Dashboard page
      And I enter email and password that is about to expire in 50 days and press Continue
    Then I should not see 'Your password will expire in'

  Scenario: Voluntary password update process
    Given I navigate to a Dashboard page
      And I enter email and password that is about to expire in 5 days and press Continue
      And I press 'Update it now' link
      And I should be on Update Password page
    When I press 'Continue' button
      Then I should see 'Enter your old password' 3 times
      Then I should see 'Enter your new password' 3 times
      Then I should see 'Confirm your new password' 3 times
    When I fill invalid old password and press 'Continue'
      Then I should see 'The password you entered is incorrect' 2 times
    When I fill in a password not complex enough and press 'Continue'
      Then I should see 'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and a special character' 2 times
    When I fill in a password that was used before and press 'Continue'
      Then I should see 'You have already used that password, choose a new one' 2 times
    When I fill passwords that do not match and press 'Continue'
      Then I should see 'Enter a password and password confirmation that are the same' 3 times
    When I fill in correct old and new password and press 'Continue'
      Then I should be on the Dashboard page
      And I should not see 'Your password will expire in'

  Scenario: Forced password update process
    Given I navigate to a Dashboard page
      And I enter email and password that is about to expire in 0 days and press Continue
      And I should be on Update Password page
      And I should see 'Your password has expired, choose a new one.'
    When I press 'Account home' link
      And I should be on Update Password page
    When I press 'Sign out' link
      And I enter email and password that is about to expire in -6 days and press Continue
      And I should be on Update Password page
    When I fill in correct old and new password and press 'Continue'
      Then I should be on the Dashboard page
      And I should not see 'Your password will expire in'
