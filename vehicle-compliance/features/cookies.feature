Feature: Cookies
  In order to read the page
  As a user
  I want to see cookies page

  Scenario: User sees cookies page
    Given I am on the home page
    When I press Cookies link
    Then I should see "Cookies"
