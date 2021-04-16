# frozen_string_literal: true

Given('I visit the Manage users page') do
  mock_api
  mock_users
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Given('I visit the Manage users page with no users') do
  mock_api
  mock_empty_users_list
  login_user(permissions: ['MANAGE_USERS'])
  mock_debits
  visit users_path
end

Given('I visit the Manage users page with more then 10 users') do
  mock_api
  mock_more_then_ten_users
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Given('I visit the Manage users page as an owner') do
  mock_api
  mock_user_on_list
  visit users_path
end

Given('I visit the Add user page after sign in') do
  mock_api
  mock_users
  login_user(permissions: ['MANAGE_USERS'])
  visit new_user_path
end

Given('I visit the Add user page') do
  visit new_user_path
end

Given('I visit the Manage users page and want to user permissions') do
  mock_api
  mock_users
  mock_user_details
  login_user(permissions: ['MANAGE_USERS'])
  visit users_path
end

Then('I should be on the Manage users page with some users already added') do
  mock_api
  mock_user_on_list
  expect(page).to have_current_path(users_path)
end

Then('I should be on the Manage users page') do
  expect(page).to have_current_path(users_path)
end

Then('I should be on the Add user page') do
  expect(page).to have_current_path(new_user_path)
end

Then('I should be on the Add user permissions page') do
  expect(page).to have_current_path(add_permissions_users_path)
end

Then('I should be on the User confirmation page') do
  expect(page).to have_current_path(confirmation_users_path)
end

When('I fill new user form with already used email') do
  stub = instance_double(
    'UsersManagement::AddUserForm',
    valid?: false,
    email_unique?: false,
    errors: instance_double('messages', messages: { email: ['Email address already exists'] })
  )
  allow(UsersManagement::AddUserForm).to receive(:new).and_return(stub)

  fill_in('new_user_name', with: 'User Name')
  click_button 'Continue'
end

When('I fill new user form with correct data') do
  allow(UsersManagement::AddUserForm).to receive(:new).and_return(
    instance_double(
      'UsersManagement::AddUserForm',
      valid?: true
    )
  )

  fill_in('new_user_name', with: 'New User Name')
  fill_in('new_user_email', with: 'new_user@example.com')
  click_button 'Continue'
end

When('I press {string} button and new user email is still unique') do |_string|
  stub = instance_double(
    'UsersManagement::AddUserPermissionsForm',
    valid?: false,
    email_unique?: true,
    errors: instance_double(
      'messages',
      messages: {
        permissions: ['Select at least one permission type to continue'],
        email: []
      }
    )
  )
  allow(UsersManagement::AddUserPermissionsForm).to receive(:new).and_return(stub)

  click_button 'Continue'
end

When('I checked permissions correctly') do
  stub = instance_double('UsersManagement::AddUserPermissionsForm', valid?: true, submit: true)
  allow(UsersManagement::AddUserPermissionsForm).to receive(:new).and_return(stub)

  check('manage-vehicles-permission')
  click_button 'Continue'
end

When('I press {string} button and new user with email was added in the meantime') do |_string|
  stub = instance_double(
    'UsersManagement::AddUserPermissionsForm',
    valid?: false,
    email_unique?: false,
    errors: instance_double('messages', messages: { email: ['Email address already exists'] })
  )
  allow(UsersManagement::AddUserPermissionsForm).to receive(:new).and_return(stub)

  click_button 'Continue'
end

And('I should see what user input fields already filled') do
  expect(page.find_field('new_user_name').value).to eq('New User Name')
  expect(page.find_field('new_user_email').value).to eq('new_user@example.com')
end

And('I should not see what user input fields already filled') do
  expect(page.find_field('new_user_name').value).to be_nil
  expect(page.find_field('new_user_email').value).to be_nil
end

private

def mock_api
  mock_actual_account_name
  mock_clean_air_zones
  mock_vehicles_in_fleet
  mock_debits
  mock_payment_history
end
