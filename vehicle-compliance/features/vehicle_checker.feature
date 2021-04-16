Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
      And I should see 'Contact Clean Air Zones'
    Then I should see 'Start now'
      And I press the Start now button
    Then I should see the Vehicle Checker page
      And I should be on the enter details page
      And I should see 'Enter the number plate of the vehicle' title
      And I should see 'Enter the number plate of the vehicle'
    Then I enter an invalid VRN
      And I should see 'Enter the number plate of the vehicle in a valid format'
    Then I enter too long VRN
      And I should see 'The number plate of the vehicle is too long'
    Then I enter too short VRN
      And I should see 'The number plate of the vehicle is too short'

  Scenario: User enters a correct vehicle's registration and details are correct
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I should see 'Model'
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
    Then I should see the Compliance page
      And I should see 'Clean Air Zone charge'
      And I should see 'Important information about vehicle data'
      And I should see 'How we calculate your charge'
      And I should see 'No Charge'
      And I should see '£10.00'

  Scenario: User enters a correct vehicle's registration but details are incorrect
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose 'No' when confirms vehicle details
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see 'Incorrect vehicle details' title
      And I should see 'Incorrect vehicle details'
      And I press the Check another vehicle link
    Then I am on the enter details page

  Scenario: User selects Non-UK place of registration
    Given I am on the enter details page
    Then I enter a vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see the Non-UK vehicle page

  Scenario: User selects Non-UK exempted registration
    Given I am on the enter details page
    Then I enter an exempted vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see the Exemption page

  Scenario: User selects Non-UK compliant registration
    Given I am on the enter details page
    Then I enter an compliant vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see the non-uk Compliance page

  Scenario: User doesn't fill VRN input
    Given I am on the enter details page
      And I press the Continue
    Then I should be on the enter details page

  Scenario: User doesn't select country
    Given I am on the enter details page
      And I enter a vehicle's registration without selecting country
      And I press the Continue
    Then I should see 'Choose UK or Non-UK'

  Scenario: User fills invalid VRN
    Given I am on the enter details page
      And I enter a vehicle's registration with 'C3#%&'
      And I press the Continue
    Then I should be on the enter details page

  Scenario: User doesn't select confirmations
    Given I am on the enter details page
    And I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I press the Confirm
    Then I should see 'Select yes if the details are correct'
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm

  Scenario: Server is unavailable
    Given I am on the enter details page
      And I enter a vehicle's registration when server is unavailable
      And I press the Continue
    Then I should see the Service Unavailable page
      And I should see 'Sorry, the service is unavailable'

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
      And I choose 'No' when confirms vehicle details
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see 'Incorrect vehicle details'
    Then I press the Back link
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
    Then I should see the Cannot determine compliance page

  Scenario: User enters a correct vehicle's registration which is a taxi
    Given I am on the enter details page
    Then I enter a vehicle's registration which is a taxi
      And I press the Continue
    Then I should not see 'Is your vehicle a taxi or private hire vehicle (PHV)?'
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
    Then I should not see 'Are these vehicle details correct?'
    Then I should see the Compliance page

  Scenario: User enters a correct vehicle's registration which is not taxi and Car type
    Given I am on the enter details page
    Then I enter a vehicle's registration for 'Car' type
      And I press the Continue
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
      And I should see the Compliance page
    Then I press the Back link
      And I should see the Confirm Details page

  Scenario: User enters a correct UK vehicle's registration, choose Non-UK country (fraud detection) and choose that vehicle's details are correct
    Given I am on the enter details page
    Then I enter an UK vehicle's registration and choose Non-UK country
      And I press 'Continue' button
    Then I should be on the UK registered details
      And I should see 'Your vehicle is UK registered' title
      And I should see 'Are these vehicle details correct?'
      And I should see 'CU57ABC'
    Then I press 'Confirm' button
      And I should see the Confirm UK Details page
      And I should see 'Select yes if the details are correct'
      And I should see 'Model'
      And I choose 'Yes' when confirms vehicle details
      And I press 'Confirm' button
      And I should see the Compliance page
    Then I press the Back link
      And I should see the Confirm UK Details page
      And I should see 'The DVLA holds a record for this vehicle.'

  Scenario: User enters a correct UK vehicle's registration, choose Non-UK country (fraud detection) and choose that vehicle's details are incorrect
    Given I am on the enter details page
    Then I enter an UK vehicle's registration and choose Non-UK country
      And I press 'Continue' button
    Then I should be on the UK registered details
      And I should see 'Your vehicle is UK registered' title
    Then I choose 'No' when confirms vehicle details
      And I press the Confirm
      And I should see the Incorrect Details page
    Then I press the Back link
      And I should see the Confirm UK Details page
    Then I choose 'No' when confirms vehicle details
      And I press the Confirm
      And I should see the Incorrect Details page
    Then I press the Check another vehicle link
      And I am on the enter details page
