Feature: Organisations
  In order to read the page
  As a user
  I want to be able to create a company
    And see what account was verified

  Scenario: User wants to create a company
    Given I go to the create account page
      And I should see 'Create a business account' title
      And I should see 'Create an account' link
    Then I press the Continue
      And I should see 'Enter the company name'
      And I should see 'By creating an account, you agree to Drive in a Clean Air Zone\'s Terms and conditions'
    Then I enter a company name
      And I press the Continue
    Then I should see 'How many vehicles do you want to add to the business account?' title
      And I press 'Back' link
    Then I should be on the Company creation page
      And I press the Continue
    Then I should be on the Fleet check page
      And I choose 'Two or more'
      And I press the Continue
    Then I should see 'Sign in details'
      And I should see 'Create an account' link
    Then I press the Continue
      And I should see 'Enter your email address'
      And I should see 'Enter your password'
      And I should not see 'Email is in an invalid format'
      And I should not see 'Email confirmation is in an invalid format'
    Then I enter the account details
      And I press the Continue
      And I should see 'Verification email'
    Then I want to resend email verification
      And I press 'resend the email' link
      And I receive verification email
      And I should see 'Verification email'

  Scenario: User tries to create invalid company
    Given I go to the create account page
      And I should see 'Create an account'
      And I should see 'Create an account' link
    Then I enter invalid company name
      And I press the Continue
      And I should see 'Enter company name in a valid format'
    Then I enter api invalid company: 'duplicate'
      And I press the Continue
      And I should see 'The company name already exists.'
    Then I enter api invalid company: 'profanity'
      And I press the Continue
      And I should see 'You have submitted a name containing language we don’t allow'
    Then I enter api invalid company: 'abuse'
      And I press the Continue
      And I should see 'You have submitted a name containing language we don’t allow'

  Scenario: User wants to create a company for fleet with one vehicle
    Given I go to the create account page
      And I should be on the Company creation page
      And I should see 'Create an account' link
    Then I press the Continue
      And I should see 'Enter the company name'
    Then I enter a company name
      And I press the Continue
    Then I should be on the Fleet check page
      And I press the Continue
    Then I should see 'You must choose an answer'
      And I choose "Less than two"
      And I press the Continue
    Then I should see 'Business accounts are for multiple vehicles' title
      And I press 'Back' link
    Then I should be on the Fleet check page

  Scenario: User wants to verify account with valid token
    Given I visit the verification link with a token status 'success'
    Then I should see 'Your email address has been verified and your business account has been activated.'

  Scenario: User wants to verify account with invalid token
    Given I visit the verification link with a token status 'invalid'
    Then I should see 'Account verification failed'

  Scenario: User wants to verify account with expired token
    Given I visit the verification link with a token status 'expired'
    Then I should see 'The link in your verification email has expired'

  Scenario: User wants to verify account second time
    Given I visit the verification link second time
    Then I should see 'Sign in'
      And I should see 'User already confirmed'

  Scenario: User wants to create a company when api returns 422 errors
    Given I go to the create account page
    Then I enter a company name
      And I press the Continue
    Then I should be on the Fleet check page
      And I choose 'Two or more'
      And I press the Continue
    Then I enter the account details with not uniq email address
      And I press the Continue
    Then I should see 'Email already exists'

  Scenario: User wants to create a company with a name over 180 characters
    Given I go to the create account page
    Then I enter a long company name
      And I press the Continue
    Then I should see 'Enter a company name that is 180 characters or less'

  Scenario: View email verified page
    Given I navigate to a Dashboard page
    When I go to the email verified page
    Then I should see 'Your business account has been created'
