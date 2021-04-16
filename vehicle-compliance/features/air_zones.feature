Feature: Air Zone
  In order to read the page
  As a user
  I want to be able to choose a clean air zone (CAZ)
    And see details of a CAZ

  Scenario: User with correct vehicle’s registration
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
    Then I should see the Compliance page
      And I should see 'Clean Air Zone charge'
      And I should see 'Bath' pay link
      And I should not see 'Birmingham' pay link
      And I should see 'Make a payment'
      And I should see 'Now'

  Scenario: The one where I have a non-compliant vehicle and payments are live
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
      And I choose 'Yes' when confirms vehicle details
      And I press Confirm when Bath and Birmingham payments are live
    Then I should see the Compliance page
      And I should see 'Bath' pay link
      And I should see 'Birmingham' pay link
      And I should see 'Make a payment'
      And I should see 'Now' 2 times

  Scenario: The one where I have a non-compliant vehicle and when only Bath payments are live
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
      And I choose 'Yes' when confirms vehicle details
      And I press Confirm when only Bath payments are live
    Then I should see the Compliance page
      And I should see 'Bath' pay link
      And I should not see 'Birmingham' pay link
      And I should see 'Make a payment'
      And I should see 'Now' 1 times

  Scenario: When server returns 422 status
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm when server returns 422 status
    Then I should see the Cannot determine compliance page
      And I should see 'Vehicle details are incomplete'
