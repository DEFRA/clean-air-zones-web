Feature: Sign In
  In order to read the page
  As a user
  I want to see the dashboard page

  Scenario: View dashboard page without cookie
    Given I have no authentication cookie
    When I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign In'
      And I should see 'beta This is a new service – your feedback'
      And I should not see 'Account' link
    Then I should enter fleet owner credentials and press the Continue
    When I should see "Royal Mail's account home"
      And Cookie is created for my session
      And I should not see 'Create account' link

  Scenario: View dashboard page with cookie that has not expired
    Given I have authentication cookie that has not expired
    Then I should see "Royal Mail's account home"

  Scenario: View dashboard page with cookie that has expired
    Given I have authentication cookie that has expired
    When I visit the Dashboard page
      And I should not see "Royal Mail's account home"
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign In'

  Scenario: Sign in with invalid credentials
    Given I am on the Sign in page
      And I should see 'Create an account' link
    When I enter invalid credentials
    Then I remain on the current page
      And I should see 'The email or password you entered is incorrect'
      And I should not see 'Enter your email address'
      And I should not see 'Enter your password'
    When I press 'Forgotten your password?' link
      And I press 'Back' link
    Then I remain on the current page

  Scenario: Sign in with unconfirmed email
    Given I am on the Sign in page
    When I enter unconfirmed email
    Then I remain on the current page
      And I should see 'Your email address is not confirmed'

  Scenario: Sign out
    Given I am signed in
    When I request to sign out
      And  I am redirected to the Sign out page
      And I should see 'Sign out successful'
      And I should see 'Sign back into the business account' link
    When I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign In'

  Scenario: Sign in with invalid email format
    Given I am on the Sign in page
    When I enter invalid email format
    Then I remain on the current page
      And I should see 'Enter your email address in a valid format'
      And I should see 'Enter your email address'

  Scenario: Sign in after setting up the account
    Given I am on the set up account confirmation page
      And I should see 'Create an account' link
    When I enter invalid credentials
    Then I remain on the current page
      And I should see 'The email or password you entered is incorrect'
    When I enter invalid email format
    Then I remain on the current page
      And I should see 'Enter your email address in a valid format'
    Then I provide valid credentials and Continue
      And I should see "Royal Mail's account home"
      And Cookie is created for my session
      And I should not see 'Create account' link

  Scenario: Sign in with pending email change
    Given I am on the Sign in page
    When I enter pending email change
    Then I remain on the current page
      And I should see 'You need to verify the link in the email we sent before trying to sign in'
