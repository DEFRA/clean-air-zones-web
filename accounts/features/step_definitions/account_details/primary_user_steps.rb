# frozen_string_literal: true

Given('I visit primary user Account Details page') do
  mock_chargeable_vehicles
  mock_vehicles_in_fleet
  mock_users
  mock_debits
  mock_account_details
  mock_clean_air_zones
  mock_account_cancellation
  mock_payment_history

  login_owner
  visit primary_users_account_details_path
end

And('I should see my current company name already filled in input') do
  expect(find('.govuk-input').value).to eq("Royal Mail's")
end

When('I fill in company name with empty string and save changes') do
  fill_in_company_name('')
  click_button 'Save changes'
end

When('I fill in company name that contains {string} and save changes') do |string|
  fill_in_company_name(string)
  mock_422_invalid_name_exception(string)
  click_button 'Save changes'
end

When('I fill in company name with a correct value and save changes') do
  fill_in_company_name('New Valid Company Name')
  mock_valid_name_call
  click_button 'Save changes'
end

When('I fill in company name with an invalid format and save changes') do
  fill_in_company_name('!##')
  click_button 'Save changes'
end

When('I fill a too long company name and save changes') do
  fill_in_company_name('a' * 181)
  click_button 'Save changes'
end

And('I should be on the primary user Account Details page') do
  expect(page).to have_current_path(primary_users_account_details_path)
end

def fill_in_company_name(string)
  fill_in('primary_user_company_name', with: string)
end

def mock_422_invalid_name_exception(error_code)
  allow(AccountsApi::Accounts).to receive(:update_company_name)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => error_code))
end

def mock_valid_name_call
  allow(AccountsApi::Accounts).to receive(:update_company_name).and_return(true)
end
