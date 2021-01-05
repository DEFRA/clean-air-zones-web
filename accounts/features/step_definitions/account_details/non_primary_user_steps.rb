# frozen_string_literal: true

Given('I visit non-primary user Account Details page') do
  mock_vehicles_in_fleet
  mock_users
  mock_user_details
  mock_account_details
  mock_clean_air_zones

  login_user(permissions: ['MANAGE_USERS'])
  visit non_primary_users_account_details_path
end

When('I click change name link') do
  first(:link, 'Change').click
end

When('I fill in name with empty string') do
  fill_in('non_primary_user_name', with: '')
end

When('I fill in name with new name') do
  fill_in('non_primary_user_name', with: 'New Valid Name')
  mock_update_user
end

Then('I should be on the non-primary user Account Details page') do
  expect(page).to have_current_path(non_primary_users_account_details_path)
end
