Feature: Static Pages
  In order to read the page
  As a user
  I want to see the static pages

  Scenario: User sees cookies page
    Given I am on the Sign in page
    When I press footer link 'Cookies'
    Then I should see 'Cookies' title
      And I should see 'A cookie is a small piece of data'

  Scenario: User sees accessibility statement page
    Given I am on the Sign in page
    When I press footer link 'Accessibility statement'
    Then I should see 'Accessibility statement for Drive in a Clean Air Zone' title

  Scenario: User sees privacy notice page
    Given I am on the Sign in page
    When I press footer link 'Privacy'
    Then I should see 'Privacy Notice' title

  Scenario: User sees terms and conditions page
    Given I am on the Sign in page
    Then I should see 'Terms and conditions' link
    When I press footer link 'Terms and conditions'
    Then I should see 'Terms and conditions' title

  Scenario: User sees help page
    Given I navigate to a Dashboard page with '' permission
      And I should see 'Help' 2 times
    When I press navbar link Help
    Then I should see 'Help' title

