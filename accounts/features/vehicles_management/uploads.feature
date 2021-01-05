Feature: Uploads
  In order to pay for a fleet
  As a user
  I want to add vehicles to my fleet by submitting CSV file

  Scenario: Uploading file with no vehicles in the fleet
    Given I have no vehicles in my fleet
      And I visit the upload page
    Then I should see 'Upload the vehicle list to Royal Mail account' title
    When I press Upload file button
    Then I should see 'Select a CSV file to upload' 2 times
    When I attach a file
      And I press Upload file button
    Then I should be on the processing page
    When I reload the page
    Then I should be on the processing page
      And My upload is finished
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press 'Continue' link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully uploaded 15 vehicles'

  Scenario: Uploading file with vehicles in the fleets
    When I have vehicles in my fleet
      And I visit the upload page
    Then I should see 'Replace and upload a new list of vehicles'
    When I press Upload file button
    Then I should see 'Select a CSV file to upload' 2 times
    When I attach a file
      And I press Upload file button
    Then I should be on the processing page
      And My upload is finished
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press 'Continue' link

  Scenario: Download template
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see 'template' link
    When  I press 'template' link
    Then I should download the template

  Scenario: Successful upload
    When I am on the processing page and number of vehicles less than the threshold
      And My upload is finished
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press 'Continue' link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully uploaded'

  Scenario: Upload in calculating chargeability status
    When I am on the processing page
      And My upload is calculating
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press 'Continue' link
    Then I should be on the calculating chargeability page
      And I should see 'Uploading vehicles' title
    Then I press 'Return to Account home' link
      And I should be on the Dashboard page
    Then I press 'Manage vehicles and view charges' link
      And I should be on the calculating chargeability page
      And I press 'Return to Account home' link
    Then I press 'Make a payment' link
      And I should be on the calculating chargeability page
    Then I press 'Return to Account home' link
      And My upload is finished
    Then I press 'Manage vehicles and view charges' link
      And I should be on the manage vehicles page
      And I should see 'You have successfully uploaded 15 vehicles'
      And I visit the Dashboard page
    Then I press 'Make a payment' link
      And I select 'Birmingham'
    Then I press the Continue
      Then I should be on the payment matrix page

  Scenario: Failed upload
    When I am on the processing page
      And My upload is failed with error: 'Some error message'
      And I reload the page
    Then I should see 'Upload the vehicle list to Royal Mail account' title
      And I should see 'Some error message'

  Scenario: Upload a csv file whose size is too big
    Given I have no vehicles in my fleet
      And I visit the upload page
    When I upload a csv file whose size is too big
    Then I should see 'The CSV must be smaller than 50MB'

  Scenario: Upload a csv file whose fleet size is too big
    Given I have no vehicles in my fleet
      And I visit the upload page
    When I upload a csv file whose fleet size is too big
    Then I should see 'The file you are uploading contains more than 200k vehicles, the maximum number allowed'

  Scenario: Upload in calculating chargeability status and number of vehicles less than the threshold
    When I am on the processing page and number of vehicles less than the threshold
      And My upload is calculating
      And I reload the page
    Then I should be on the processing page
    When My upload is finished
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press 'Continue' link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully uploaded 15 vehicles'
