Feature: Account set up
  As an Account Manager
  I want to be able to set up a password when I’ve been invited to join an account
  So that I can log in

  Scenario: I enter matching valid passwords and select continue
    Given I am on the set up account page
      And I should see "Tested company name’s Clean Air Zone account"
      And I should see 'include at least 1 upper case letter, a number and a special character'
      And I have a valid token
      And I have entered a valid password and confirmation
    When I press 'Continue' button
      Then I am taken to the account set up confirmation page
    When I press 'Forgotten your password?' link
      And I press 'Back' link
    Then I am taken to the account set up confirmation page
      When I press 'Forgotten your password?' link
      And I press 'Back' link
    Then I am taken to the account set up confirmation page

  Scenario: The one where the token or account uuid is missing or invalid
    Given I am on the set up account page with invalid account uuid
      And I have an invalid token
      And I should see 'Authorisation token is invalid or has expired'
      And I have entered a valid password and confirmation
    When I press 'Continue' button
      Then I should see 'Authorisation token is invalid or has expired'

  Scenario: I am not allowed to progress if I don't give a password or confirmation
    Given I am on the set up account page
      When I press 'Continue' button
    Then I should see 'Enter your new password'
      And I should see 'Confirm your new password'
    Then I provide only password confirmation
      And I press 'Continue' button
    Then I should see 'Enter your new password'
      And I should see 'Enter a password and password confirmation that are the same'
    When I provide password only
      And I press 'Continue' button
    Then I should see 'Enter a password and password confirmation that are the same'
      And I should see 'Confirm your new password'

  Scenario: The one where the passwords details don’t match
    Given I am on the set up account page
      And I provide passwords that do not match
    When I press 'Continue' button
      Then I should see 'Enter a password and password confirmation that are the same' 3 times

  Scenario: The one where the passwords are not formatted correctly
    Given I am on the set up account page
      And I provide exact but invalid passwords
    When I press 'Continue' button
      Then I should see 'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and a special character' 3 times
