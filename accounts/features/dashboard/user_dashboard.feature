Feature: Dashboard
  In order to read the page
  As a user
  I want to see the dashboard page

  Scenario: View dashboard page with `MANAGE_VEHICLES` permission
    Given I navigate to a Dashboard page with 'MANAGE_VEHICLES' permission
      And I should see 'Manage vehicles and view charges' link
      And I should see 'Help' link
      And I should not see 'Pay by bank account' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
<<<<<<< HEAD
      And I should not see "Royal Mail's payment history" link
      And I should not see 'Your payment history' link
=======
      And I should not see 'Payment history' link
>>>>>>> release/v2.1.0

  Scenario: View dashboard page with `MANAGE_MANDATES` permission
    Given I navigate to a Dashboard page with 'MANAGE_MANDATES' permission
      And I should see 'Pay by bank account' link
      And I should see 'Help' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
<<<<<<< HEAD
      And I should not see "Royal Mail's payment history" link
      And I should not see 'Your payment history' link
=======
      And I should not see 'Payment history' link
>>>>>>> release/v2.1.0

  Scenario: View dashboard page with `MAKE_PAYMENTS` permission with payment history
    Given I navigate to a Dashboard page with 'MAKE_PAYMENTS' permission with payments in history
      And I should see 'Help' link
      And I should see 'Make a payment' link
      And I should see 'Payment history' link
        And I should see 'View payments made by you.'
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Pay by bank account' link
      And I should not see 'Manage users' link

  Scenario: View dashboard page with `MAKE_PAYMENTS` permission without payment history
    Given I navigate to a Dashboard page with 'MAKE_PAYMENTS' permission without payments in history
      And I should see 'Help' link
      And I should see 'Make a payment' link
      And I should not see 'Payment history' link
        And I should not see 'View payments made by you.'
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Pay by bank account' link
      And I should not see 'Manage users' link
<<<<<<< HEAD
      And I should not see "Royal Mail's payment history" link
=======
>>>>>>> release/v2.1.0

  Scenario: View dashboard page with `MANAGE_USERS` permission
    Given I navigate to a Dashboard page with 'MANAGE_USERS' permission
      And I should see 'Help' link
      And I should see 'Manage users' link
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Pay by bank account' link
      And I should not see 'Make a payment' link
<<<<<<< HEAD
      And I should not see "Royal Mail's payment history" link
      And I should not see 'Your payment history' link
=======
      And I should not see 'Payment history' link
>>>>>>> release/v2.1.0

  Scenario: View dashboard page with `VIEW_PAYMENTS` permission
    Given I navigate to a Dashboard page with 'VIEW_PAYMENTS' permission
      And I should see 'Help' link
<<<<<<< HEAD
      And I should see "Royal Mail's payment history" link
=======
      And I should see 'Payment history' link
        And I should see 'View payments made by your team members.'
>>>>>>> release/v2.1.0
      And I should not see 'Manage vehicles and view charges' link
      And I should not see 'Pay by bank account' link
      And I should not see 'Make a payment' link
      And I should not see 'Manage users' link
    When I navigate to a Dashboard page without any payers users
<<<<<<< HEAD
      And I should not see "Royal Mail's payment history" link
=======

  Scenario: View dashboard page with `VIEW_PAYMENTS` permission
    Given I navigate to a Dashboard page with 'MAKE_PAYMENTS' and 'VIEW_PAYMENTS' permissions
      And I should see 'Payment history' link
        And I should see 'View payments made by you and your team members.'
>>>>>>> release/v2.1.0
