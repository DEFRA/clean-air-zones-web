# frozen_string_literal: true

When('I press footer link {string}') do |string|
  within('footer.govuk-footer') do
    click_link string
  end
end

Then('I should be on the the Cookies page') do
  expect_path(cookies_path)
end

Then('I press navbar link Help') do
  mock_clean_air_zones
  find('#navbar-help').click
end
