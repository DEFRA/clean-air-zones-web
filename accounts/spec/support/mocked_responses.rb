# frozen_string_literal: true

module MockedResponses
  def mock_debits(mocked_file = 'mandates')
    api_response = read_response("debits/#{mocked_file}.json")['cleanAirZones']
    allow(DebitsApi).to receive(:mandates).and_return(api_response)
  end

  def mock_caz_mandates(mocked_file = 'caz_mandates')
    api_response = read_response("debits/#{mocked_file}.json")['mandates']
    allow(DebitsApi).to receive(:caz_mandates).and_return(api_response)
  end

  def mock_clean_air_zones
    api_response = read_response('caz_list.json')['cleanAirZones']
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(api_response)
  end

  def mock_direct_debit_enabled
    allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
    allow(Rails.application.config.x).to(
      receive(:method_missing).with(:feature_direct_debits).and_return('true')
    )
  end

  def mock_direct_debit_disabled
    allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
    allow(Rails.application.config.x).to(
      receive(:method_missing).with(:feature_direct_debits).and_return('false')
    )
  end
end
