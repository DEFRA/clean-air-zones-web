Feature: Primary user account management
  In order to manage my company name and password
  As a primary user
  I want to see the account details page

  Scenario: Company name change
    Given I visit primary user Account Details page
      And I click change name link
    Then I should see 'Update company name'
      And I should see my current company name already filled in input
    When I fill in company name with empty string and save changes
      Then I should see 'Enter the company name' 2 times
    When I fill in company name that contains 'profanity' and save changes
      Then I should see 'You have submitted a name containing language we don’t allow.' 2 times
    When I fill in company name that contains 'abuse' and save changes
      Then I should see 'You have submitted a name containing language we don’t allow.' 2 times
    When I fill in company name that contains 'duplicate' and save changes
      Then I should see 'The company name already exists' 2 times
    When I fill in company name with an invalid format and save changes
      Then I should see 'Enter company name in a valid format' 2 times
    When I fill a too long company name and save changes
      Then I should see "Enter a company name that is 180 characters or less"
    When I press 'Exit without saving' link
      Then I should be on the primary user Account Details page
    When I click change name link
      And I fill in company name with a correct value and save changes
    Then I should be on the primary user Account Details page
