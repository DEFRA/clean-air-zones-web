# frozen_string_literal: true

include MockHelpers

Then('I choose Leeds') do
  mock_vehicle_compliance
  check('Leeds')
end

Then('I press Check another vehicle') do
  click_link('Check another vehicle')
end

When('I press the Continue when server returns 422 status') do
  allow(ComplianceCheckerApi).to receive(:vehicle_compliance)
    .and_raise(BaseApi::Error422Exception.new(422, '',
                                              'message' => 'Something went wrong'))

  click_button 'Continue'
end
