# frozen_string_literal: true

Given('I am on the set up account page') do
  token = '27978cac-44fa-4d2e-bc9b-54fd12e37c69'
  account = 'd7d5f7fe-ca59-11ea-9d1f-07266045ba2b'

  allow(AccountsApi::Accounts).to receive(:account).and_return({ accountName: 'Tested company name' })

  visit set_up_users_path(token: token, account: account)
end

Given('I am on the set up account page with invalid account uuid') do
  token = '27978cac-44fa-4d2e-bc9b-54fd12e37c69'

  allow(AccountsApi::Accounts).to receive(:account).and_raise(
    BaseApi::Error404Exception.new(404, '', {})
  )

  visit set_up_users_path(token: token, account: 'invalid-account-uuid')
end

And('I have entered a valid password and confirmation') do
  fill_in_password
  fill_in_confirmation
end

And('I provide password only') do
  fill_in_password
end

And('I provide only password confirmation') do
  fill_in_confirmation
end

And('I provide passwords that do not match') do
  fill_in_password('passwordA')
  fill_in_confirmation('passwordB')
end

And('I provide exact but invalid passwords') do
  fill_in_password('invalid')
  fill_in_confirmation('invalid')
  allow(AccountsApi::Auth).to receive(:set_password).and_raise(
    BaseApi::Error422Exception.new(422, '', {})
  )
end

And('I have a valid token') do
  allow(AccountsApi::Auth).to receive(:set_password).and_return(true)
end

And('I have an invalid token') do
  allow(AccountsApi::Auth).to receive(:set_password).and_raise(
    BaseApi::Error400Exception.new(400, '', {})
  )
end

Then('I am taken to the account set up confirmation page') do
  expect_path(set_up_confirmation_users_path)
end

def fill_in_password(value = 'P@$$w0rd123456')
  fill_in('account_set_up_password', with: value)
end

def fill_in_confirmation(value = 'P@$$w0rd123456')
  fill_in('account_set_up_password_confirmation', with: value)
end
