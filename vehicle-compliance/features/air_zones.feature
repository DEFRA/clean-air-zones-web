Feature: Air Zone
  In order to read the page
  As a user
  I want to be able to choose a clean air zone (CAZ)
    And see details of a CAZ

  Scenario: User with correct vehicle’s registration selects CAZs
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I choose Birmingham and Leeds
      And I press the Continue
    Then I should see the Compliance page
      And I should see "Clean Air Zone charge"

  Scenario: User with correct vehicle’s registration does not select any CAZ
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I press the Continue
    Then I should see the CAZ selection page
      And I should see "You must select at least one Clean Air Zone"

  Scenario: User with correct vehicle’s registration selects only one CAZ
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I choose Leeds
      And I press the Continue
    Then I should see the Compliance page
      And I press the Check another Clean Air Zone link
      And I press the Continue
    Then I should see the Compliance page
      And I press Check another vehicle
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I press the Continue
    And I should see "You must select at least one Clean Air Zone"

  Scenario: When server returns 422 status
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I choose Birmingham and Leeds
      And I press the Continue when server returns 422 status
    Then I should see the Cannot determine compliance page
      And I should see "Unable to determine compliance"

