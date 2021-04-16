Feature: Remove a vehicle
  In order to read the page
  As a user
  I want to remove a vehicle

  Scenario: Remove a vehicle
    Given I am on the Remove vehicle page
    When I press 'Remove' button
    Then I should see 'Enter the number plate of the vehicle'
    When I enter a remove vrn
      And I press 'Remove' button
      And I should see "Do you want to remove 'CU57ABC' from the whitelist?"
    Then I press 'Continue' button
      And I should see 'Choose Yes or No'
      And I should see "Do you want to remove 'CU57ABC' from the whitelist?"
    Then I choose 'Yes' when confirm removal
      And I press 'Continue' button
    Then I should be on the Remove vehicle page
      And I should see "You have successfully removed 'CU57ABC' from the whitelist."

  Scenario: Remove a vehicle in an invalid format
    Given I am on the Remove vehicle page
      And I enter an invalid remove vrn format
      And I press 'Remove' button
    Then I should see 'Enter the number plate of the vehicle in a valid format'

  Scenario: VRN not found
    Given I am on the Remove vehicle page
      And I enter a remove vrn which not exists in database
      And I press 'Remove' button
    Then I choose 'Yes' when confirm removal
      And I press 'Continue' button
    Then I should be on the Remove vehicle page
      And I should see "Unable to remove 'CU57ABC', the registration does not exist on the whitelist."

  Scenario: Server is unavailable
    Given I am on the Remove vehicle page
      And I enter a remove vrn when server is unavailable
      And I press 'Remove' button
    Then I choose 'Yes' when confirm removal
      And I press 'Continue' button
    Then I should see the Service Unavailable page
