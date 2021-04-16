Feature: Search a VRN
  In order to read the page
  As a user
  I want to search a vrn

  Scenario: Search a VRN
    Given I am on the Home page
      And I press 'Search for a vehicle' link
    Then I should see 'Search for a vehicle'
      And I press 'Search' button
    Then I should see 'Enter the number plate of the vehicle'
      And I should see 'Choose a search type'
    When I enter a vrn 'CU57ABC '
      And I press 'Search' button
    Then I should see "Search results for 'CU57ABC'"

  Scenario: Search VRN in an invalid format
    Given I am on the Search VRN page
      And I enter an invalid vrn format
      And I press 'Search' button
    Then I should see 'Enter the number plate of the vehicle in a valid format'

  Scenario: VRN not found
    Given I am on the Search VRN page
      And I enter a vrn which not exists in database
      And I press 'Search' button
    Then I should see "Results not found. 'CU57ABC' does not exist on the whitelist."

  Scenario: Server is unavailable
    Given I am on the Search VRN page
      And I enter a vrn when server is unavailable
      And I press 'Search' button
    Then I should see the Service Unavailable page

  Scenario: Search a VRN for historical results
    Given I am on the Search VRN page
      And I should see 'Search for a vehicle'
    When I enter a vrn and choose Search for historical results
      And I press 'Search' button
    Then I should see 'Start date must include a day, month and year'
      And I should see 'End date must include a day, month and year'
    Then I enter a vrn and invalid dates format
      And I press 'Search' button
      And I should see 'Start date must be a real date'
    Then I enter a vrn and year with too many numbers
      And I press 'Search' button
      And I should see 'You have entered a date with too many numbers, Re-enter a date.'
    When I enter a vrn and start date earlier than end date
      And I press 'Search' button
      And I should see 'Start date must be earlier than end date'
    Then I enter a vrn and valid dates format
      And I press 'Search' button
    Then I should see "Search results for 'CU57ABC'"

  Scenario: Pagination on the historical results page
  Given I am on the Historical results page
  Then I should see active '1' pagination button
    And I should see inactive '2' pagination button
    And I should see inactive 'next' pagination button
    And I should not see 'previous' pagination button
  When I press 2 pagination button
  Then I should see active '2' pagination button
    And I should see inactive '1' pagination button
    And I should see inactive 'previous' pagination button
    And I should not see 'next' pagination button

  Scenario: Historical Search when no results found
    Given I am on the Search VRN page
    Then I enter a vrn without history and valid dates format
      And I press 'Search' button
    Then I should see "Results not found. 'CU57ABC' did not exist on the whitelist between 10/03/2020 and 14/03/2020."
      And I should not see 'Date modified'
