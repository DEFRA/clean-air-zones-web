Feature: Add a new vrn
  In order to read the page
  As a user
  I want to add a new vrn

  Scenario: Add a new vrn
    Given I am on the Home page
    When I press 'Add a vehicle' link
      Then I should see 'Add a VRN'
    When I press 'Add vehicle' button
    Then I should see 'There is a problem'
      And I should see 'Enter the number plate of the vehicle'
      And I should see 'Category is required'
     And I should see 'Reason is required'
    When I enter invalid vrn details
      Then I should see 'Enter the number plate of the vehicle in a valid format'
    When I enter vrn, category and reason
      And I should see "You have successfully added 'CU57ABC' to the whitelist."

  Scenario: Add a new vrn which already exists in db
    Given I am on the Add new VRN page
    When I enter vrn which already exists in db
      And I should see 'VRN is already Whitelisted'
