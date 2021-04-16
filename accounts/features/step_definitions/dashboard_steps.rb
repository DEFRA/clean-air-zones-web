# frozen_string_literal: true

When('I visit the Dashboard page') do
  visit dashboard_path
end

When('I navigate to a Dashboard page') do
  mock_dd_and_api_on_dashboard
  visit dashboard_path
end

When('I navigate to a Dashboard page with Direct Debits disabled') do
  mock_direct_debit_disabled
  mock_api_on_dashboard
  visit dashboard_path
end

When('I navigate to a Dashboard page with payments history') do
  mock_direct_debit_disabled
  mock_api_on_dashboard
  visit dashboard_path
end

When('I navigate to a Dashboard page with no payments history') do
  mock_direct_debit_disabled
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  mock_empty_payment_history
  mock_clean_air_zones
  visit dashboard_path
end

When('I navigate to a Dashboard page with Direct Debits enabled') do
  allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
  allow(Rails.application.config.x).to receive(:method_missing).with(:feature_direct_debits).and_return(false)
  mock_api_on_dashboard
  visit dashboard_path
end

When('I navigate to a Dashboard page without any payers users') do
  mock_empty_users_list
  visit dashboard_path
end

When('I navigate to a Dashboard page with {string} permission') do |permission|
  mock_dd_and_api_on_dashboard
  login_user(permissions: [permission])
end

When('I navigate to a Dashboard page with {string} and {string} permissions') do |permission1, permission2|
  mock_dd_and_api_on_dashboard
  login_user(permissions: [permission1, permission2])
end

When('I navigate to a Dashboard page with all permissions assigned') do
  mock_api_on_dashboard
  login_owner
end

When('I navigate to a Dashboard page with \'MAKE_PAYMENTS\' permission with payments in history') do
  mock_api_on_dashboard
  login_user(permissions: ['MAKE_PAYMENTS'])
end

When('I navigate to a Dashboard page with \'MAKE_PAYMENTS\' permission without payments in history') do
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  mock_empty_payment_history
  mock_clean_air_zones
  login_user(permissions: ['MAKE_PAYMENTS'])
end

Given('I visit Dashboard page without any users yet') do
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_empty_users_list
  mock_clean_air_zones
  mock_payment_history
  login_owner
end

Given('I visit Dashboard page with few users already added') do
  mock_api_on_dashboard
  login_owner
end

When('I navigate to a Dashboard page with empty fleets') do
  mock_direct_debit_enabled
  mock_empty_fleet
  mock_debits('inactive_mandates')
  mock_users
  mock_payment_history
  visit dashboard_path
end

When('I navigate to a Dashboard page with one vehicle in the fleet') do
  mock_direct_debit_enabled
  mock_one_vehicle_fleet
  mock_users
  mock_payment_history
  mock_debits('inactive_mandates')
  visit dashboard_path
end

When('I navigate to a Dashboard page before Bath D day') do
  mock_api_on_dashboard
  mock_bath_d_day
  login_owner
end

When('I navigate to a Dashboard page before Bath D day as a beta tester and Direct Debit is disabled') do
  mock_api_on_dashboard
  mock_direct_debit_disabled
  mock_bath_d_day
  login_user(owner: true, beta_tester: true)
end

private

def mock_api_on_dashboard
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  mock_payment_history
  mock_clean_air_zones
end

def mock_bath_d_day
  caz_list = [{
    'cleanAirZoneId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
    'name' => 'Bath',
    'boundaryUrl' => 'http://www.bathnes.gov.uk/zonemaps',
    'activeChargeStartDate' => Date.parse("#{Time.current.year + 1}-3-15").strftime('%Y-%m-%d')
  }]
  mock_clean_air_zones(caz_list)
end

def mock_dd_and_api_on_dashboard
  mock_direct_debit_enabled
  mock_api_on_dashboard
end
