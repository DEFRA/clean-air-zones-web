# frozen_string_literal: true

module MockHelpers
  def mock_vehicle_details
    details = JSON.parse(File.read('spec/fixtures/files/vehicle_details_response.json'))
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_exempt_vehicle_details
    details = { 'exempt' => true }
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_undetermined_type
    details = { 'type' => 'null' }
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_unavailable_vehicle_details
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(Errno::ECONNREFUSED)
  end

  def mock_caz
    caz_list = JSON.parse(File.read('spec/fixtures/files/caz_list_response.json'))
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list['cleanAirZones'])
  end

  def mock_unavailable_caz
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_raise(Errno::ECONNREFUSED)
  end

  def mock_vehicle_compliance
    compliance = JSON.parse(File.read('spec/fixtures/files/vehicle_compliance_response.json'))
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
  end

  def mock_sqs
    [Sqs::JaquMessage, Sqs::UserMessage].each do |service|
      allow(service).to receive(:call).and_return(SecureRandom.uuid)
    end
  end
end

World(MockHelpers)
