Feature: Fleets
  In pay for a fleet
  As a user
  I want to manage my vehicles

  Scenario: Visiting the manage fleet page with empty fleet and use bulk upload
    When I have no vehicles in my fleet and visit the manage vehicles page
      And I should be on the submission method page
    Then I select Bulk upload
      And I press the Continue
    Then I should be on the upload page
      And I should not see 'Results per page'

  Scenario: Visiting the manage fleet page with not empty fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see 'Live' 4 times
    Then I should see 'Upcoming' 1 times
    Then I should not see 'What does undetermined mean?'
    Then I am able to export my data to CSV file
      And I should see 'Showing 1 to 10 of 15'
      And I should see 'Results per page'

  Scenario: Visiting the manage fleet page with undetermined vehicles in my fleet
    When I have undetermined vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see 'What does undetermined mean?'

  Scenario: No selection on the submission method page
    When I visit the submission method page
      And I press the Continue
    Then I should be on the submission method page
      And I should see 'Choose how to add vehicles to your account'

  Scenario: Manual entry
    When I visit the submission method page
      And I select manual entry
      And I press the Continue
    Then I should be on the enter details page

  Scenario: Fleet override
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'list of vehicles' link
    Then I should be on the upload page

  Scenario: Visiting the manage fleet page with vehicles in fleet with no payment permission
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should be on the manage vehicles page
      And I should not see 'Make a payment' link
    Then I press 'Return to Account home' link
      And I should be on the Dashboard page

  Scenario: Visiting the manage fleet page with vehicles in fleet with payment permission
    When I have vehicles in my fleet
      And I visit the manage vehicles page with payment permission
    Then I should be on the manage vehicles page
      And I press 'Make a payment' link
      And I should be on the make a payment page

  Scenario: Removing vehicle from the fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'Remove' link
    Then I should be on the delete vehicle page
      And I press the Continue
    Then I should see 'You must choose an answer'
      And I choose 'Yes'
      And I press the Continue
    Then I should be on the manage vehicles page
      And I should have deleted the vehicle
      And I should see 'You have successfully removed'

  Scenario: Abandoning removing vehicle from fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'Remove' link
    Then I should be on the delete vehicle page
      And I choose 'No'
      And I press the Continue
    Then I should be on the manage vehicles page
      And I should not have deleted the vehicle
      And I should not see 'You have successfully removed'

  Scenario: Backend API is unavailable
    When Fleet backend API is unavailable
      And I visit the manage vehicles page
    Then I should see the Service Unavailable page
      And I should see 'Sorry, the service is unavailable'

  Scenario: Pagination
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see active '1' pagination button
      And I should see inactive '2' pagination button
      And I should see inactive 'next' pagination button
      And I should not see 'previous' pagination button
    When I press 2 pagination button
    Then I should see active '2' pagination button
      And I should see inactive '1' pagination button
      And I should see inactive 'previous' pagination button
      And I should not see 'next' pagination button
