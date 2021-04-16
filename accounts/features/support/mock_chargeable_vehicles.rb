# frozen_string_literal: true

# helper methods for make payments flow
module MockChargeableVehicles
  def mock_chargeable_vehicles
    allow(PaymentsApi).to receive(:chargeable_vehicles)
      .and_return(read_response('payments/chargeable_vehicles.json')['1'])
  end

  def mock_paid_chargeable_vehicles
    allow(PaymentsApi).to receive(:chargeable_vehicles)
      .and_return(read_response('payments/chargeable_vehicles_with_unpaid_dates.json'))
  end

  def mock_unchargeable_vehicles
    allow(PaymentsApi).to receive(:chargeable_vehicles)
      .and_return({ 'chargeableAccountVehicles' => { 'results' => [] }, 'totalVehiclesCount' => 0 })
  end

  def mock_undetermined_vehicles
    allow(PaymentsApi).to receive(:chargeable_vehicles)
      .and_return({
                    'chargeableAccountVehicles' => { 'results' => [] },
                    'anyUndeterminedVehicles' => true,
                    'totalVehiclesCount' => 0
                  })
  end
end

World(MockChargeableVehicles)
