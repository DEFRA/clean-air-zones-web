# frozen_string_literal: true

When('I visit the enter details page') do
  mock_vehicles_in_fleet
  mock_users
  mock_actual_account_name
  mock_clean_air_zones
  login_user(permissions: 'MANAGE_VEHICLES')
  visit enter_details_vehicles_path
end

When('I enter vrn') do
  mock_vehicle_details
  fill_in('vrn', with: 'CU57ABC')
end

When('I enter exempt vrn') do
  mock_exempt_vehicle_details
  fill_in('vrn', with: 'CU57ABC')
end

When('I enter not found vrn') do
  mock_not_found_vehicle_details
  fill_in('vrn', with: 'CU57ABC')
end

Then('I should be on the enter details page') do
  expect(page).to have_current_path(enter_details_vehicles_path)
end

Then('I should be on the details page') do
  expect(page).to have_current_path(details_vehicles_path)
end

Then('I choose that the details are incorrect') do
  choose('No')
end

Then('I choose that the details are correct') do
  mock_clean_air_zones
  mock_vehicles_in_fleet
  choose('Yes')
end

Then('I should be on the exempt page') do
  expect(page).to have_current_path(exempt_vehicles_path)
end

Then('I should be on the vehicle not found page') do
  expect(page).to have_current_path(not_found_vehicles_path)
end

Then('I should be on the incorrect details page') do
  expect(page).to have_current_path(incorrect_details_vehicles_path)
end

When('I press the Continue to add vehicle') do
  mock_clean_air_zones
  mock_vehicles_in_fleet
  click_on('Continue')
end

Then('I should be on the local vehicles exemptions page') do
  expect_path(local_exemptions_vehicles_path)
end

Then('I should be on the calculating chargeability page') do
  expect_path(calculating_chargeability_uploads_path)
end
