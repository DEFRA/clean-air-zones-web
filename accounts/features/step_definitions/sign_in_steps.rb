# frozen_string_literal: true

Given('I am on the Sign in page') do
  visit new_user_session_path
end

Given('I am on the set up account confirmation page') do
  visit set_up_confirmation_users_path
end

And('I provide valid credentials and Continue') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  mock_actual_account_name
  mock_clean_air_zones
  login_owner
end

Then('I should enter fleet owner credentials and press the Continue') do
  mock_actual_account_name
  mock_clean_air_zones
  login_owner
end

When('I have no authentication cookie') do
  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to be_nil
end

And('Cookie is created for my session') do
  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
end

When('I have authentication cookie that has not expired') do
  mock_api_responses
  mock_actual_account_name
  mock_clean_air_zones
  visit new_user_session_path
  login_owner

  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] > Time.current).to be true
end

Then('I am redirected to the Sign in page') do
  expect(page).to have_current_path(root_path)
end

Then('I am redirected to the Sign out page') do
  expect(page).to have_current_path(sign_out_path)
end

Then('I am redirected to the unauthenticated root page') do
  expect(page).to have_current_path(new_user_session_path)
end

When('I enter invalid credentials') do
  allow(AccountsApi::Auth).to receive(:sign_in)
    .and_raise(BaseApi::Error401Exception.new(401, '', {}))
  fill_sign_in_form
end

When('I enter unconfirmed email') do
  allow(AccountsApi::Auth).to receive(:sign_in)
    .and_raise(BaseApi::Error422Exception.new(422, '', {}))
  fill_sign_in_form
end

Then('I remain on the current page') do
  expect(page).to have_current_path(new_user_session_path)
end

Given('I have authentication cookie that has expired') do
  # set default session_timeout
  Rails.configuration.x.session_timeout = 15

  travel_to(20.minutes.ago) do
    mock_actual_account_name
    mock_api_responses
    mock_clean_air_zones
    login_owner
  end

  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] < Time.current).to be true
end

Given('I am signed in') do
  mock_api_responses
  mock_clean_air_zones
  login_owner
end

When('I request to sign out') do
  click_link 'Sign out'
end

When('I enter invalid email format') do
  fill_in('user_email', with: 'user.example.com')
  fill_in('user_password', with: '12345678')

  click_button 'Continue'
end

When('I enter pending email change') do
  allow(AccountsApi::Auth).to receive(:sign_in).and_raise(BaseApi::Error401Exception.new(
                                                            401,
                                                            '',
                                                            'errorCode' => 'pendingEmailChange'
                                                          ))
  fill_in('user_email', with: 'User@Example.com')
  fill_in('user_password', with: '12345678')

  click_button 'Continue'
end

Then('I change my IP') do
  allow_any_instance_of(ActionDispatch::Request)
    .to receive(:remote_ip)
    .and_return('4.3.2.1')
end
