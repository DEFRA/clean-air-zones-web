# frozen_string_literal: true

When('I visit the make payment page to pay by direct debit') do
  mock_debits
  mock_actual_account_name
  login_user(permissions: %w[MAKE_PAYMENTS MANAGE_MANDATES], account_id: account_id)
  visit payments_path
end

When('I have no mandates') do
  mock_direct_debit_enabled
  mock_vehicles_in_fleet
  mock_debits_api_call('inactive_mandates')
  mock_users
end

When('I visit the Manage Direct Debit page') do
  mock_actual_account_name
  mock_clean_air_zones
  login_user(permissions: 'MANAGE_MANDATES')
  visit debits_path
end

Then('I visit the Payment method page') do
  visit select_payment_method_payments_path
end

Then('I should be on the Add new mandate page') do
  expect_path(set_up_debits_path)
end

When('I have created mandates') do
  mock_direct_debit_enabled
  mock_vehicles_in_fleet
  mock_debits_api_call
  mock_users
end

When('I have created all the possible mandates') do
  mock_direct_debit_enabled
  mock_vehicles_in_fleet
  mock_debits_api_call('active_mandates')
  mock_users
end

Then('I should be on the Manage debits page') do
  expect_path(debits_path)
end

When('I visit the Add new mandate page') do
  mock_actual_account_name
  mock_clean_air_zones
  login_user(permissions: 'MANAGE_MANDATES')
  visit set_up_debits_path
end

Then('I am creating a new mandate and redirecting to the complete setup endpoint') do
  mock_debits_api_call
  mock_create_mandate
  allow(DebitsApi).to receive(:complete_mandate_creation).and_return({})
  click_on('Continue')
end

Then('I am creating a new mandate when api returns 400 status') do
  mock_debits_api_call
  mock_create_mandate
  allow(DebitsApi).to receive(:complete_mandate_creation).and_raise(
    BaseApi::Error400Exception.new(400, '', {})
  )
  click_on('Continue')
end

Given('I have active mandates for selected CAZ') do
  mock_direct_debit_enabled
  mock_api_endpoints
end

Then('I should be on the Cancel payment page') do
  expect_path(cancel_payments_path)
end

Then('I should be on the Payment unsuccessful page') do
  expect_path(unsuccessful_debits_path)
end

Given('I have inactive mandates for each CAZ but one of them is disabled') do
  mock_users
  mock_vehicles_in_fleet
  mock_direct_debit_enabled
  api_response = read_response('/debits/inactive_mandates.json')
  api_response['cleanAirZones'].second['directDebitEnabled'] = false
  stub_request(:get, /direct-debit-mandate/).to_return(status: 200, body: api_response.to_json)
end
