Feature: Export
  In order to read the page
  As a Licensing Authority
  I want to download a CSV file

  Scenario: Download a csv file
    Given I am on the Export to CSV page
      And I should see 'Export database to CSV'
    When I press Export button
