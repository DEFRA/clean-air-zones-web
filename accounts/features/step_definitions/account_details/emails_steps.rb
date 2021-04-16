# frozen_string_literal: true

And('I enter change my email page') do
  mock_user_details
  visit edit_email_primary_users_path
end

Then('I should be on account details update email page') do
  expect(page).to have_current_path(edit_email_primary_users_path)
end

And('I fill in email with empty string') do
  fill_in('primary_user_email', with: '')
end

And('I fill in email with email with invalid format') do
  mock_successful_user_validation
  fill_in('primary_user_email', with: 'invalid-email')
end

When('I fill in email and confirmation with already taken email') do
  mock_failed_user_validation
  fill_email_fields
end

When('I fill in email and confirmation when api email validation failed') do
  allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
  allow(AccountsApi::Auth)
    .to receive(:update_owner_email)
    .and_raise(BaseApi::Error400Exception.new(400, 'email is not valid', ''))
  fill_email_fields
end

When('I fill in email and confirmation with valid email address') do
  mock_successful_user_validation
  fill_email_fields
  mock_owners_change_email
end

Then('I should be on the verification email sent page') do
  expect(page).to have_current_path(email_sent_primary_users_path)
end

When('I visit the Confirm email update page') do
  mock_vehicles_in_fleet
  mock_users
  mock_direct_debit_disabled
  mock_debits
  mock_account_details
  mock_clean_air_zones
  mock_payment_history
  allow(AccountsApi::Auth).to receive(:confirm_email).and_return('john.doe@example.com')

  login_owner
  visit confirm_email_primary_users_path(token: SecureRandom.uuid)
end

When('I visit the Confirm email update page when is not logged in') do
  mock_vehicles_in_fleet
  mock_users
  mock_clean_air_zones
  mock_debits

  allow(AccountsApi::Auth).to receive(:confirm_email).and_return('john.doe@example.com')
  allow(AccountsApi::Auth)
    .to receive(:sign_in)
    .and_return(
      'email' => 'john.doe@example.com',
      'accountUserId' => @uuid,
      'accountId' => @uuid,
      'accountName' => "Royal Mail's",
      'owner' => true
    )

  visit confirm_email_primary_users_path(token: SecureRandom.uuid)
end

When('I enter too easy password and confirmation password') do
  fill_in_passwords
  raise_422_confirm_exception('passwordNotValid')
end

When('I enter reused old password') do
  fill_in_passwords
  raise_422_confirm_exception('newPasswordReuse')
end

When('I enter correct passwords but the token has expired') do
  fill_in_passwords
  raise_422_confirm_exception('expired')
end

When('I enter correct passwords but the token is invalid') do
  fill_in_passwords
  raise_422_confirm_exception('invalid')
end

def raise_422_confirm_exception(error_code = '')
  allow(AccountsApi::Auth)
    .to receive(:confirm_email)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => error_code))
end

def fill_email_fields
  fill_in('primary_user_email', with: 'valid@email.com')
  fill_in('primary_user_confirmation', with: 'valid@email.com')
end
