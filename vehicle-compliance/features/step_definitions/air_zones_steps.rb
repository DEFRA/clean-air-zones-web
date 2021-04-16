# frozen_string_literal: true

include MockHelpers

Then('I press Check another vehicle') do
  click_link('Check another vehicle')
end

When('I press the Confirm when server returns 422 status') do
  allow(ComplianceCheckerApi).to receive(:vehicle_compliance)
    .and_raise(BaseApi::Error422Exception.new(422, '',
                                              'message' => 'Something went wrong'))

  click_button 'Confirm'
end
