# frozen_string_literal: true

Given('I go to the create account page') do
  visit create_account_path
end

Given('I visit the verification link with a token status {string}') do |string|
  allow(Organisations::VerifyAccount).to receive(:call).and_return(string.to_sym)
  visit email_verification_organisations_path(token: SecureRandom.uuid)
end

Given('I visit the verification link second time') do
  allow(Organisations::VerifyAccount).to receive(:call).and_raise(UserAlreadyConfirmedException)
  visit email_verification_organisations_path(token: SecureRandom.uuid)
end

Then('I enter a company name') do
  mock_clean_air_zones
  stub_request(:post, /accounts/).to_return(
    status: 201,
    body: {
      accountId: 'ccb37077-c4b8-4cc2-b34f-4931de0774f9'
    }.to_json
  )
  fill_in('organisations_company_name', with: 'Company name')
end

Then('I enter invalid company name') do
  fill_in('organisations_company_name', with: '@test')
end

Then('I enter api invalid company: {string}') do |string|
  stub_request(:post, /accounts/).to_return(
    status: 422,
    body: {
      message: "Invalid company name: #{string}",
      errorCode: string
    }.to_json
  )
  fill_in('organisations_company_name', with: 'Company name')
end

Then('I enter a long company name') do
  fill_in('organisations_company_name', with: ('a' * 181))
end

And('I enter the account details') do
  allow(AccountsApi::Users).to receive(:create_user).and_return(read_response('create_user.json'))
  fill_account_details
end

And('I enter the account details with not uniq email address') do
  stub_request(:post, /users/).to_return(
    status: 422,
    body: {
      message: 'Submitted parameters are invalid',
      errorCode: 'emailNotUnique'
    }.to_json
  )
  fill_account_details
end

Then('I want to resend email verification') do
  allow(AccountsApi::Users).to receive(:resend_verification).and_return(true)
end

And('I receive verification email') do
  expect(AccountsApi::Users).to have_received(:resend_verification)
end

When('I go to the email verified page') do
  visit email_verified_organisations_path
end

def fill_account_details
  fill_in('organisations_email', with: 'example@email.com')
  fill_in('organisations_email_confirmation', with: 'example@email.com')
  fill_in('organisations_password', with: 'CboD9%1Q')
  fill_in('organisations_password_confirmation', with: 'CboD9%1Q')
end

And('I should be on the Company creation page') do
  expect_path(create_account_path)
end

And('I should be on the Fleet check page') do
  expect_path(how_many_vehicles_organisations_path)
end
