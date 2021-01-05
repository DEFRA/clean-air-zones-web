# frozen_string_literal: true

Given('I have no vehicles in my fleet') do
  mock_actual_account_name
  mock_users
  mock_empty_fleet
  mock_clean_air_zones
end

Given('I have no vehicles in my fleet and visit the manage vehicles page') do
  mock_actual_account_name
  mock_empty_fleet
  mock_users
  mock_clean_air_zones
  login_user({ permissions: 'MANAGE_VEHICLES' })
  visit fleets_path
end

When('I have one vehicle in my fleet') do
  mock_one_vehicle_fleet
end

When('I visit the manage vehicles page') do
  mock_actual_account_name
  mock_clean_air_zones
  login_user({ permissions: 'MANAGE_VEHICLES' })
  visit fleets_path
end

When('I visit the manage vehicles page with payment permission') do
  mock_actual_account_name
  mock_clean_air_zones
  login_user({ permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS] })
  visit fleets_path
end

When('I visit the submission method page') do
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_users
  mock_clean_air_zones
  login_user({ permissions: 'MANAGE_VEHICLES' })
  visit submission_method_fleets_path
end

Then('I should be on the submission method page') do
  expect(page).to have_current_path(submission_method_fleets_path)
end

Then('I should be able to check CAZ charging statuses') do
  expect(page).to have_current_path(submission_method_fleets_path)
end

When('I select manual entry') do
  choose('Individual')
end

When('I select Bulk upload') do
  choose('File upload')
end

Then('I should be on the upload page') do
  expect(page).to have_current_path(uploads_path)
end

When('I have vehicles in my fleet') do
  mock_actual_account_name
  mock_users
  mock_clean_air_zones
  mock_vehicles_in_fleet
  mock_caz_mandates
  mock_direct_debit_enabled
end

When('I have undetermined vehicles in my fleet') do
  mock_clean_air_zones
  mock_undetermined_vehicles
  mock_caz_mandates
  mock_direct_debit_enabled
  mock_users
end

When('I want to pay for CAZ which started charging {int} days ago') do |start_days_ago|
  active_charge_start_date = Time.zone.today - start_days_ago.days
  caz_list = [{
    'cleanAirZoneId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
    'name' => 'Birmingham',
    'boundaryUrl' => 'https://www.birmingham.gov.uk/info/20076/pollution/1763/a_clean_air_zone_for_birmingham/3',
    'activeChargeStartDate' => active_charge_start_date.to_s
  }]
  mock_clean_air_zones(caz_list)
  mock_unpaid_vehicles_in_fleet
  mock_users
end

When('I want to pay for CAZ which start charging in next the month') do
  mock_bath_d_day
  mock_unpaid_vehicles_in_fleet
  mock_users
end

When('I want to pay for active for charging CAZ') do
  caz_list = read_response('caz_list_active.json')['cleanAirZones']
  mock_clean_air_zones(caz_list)
  mock_unpaid_vehicles_in_fleet
  mock_users
end

When('I have vehicles in my fleet that are not paid') do
  mock_users
  mock_clean_air_zones
  mock_unpaid_vehicles_in_fleet
end

When('I have no chargeable vehicles in my fleet') do
  mock_users
  mock_clean_air_zones
  mock_unchargeable_vehicles
end

Then('I should be on the manage vehicles page') do
  expect(page).to have_current_path(fleets_path)
end

Then('I should be on the delete vehicle page') do
  expect(page).to have_current_path(delete_fleets_path)
end

Then('I should have deleted the vehicle') do
  expect(@fleet).to have_received(:delete_vehicle)
end

Then('I should not have deleted the vehicle') do
  expect(@fleet.total_vehicles_count).to eq(15)
end

When('Fleet backend API is unavailable') do
  mock_unavailable_fleet
end

Then('I should see active {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).to include('moj-pagination__item--active')
end

Then('I should see inactive {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).not_to include('moj-pagination__item--active')
end

Then('I should not see {string} pagination button') do |text|
  expect(page).not_to have_selector("#pagination-button-#{text}")
end

When('I press {int} pagination button') do |selected_page|
  mock_vehicles_in_fleet(selected_page)
  page.find("#pagination-button-#{selected_page}").first('a').click
end

Then('I am able to export my data to CSV file') do
  expect(page).to have_link('Download a spreadsheet (CSV)')
end
