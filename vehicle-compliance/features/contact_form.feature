Feature: Contact Form
  In order to read the page
  As a user
  I want to be able to send a contact form

  Scenario: User wants to send a contact form
    Given I am on the Contact Form page
      And I should see "Contact Clean Air Zones"
      And I fill all fields and press Send button
    Then I should see the Result page
      And I should see "Clean Air Zones Contact Form Sent"

  Scenario: User does not fill first name
    Given I am on the Contact Form page
      And I am not fill First Name field and press Send button
    Then I remain on the Contact Form page
      And I should see "There is a problem"
      And I should see "First name is required"

  Scenario: User does not fill last name
    Given I am on the Contact Form page
      And I am not fill Last Name field and press Send button
    Then I remain on the Contact Form page
      And I should see "Last name is required"

  Scenario: User does not fill email
    Given I am on the Contact Form page
      And I am not fill Email Address field and press Send button
    Then I remain on the Contact Form page
      And I should see "Email is required"

  Scenario: User does not fill email confirmation
    Given I am on the Contact Form page
      And I am not fill Email Confirmation field and press Send button
    Then I remain on the Contact Form page
      And I should see "Email confirmation is required"

  Scenario: User does not select query type
    Given I am on the Contact Form page
      And I am not select any Query Type and press Send button
    Then I remain on the Contact Form page
      And I should see "Type of enquiry is required"

  Scenario: User does not fill message
    Given I am on the Contact Form page
      And I am not fill Message field and press Send button
    Then I remain on the Contact Form page
      And I should see "Message is required"

  Scenario: User fill not the same email and email confirmation addresses
    Given I am on the Contact Form page
      And I fill not the same email and email_confirmation fields and press Send button
    Then I remain on the Contact Form page
      And I should see "Email and email address confirmation must be the same"

  Scenario: Filling too long message
    Given I am on the Contact Form page
      And I fill too long message and press Send button
    Then I remain on the Contact Form page
      And I should see "Message is too long (maximum is 2000 characters)"
