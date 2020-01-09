Feature: Privacy Notice
  In order to read the page
  As a user
  I want to see privacy notice page

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press Privacy link
    Then I should see "Privacy Notice"
