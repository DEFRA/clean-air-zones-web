# frozen_string_literal: true

When('I enter a remove vrn') do
  allow(api).to receive(:delete_vrn).with(vrn, user_uuid, 'user@example.com').and_return(true)
  fill_remove_vrn
end

When('I enter a remove vrn when server is unavailable') do
  allow(api).to receive(:delete_vrn).with(vrn, user_uuid, 'user@example.com')
                                    .and_raise(Errno::ECONNREFUSED)
  fill_remove_vrn
end

When('I enter a remove vrn which not exists in database') do
  service = BaseApi::Error404Exception
  allow(api).to receive(:delete_vrn).with(default_vrn, user_uuid, 'user@example.com').and_raise(
    service.new(404, 'VRN number was not found', {})
  )
  fill_remove_vrn
end

Then('I choose {string} when confirm removal') do |string|
  within('#confirm_remove_radios') do
    choose(string)
  end
end

When('I enter an invalid remove vrn format') do
  fill_remove_vrn('****&&&%%%%')
end

def fill_remove_vrn(vrn = default_vrn)
  fill_in('vrn', with: vrn)
end
