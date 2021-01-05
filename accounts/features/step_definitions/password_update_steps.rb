# frozen_string_literal: true

And('I enter email and password that is about to expire in {int} days and press Continue') do |days_count|
  user = new_user(days_to_password_expiry: days_count)
  allow_any_instance_of(User).to receive(:authentication).and_return(user)
  fill_sign_in_form
end

And('I should be on Update Password page') do
  expect(page).to have_current_path(edit_passwords_path)
end

When('I fill invalid old password and press {string}') do |string|
  allow(AccountsApi::Auth).to receive(:update_password).and_raise(
    BaseApi::Error422Exception.new(422, '', 'errorCode' => 'oldPasswordInvalid')
  )
  fill_in_new_password
  click_button string
end

When('I fill in a password not complex enough and press {string}') do |string|
  allow(AccountsApi::Auth).to receive(:update_password).and_raise(
    BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid')
  )
  fill_in_new_password(password: 'a', password_confirmation: 'a')
  click_button string
end

When('I fill in a password that was used before and press {string}') do |string|
  allow(AccountsApi::Auth).to receive(:update_password).and_raise(
    BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse')
  )
  fill_in_new_password
  click_button string
end

When('I fill passwords that do not match and press {string}') do |string|
  fill_in_new_password(password: 'aaaa', password_confirmation: 'bbbb')
  click_button string
end

When('I fill in correct old and new password and press {string}') do |string|
  mock_debits('active_mandates')
  allow(AccountsApi::Auth).to receive(:update_password).and_return(true)
  fill_in_new_password
  click_button string
end

def fill_in_new_password(old_password: nil, password: nil, password_confirmation: nil)
  fill_in('passwords[old_password]', with: old_password || 'old_password12345!')
  fill_in('passwords[password]', with: password || 'New_valid_password12345!@')
  fill_in('passwords[password_confirmation]', with: password_confirmation || 'New_valid_password12345!@')
end
