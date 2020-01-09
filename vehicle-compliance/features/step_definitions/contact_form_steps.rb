# frozen_string_literal: true

When('I am on the Contact Form page') do
  visit contact_forms_path
end

Then('I fill all fields and press Send button') do
  mock_sqs
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I should see the Result page') do
  expect(page).to have_current_path(result_contact_forms_path)
end

Then('I am not fill First Name field and press Send button') do
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I am not fill Last Name field and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I am not fill Email Address field and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email_confirmation', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I am not fill Email Confirmation field and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I am not select any Query Type and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: email)
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I am not fill Message field and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: email)
  select('Compliance', from: 'contact_form_type_of_enquiry')
  click_button 'Send'
end

Then('I fill not the same email and email_confirmation fields and press Send button') do
  fill_in('contact_form_first_name', with: 'James')
  fill_in('contact_form_last_name', with: 'Smith')
  fill_in('contact_form_email', with: email)
  fill_in('contact_form_email_confirmation', with: 'another_email@example.com')
  select('Compliance', from: 'contact_form_type_of_enquiry')
  fill_in('contact_form_message', with: 'Test message')
  click_button 'Send'
end

Then('I fill too long message and press Send button') do
  message = 'Aaa' * 700
  fill_in('contact_form_message', with: message)
  click_button 'Send'
end

Then('I remain on the Contact Form page') do
  expect(page).to have_current_path(contact_forms_path)
end

private

def email
  'test@example.com'
end
