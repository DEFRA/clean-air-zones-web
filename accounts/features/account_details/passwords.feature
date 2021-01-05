Feature: Password update
  As an account user
  I want to be able to update my password
  So that I can change it for security reasons

  Scenario: Password update process as primary user
    Given I visit primary user Account Details page
      And I want to change my password
      And I should be on account details update password page
    Then I press 'Exit without saving' link
      And I should be on the primary user Account Details page
      And I want to change my password
    When I press 'Save changes' button
      Then I should see 'Enter your old password' 2 times
      Then I should see 'Enter your new password' 2 times
      Then I should see 'Confirm your new password' 2 times
    When I fill invalid old password and press 'Save changes'
      Then I should see 'The password you entered is incorrect' 2 times
    When I fill in a password not complex enough and press 'Save changes'
      Then I should see 'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and a special character' 2 times
    When I fill in a password that was used before and press 'Save changes'
      Then I should see 'You have already used that password, choose a new one' 2 times
    When I fill passwords that do not match and press 'Save changes'
      Then I should see 'Enter a password and password confirmation that are the same' 3 times
    When I fill in correct old and new password and press 'Save changes'
      Then I should be on the primary user Account Details page

  Scenario: Password update process as non primary user
    Given I visit non-primary user Account Details page
      And I want to change my password
      And I should be on account details update password page
    Then I press 'Exit without saving' link
      And I should be on the non-primary user Account Details page
      And I want to change my password
    When I fill in correct old and new password and press 'Save changes'
      Then I should be on the non-primary user Account Details page
