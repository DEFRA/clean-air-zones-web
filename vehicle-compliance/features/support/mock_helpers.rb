# frozen_string_literal: true

# helper methods for cucumber tests
module MockHelpers
  def mock_vehicle_details
    details = read_response('vehicle_details_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_exempt_vehicle_details
    details = { 'registrationNumber' => 'CU57ABC', 'exempt' => true, 'taxiOrPhv' => false }
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_undetermined_type
    details = { 'registrationNumber' => 'CU57ABC', 'type' => 'null', 'taxiOrPhv' => false }
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_unavailable_vehicle_details
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(Errno::ECONNREFUSED)
  end

  def mock_vehicle_compliance
    compliance = read_response('vehicle_compliance_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
  end

  def mock_taxi_details
    details = read_response('vehicle_details_response.json')
    details['taxiOrPhv'] = 'true'
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(details)
  end

  def mock_unregistered_non_uk_vehicle_details
    details = read_response('register_details_response.json')
    allow(ComplianceCheckerApi).to receive(:register_details).and_return(details)
  end

  def mock_exempted_register_details
    details = read_response('register_details_response.json')
    details['registerExempt'] = true
    allow(ComplianceCheckerApi).to receive(:register_details).and_return(details)
  end

  def mock_compliant_register_details
    details = read_response('register_details_response.json')
    details['registerCompliant'] = true
    allow(ComplianceCheckerApi).to receive(:register_details).and_return(details)
  end

  def mock_clean_air_zones_request
    details = read_response('caz_list_response.json')['cleanAirZones']
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(details)
  end
end

World(MockHelpers)
