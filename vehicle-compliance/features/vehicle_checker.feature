Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
      And I should see "Contact Clean Air Zones"
    Then I should see "Start now"
      And I press the Start now button
    Then I should see the Vehicle Checker page
      And I should see "Check vehicle compliance" title
      And I should see "Enter the registration details of the vehicle you want to check"

  Scenario: User enters a correct vehicle's registration and details are correct
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I should see "Vehicle type approval"
      And I should see "Model"
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ Selection page
      And I should see "Which Clean Air Zone do you want to drive through?"
      And I choose Birmingham and Leeds
      And I press the Continue
    Then I should see the Compliance page
      And I should see "Clean Air Zone charge"
      And I should see "Please Note: Results are updated on an ongoing basis. See what this means for you"

  Scenario: User enters a correct vehicle's registration but details are incorrect
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see "Check vehicle compliance" title
      And I should see "Incorrect vehicle details"
      And I press the Search Again link
    Then I am on the enter details page

  Scenario: User selects Non-UK place of registration
    Given I am on the enter details page
    Then I enter a vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see the Non-UK vehicle page
      And I press the Contact Us link
    Then I should see the Contact Form page

  Scenario: User doesn't fill VRN input
    Given I am on the enter details page
      And I press the Continue
    Then I should see "Enter the registration details of the vehicle you want to check"

  Scenario: User doesn't select country
    Given I am on the enter details page
      And I enter a vehicle's registration without selecting country
      And I press the Continue
    Then I should see "You must choose an answer"

  Scenario: User fills invalid VRN
    Given I am on the enter details page
      And I enter a vehicle's registration with "C3#%&"
      And I press the Continue
    Then I should see "Enter the registration details of the vehicle you want to check"

  Scenario: User doesn't select confirmation
    Given I am on the enter details page
    And I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I press the Confirm
    Then I should see "You must choose an answer"

  Scenario: Server is unavailable
    Given I am on the enter details page
      And I enter a vehicle's registration when server is unavailable
      And I press the Continue
    Then I should see the Service Unavailable page
      And I should see "Sorry, the service is unavailable"

  Scenario: User enters an exempt vehicle's registration
    Given I am on the enter details page
      And I enter an exempt vehicle's registration
      And I press the Continue
    Then I should see the Exemption page

  Scenario: User enters a vehicle's registration which cannot be determined
    Given I am on the enter details page
      And I enter an undetermined vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see "Incorrect vehicle details"
    Then I press the Back link
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the Cannot determine compliance page

  Scenario: User enters a correct data and use check another caz link
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ Selection page
      And I choose Birmingham and Leeds
      And I press the Continue
    Then I should see the Compliance page
      And I should see "Contact Clean Air Zones"
