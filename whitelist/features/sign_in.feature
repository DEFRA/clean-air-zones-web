Feature: Sign In
  In order to read the page
  As a Licensing Authority
  I want to see the upload page

  Scenario: View upload page without cookie
    Given I have no authentication cookie
    When I navigate to a Upload page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'
      And I should see 'Sign in' title
      And I should not see 'Data rules' link
    Then I should enter valid credentials and press the Continue
    When I should see 'Uploading your whitelist data'
      And Cookie is created for my session

  Scenario: View upload page with cookie that has not expired
    Given I have authentication cookie that has not expired
    When I navigate to a Upload page
    Then I am redirected to the Upload page
      And I should see 'Uploading your whitelist data'
      And I should see 'Upload' link
      And I should see 'Data rules' link

  Scenario: View upload page with cookie that has expired
    Given I have authentication cookie that has expired
    When I navigate to a Upload page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'

  Scenario: Sign in with invalid credentials
    Given I am on the Sign in page
    When I enter invalid credentials
    Then I remain on the current page
      And I should see 'Enter a valid email address and password' 3 times

  Scenario: Sign out
    Given I am signed in
    When I request to sign out
    Then I am redirected to the Sign in page
    When I navigate to a Upload page
    Then I am redirected to the unauthenticated root page
      And I should see 'Sign in'

  Scenario: Sign in with invalid email format
    Given I am on the Sign in page
    When I enter invalid email format
    Then I remain on the current page
      And I should see 'Enter your email address in a valid format' 2 times
      And I should see 'Enter your password' 2 times
