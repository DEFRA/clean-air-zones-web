# frozen_string_literal: true

Given('I visit the Manage users page and want to remove user') do
  mock_manage_users_api
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Given('I visit the Manage users page and want to remove a user who is a mandate creator') do
  mock_manage_users_api
  mock_debits
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Given('I visit the Manage users page and do not want to remove user') do
  mock_manage_users_api
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Then('I should be on the Delete user page') do
  expect(page).to have_current_path(remove_user_path(uuid))
end

private

def mock_manage_users_api
  mock_api
  mock_users
  mock_user_details
  mock_delete_user
end
