# frozen_string_literal: true

Given('I am on the enter details page') do
  visit enter_details_vehicle_checkers_path
end

Then('I press the Start now button') do
  click_link 'Start now'
end

Then('I should see the Vehicle Checker page') do
  expect(page).to have_current_path(enter_details_vehicle_checkers_path)
end

Then("I enter a vehicle's registration and confirms to be a taxi") do
  mock_vehicle_details
  fill_fields
  check('I confirm this vehicle is a taxi or private hire vehicle.')
end

Then("I enter a vehicle's registration") do
  mock_vehicle_details
  fill_fields
end

Then("I enter an UK vehicle's registration and choose Non-UK country") do
  mock_vehicle_details
  mock_vehicle_compliance

  fill_in('vrn', with: vrn)
  choose('Non-UK')
end

Then("I enter a vehicle's registration which is a taxi") do
  mock_taxi_details
  fill_fields
end

Then("I enter a vehicle's registration for {string} type") do |string|
  details = { 'registrationNumber' => 'CU57ABC', 'taxiOrPhv' => false, 'type' => string }
  allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  fill_fields
end

Then("I enter a vehicle's registration without selecting country") do
  fill_in('vrn', with: vrn)
  mock_vehicle_details
end

Then("I enter a vehicle's registration and choose Non-UK") do
  fill_non_uk_fields
  mock_unregistered_non_uk_vehicle_details
end

Then("I enter an exempted vehicle's registration and choose Non-UK") do
  fill_non_uk_fields
  mock_exempted_register_details
end

Then("I enter an compliant vehicle's registration and choose Non-UK") do
  fill_non_uk_fields
  mock_compliant_register_details
  mock_clean_air_zones_request
  mock_vehicle_compliance
end

Then("I enter a vehicle's registration with {string}") do |string|
  fill_fields(string)
  mock_vehicle_details
end

Then('I press the Continue when server is unavailable') do
  mock_unavailable_vehicle_details
  click_button 'Continue'
end

Then('I should see the Confirm Details page') do
  expect(page).to have_current_path(confirm_details_vehicle_checkers_path)
end

Then('I should see the Confirm UK Details page') do
  expect(page).to have_current_path(confirm_uk_details_vehicle_checkers_path)
end

Then('I choose {string} when confirms vehicle details') do |string|
  within('#confirm_details_radios') do
    choose(string)
  end
end

Then('I should see the Incorrect Details page') do
  expect(page).to have_current_path(incorrect_details_vehicle_checkers_path)
end

And('I press the Check another vehicle link') do
  click_link 'Check another vehicle'
end

Then('I should see the CAZ Selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path)
end

Then('I should see the Service Unavailable page') do
  expect(page).to have_title 'Sorry, the service is unavailable'
end

And("I enter an exempt vehicle's registration") do
  fill_fields
  mock_exempt_vehicle_details
end

Then('I should see the Exemption page') do
  expect(page).to have_current_path(exemption_vehicle_checkers_path)
end

Then('I should see the Non-UK vehicle page') do
  expect(page).to have_current_path(non_uk_vehicle_checkers_path)
end

And("I enter an undetermined vehicle's registration") do
  fill_fields
  mock_undetermined_type
end

Then('I should see the Cannot determine compliance page') do
  expect(page).to have_current_path(cannot_determine_vehicle_checkers_path)
end

And('I press the Check another Clean Air Zone link') do
  click_link('Check another Clean Air Zone')
end

And("I enter a vehicle's registration when server is unavailable") do
  mock_unavailable_vehicle_details
  fill_fields
end

Then('I enter an invalid VRN') do
  fill_fields('%%%%%%')
  click_button 'Continue'
end

Then('I enter too long VRN') do
  fill_fields('123456789')
  click_button 'Continue'
end

Then('I enter too short VRN') do
  fill_fields('1')
  click_button 'Continue'
end

private

def fill_fields(vrn = 'CU57ABC')
  fill_in('vrn', with: vrn)
  choose('UK')
end

def fill_non_uk_fields
  fill_in('vrn', with: 'RBI A168')
  choose('Non-UK')
end
