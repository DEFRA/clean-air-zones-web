Feature: Debits
  In order to pay the charge
  As a user
  I want to manage my Direct Debits mandates

  Scenario: Making a successful Direct Debit payment with active mandate
    Given I have active mandates for selected CAZ
      And I visit the make payment page to pay by direct debit
      And I press the Continue
    Then I select 'Birmingham'
      And I press the Continue
    Then I click Next 7 days tab
      And I select any date for vrn on the payment matrix
      And I press the 'Review payment' button
    Then I want to confirm my payment
      And I confirm that my vehicles are not exempt from payment
      And I press the Continue
    Then I select 'Direct Debit'
      And I press the Continue
    Then I should see 'Confirm your payment'
      And I press 'Confirm payment' button
    Then I should see success message
    When I press 'Pay for another Clean Air Zone' link
    Then I press 'Back' link
      Then I should see success message
    And Second user starts payment in the same CAZ

  Scenario: Making a cancel Direct Debit payment with active mandate
    Given I have active mandates for selected CAZ
      And I visit the make payment page to pay by direct debit
      And I press the Continue
    Then I select 'Birmingham'
      And I press the Continue
    Then I click Next 7 days tab
      And I select any date for vrn on the payment matrix
      And I press the 'Review payment' button
    Then I want to confirm my payment
      And I confirm that my vehicles are not exempt from payment
      And I press the Continue
    Then I select 'Direct Debit'
      And I press the Continue
      And I should see 'Cancel payment'
      And I press 'Cancel payment' link
    Then I should be on the Cancel payment page
      And I should see 'Your payment has been cancelled'
    When I press the Continue
    Then I should be on the Payment unsuccessful page

  Scenario: Making a unsuccessful Direct Debit payment with active mandate
    Given I have active mandates for selected CAZ
      And I visit the make payment page to pay by direct debit
      And I press the Continue
    Then I select 'Birmingham'
      And I press the Continue
    Then I click Next 7 days tab
      And I select any date for vrn on the payment matrix
      And I press the 'Review payment' button
    Then I want to confirm my payment
      And I press the Continue
    Then I should be on the confirm payment page
      And I should see 'Confirm you have checked if you are eligible for an exemption'

  Scenario: Visiting the manage Direct Debit page with no mandates
    When I have no mandates
      And I visit the Manage Direct Debit page
    Then I should be on the Add new mandate page

  Scenario: Visiting the manage Direct Debit page with mandates
    When I have created mandates
      And I visit the Manage Direct Debit page
    Then I should be on the Manage debits page
      And I should see 'Set up a new agreement' link
      And I should not see 'You have set up bank agreements for every Clean Air Zone.'
    Then I press 'Set up a new agreement' link
      And I should see 'What you need to know before setting up an agreement:'

  Scenario: Visiting the manage Direct Debit page with all mandates
    When I have created all the possible mandates
      And I visit the Manage Direct Debit page
    Then I should be on the Manage debits page
      And I should not see 'Set up a new agreement' link
      And I should see 'You have set up bank agreements for every Clean Air Zone.'

  Scenario: Adding a new mandate
    When I have no mandates
      And I visit the Add new mandate page
      And I press the Continue
      And I should see 'You must choose one Clean Air Zone' 2 times
    When I select 'Birmingham'
    Then I am creating a new mandate and redirecting to the complete setup endpoint
      And I should be on the Manage debits page

  Scenario: Adding a new mandate with disabled CAZ
    Given I have inactive mandates for each CAZ but one of them is disabled
    When I visit the Add new mandate page
    Then I should be on the Add new mandate page
      And I should see 'Bath'
      And I should not see 'Birmingham'

  Scenario: Adding a new mandate when api returns an error
    When I have no mandates
      And I visit the Add new mandate page
      And I press the Continue
    When I select 'Birmingham'
    Then I am creating a new mandate when api returns 400 status
      And I should see the Service Unavailable page
