Feature: Dashboard
  In order to read the page
  As a user
  I want to see the dashboard page

  Scenario: View dashboard page with `MANAGE_VEHICLES` permission
    Given I navigate to a Dashboard page with 'MANAGE_VEHICLES' permission
      And I should see 'Manage vehicles and view charges' link
      And I should see 'Help' link
      And I should not see 'Direct Debits' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
      And I should not see 'Royal Mail payment history' link
      And I should not see 'Your payment history' link

  Scenario: View dashboard page with `MANAGE_MANDATES` permission
    Given I navigate to a Dashboard page with 'MANAGE_MANDATES' permission
      And I should see 'Direct Debits' link
      And I should see 'Help' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
      And I should not see 'Royal Mail payment history' link
      And I should not see 'Your payment history' link

  Scenario: View dashboard page with `MAKE_PAYMENTS` permission
    Given I navigate to a Dashboard page with 'MAKE_PAYMENTS' permission
      And I should see 'Help' link
      And I should see 'Make a payment' link
      And I should see 'Your payment history' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Direct Debits' link
      And I should not see 'Manage users' link
      And I should not see 'Royal Mail payment history' link

  Scenario: View dashboard page with `MANAGE_USERS` permission
    Given I navigate to a Dashboard page with 'MANAGE_USERS' permission
      And I should see 'Help' link
      And I should see 'Manage users' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Direct Debits' link
      And I should not see 'Make a payment' link
      And I should not see 'Royal Mail payment history' link
      And I should not see 'Your payment history' link

  Scenario: View dashboard page with `VIEW_PAYMENTS` permission
    Given I navigate to a Dashboard page with 'VIEW_PAYMENTS' permission
      And I should see 'Help' link
      And I should see 'Royal Mail payment history' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Direct Debits' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
      And I should not see 'Your payment history' link
    When I navigate to a Dashboard page without any payers users
      And I should not see 'Royal Mail payment history' link
