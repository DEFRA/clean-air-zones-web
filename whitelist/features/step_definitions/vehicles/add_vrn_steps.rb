# frozen_string_literal: true

When('I enter vrn, category and reason') do
  allow(WhitelistApi).to receive(:add_vrn).and_return(true)
  fill_new_vrn_fields
end

When('I enter invalid vrn details') do
  fill_in('vrn', with: 'ABCDE$%')
  choose('Early adopter')
  fill_in('reason', with: 'ZAZ')
  fill_in('reason', with: 'Testing')
  click_button 'Add vehicle'
end

Given('I am on the Add new VRN page') do
  sign_in_user
  visit add_vehicles_path
end

When('I enter vrn which already exists in db') do
  service = BaseApi::Error422Exception
  allow(WhitelistApi).to receive(:add_vrn).and_raise(
    service.new(422, 'VRN is already Whitelisted', {})
  )
  fill_new_vrn_fields
end

private

def fill_new_vrn_fields
  fill_in('vrn', with: 'CU57ABC')
  choose('Early adopter')
  fill_in('reason', with: 'Testing')
  click_button 'Add vehicle'
end
