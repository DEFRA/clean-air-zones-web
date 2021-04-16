# frozen_string_literal: true

include MockHelpers

def vrn
  'CU57ABC'
end

Given(/^I am on the home page$/) do
  visit '/'
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} {int} times') do |string, count|
  expect(page).to have_content(string, count: count.to_i)
end

Then('I should not see {string}') do |string|
  expect(page).not_to have_content(string)
end

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I press {string} button') do |string|
  click_button string
end

Then('I press the Continue') do
  click_button 'Continue'
end

Then('I press the Confirm') do
  mock_vehicle_compliance
  travel_to Time.zone.local(2021, 0o3, 14, 23, 59, 59) do
    click_button 'Confirm'
  end
end

Then('I press Confirm when Bath and Birmingham payments are live') do
  mock_vehicle_compliance
  travel_to Time.zone.local(2021, 0o7, 0o1, 0o0, 0o0, 0o1) do
    click_button 'Confirm'
  end
end

Then('I press Confirm when only Bath payments are live') do
  mock_vehicle_compliance
  travel_to Time.zone.local(2021, 0o3, 15, 0o0, 0o0, 0o1) do
    click_button 'Confirm'
  end
end

Then('I should see the Compliance page') do
  expect(page).to have_current_path(compliance_air_zones_path)
end

Then('I should see the non-uk Compliance page') do
  expect(page).to have_current_path(non_uk_compliance_air_zones_path)
end

Then('I press the Back link') do
  click_link('Back')
end

Then('I press {string} link') do |string|
  first(:link, string).click
end

Then('I press {string} footer link') do |string|
  within('footer.govuk-footer') do
    click_link string
  end
end

Then('I should see {string} pay link') do |string|
  page.find_link('Pay', id: "#{string.downcase}-pay-link")
end

Then('I should not see {string} pay link') do |string|
  page.has_no_selector?(id: "##{string.downcase}-pay-link")
end
