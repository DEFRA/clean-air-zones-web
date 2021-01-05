# frozen_string_literal: true

# helper methods for direct debits flow
module MockDebit
  def mock_api_endpoints(caz_mandates = 'caz_mandates')
    mock_clean_air_zones
    mock_vehicles_in_fleet
    mock_debits('mandates')
    mock_caz_mandates(caz_mandates)
    mock_create_mandate
    mock_create_payment
    mock_users
  end

  def mock_debits_api_call(mocked_file = 'mandates')
    api_response = read_response("/debits/#{mocked_file}.json")
    stub_request(:get, /direct-debit-mandate/).to_return(status: 200, body: api_response.to_json)
  end

  def mock_debits(mocked_file = 'mandates')
    api_response = read_response("/debits/#{mocked_file}.json")['cleanAirZones']
    allow(DebitsApi).to receive(:mandates).and_return(api_response)
  end

  def mock_caz_mandates(mocked_file = 'caz_mandates')
    api_response = read_response("/debits/#{mocked_file}.json")['mandates']
    allow(DebitsApi).to receive(:caz_mandates).and_return(api_response)
  end

  def mock_create_payment
    api_response = read_response('/debits/create_payment.json')
    allow(DebitsApi).to receive(:create_payment).and_return(api_response)
  end

  def mock_create_mandate
    api_response = read_response('/debits/create_mandate.json')
    allow(DebitsApi).to receive(:create_mandate).and_return(api_response)
  end
end

World(MockDebit)
