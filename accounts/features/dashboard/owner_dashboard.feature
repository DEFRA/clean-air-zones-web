Feature: Dashboard
  In order to read the page
  As a owner
  I want to see the dashboard page

  Scenario: View dashboard page with fleets
    Given I navigate to a Dashboard page
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage vehicles and view charges' link
      And I should see 'Make a payment' link
      And I should not see 'You need to upload all your number plates before making a payment.'
      And I should not see 'You need to add at least one more vehicle before making a payment.'
      And I should see 'Manage users' link
      And I should see 'Pay by bank account' link

  Scenario: View dashboard page with empty fleets
    Given I navigate to a Dashboard page with empty fleets
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage vehicles and view charges' link
      And I should not see 'Make a payment' link
      And I should see 'You need to upload all your number plates before making a payment.'
      And I should see 'Pay by bank account' link

  Scenario: View dashboard page with one vehicle in the fleets
    Given I navigate to a Dashboard page with one vehicle in the fleet
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage vehicles and view charges' link
      And I should not see 'Make a payment' link
      And I should see 'You need to add at least one more vehicle before making a payment.'
      And I should see 'Pay by bank account' link

  Scenario: Owner wants to view dashboard with different IP address
    Given I navigate to a Dashboard page
    Then I should enter fleet owner credentials and press the Continue
      And I should see "Royal Mail's account home" title
      And I should see "Royal Mail's account home"
    Then I change my IP
      And I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page

  Scenario: Owner wants to add new user when previously don't have any
    Given I visit Dashboard page without any users yet
      And I should see 'Add a user' link
      And I press 'Add a user' link
    Then I should be on the Add user page

  Scenario: Owner wants to add new user when previously have few
    Given I visit Dashboard page with few users already added
      And I should see 'Manage users' link
      And I press 'Manage users' link
    Then I should be on the Manage users page
      And I should see 'Add another user' button
      And I press 'Add another user' link
    Then I should be on the Add user page

  Scenario: View dashboard page with Direct Debits disabled
    Given I navigate to a Dashboard page with Direct Debits disabled
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage vehicles and view charges' link
      And I should see 'Make a payment' link
      And I should see 'Manage users' link
      And I should not see 'Pay by bank account' link

  Scenario: View dashboard page before Bath D day
    Given I navigate to a Dashboard page before Bath D day
      And I should see 'We will add new features when charging starts on 15 March allowing you to pay to drive in Bath.'
      And I should see 'Manage vehicles' link
      And I should not see 'Make a payment' link
      And I should not see 'Your payment history' link

  Scenario: View dashboard page before Bath D day as a beta tester and Direct Debit is disabled
    Given I navigate to a Dashboard page before Bath D day as a beta tester and Direct Debit is disabled
      And I should not see 'Payment features will be enabled on this account'
      And I should see 'Manage vehicles' link
      And I should see 'Make a payment' link
      And I should see 'Payment history' link
      And I should see 'Pay by bank account' link
      And I should see 'View payments made by you and your team members.'
