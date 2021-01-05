# frozen_string_literal: true

Given('I visit the Manage users page and want to edit user permissions') do
  mock_api
  mock_users
  mock_user_details
  mock_update_user
  mock_clean_air_zones
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Then('I should be on the Manage user page') do
  expect(page).to have_current_path(edit_user_path(uuid))
end

And('I should see what proper user permissions already checked') do
  expect(page.find('input#manage-vehicles-permission')).not_to be_checked
  expect(page.find('input#view-payments-permission')).to be_checked
end
