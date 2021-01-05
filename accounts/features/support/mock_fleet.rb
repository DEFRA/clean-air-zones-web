# frozen_string_literal: true

# helper methods for manage vehicles flow
module MockFleet
  def mock_empty_fleet
    mock_fleet
  end

  def mock_one_vehicle_fleet
    mock_fleet(vehicles, page, mocked_charges, 1)
  end

  def mock_vehicles_in_fleet(page = 1)
    mock_fleet(vehicles, page, mocked_charges, 15)
  end

  def mock_unpaid_vehicles_in_fleet
    mock_fleet(vehicles, 1, mocked_unpaid_charges, 15)
  end

  def vehicles
    vehicles_data = read_response('vehicles.json')['1']['vehicles']
    vehicles_data.map { |data| VehiclesManagement::Vehicle.new(data) }
  end

  def mock_unavailable_fleet
    allow(VehiclesManagement::Fleet).to receive(:new).and_raise(BaseApi::Error500Exception.new(503, '', {}))
  end

  def mock_unchargeable_vehicles
    mock_fleet(vehicles, 1, mocked_unpaid_charges, 15, chargeable_vehicles_in_caz: false)
  end

  def mock_undetermined_vehicles
    mock_fleet(vehicles, 1, any_undetermined_vehicles: true)
  end

  private

  def mock_fleet( # rubocop:disable Metrics/ParameterLists
    vehicles = [],
    page = 1,
    charges = mocked_charges,
    total_vehicles_count = 0,
    chargeable_vehicles_in_caz: true,
    any_undetermined_vehicles: false
  )
    @fleet = instance_double(VehiclesManagement::Fleet,
                             pagination: paginated_vehicles(vehicles, page),
                             add_vehicle: true,
                             delete_vehicle: true,
                             empty?: vehicles.empty?,
                             charges: charges,
                             total_vehicles_count: total_vehicles_count,
                             any_chargeable_vehicles_in_caz?: chargeable_vehicles_in_caz,
                             any_undetermined_vehicles: any_undetermined_vehicles)
    allow(VehiclesManagement::Fleet).to receive(:new).and_return(@fleet)
  end

  def paginated_vehicles(vehicles, page)
    instance_double(
      VehiclesManagement::PaginatedFleet,
      vehicle_list: vehicles,
      page: page,
      total_pages: 2,
      range_start: 1,
      range_end: 10,
      total_vehicles_count: 15
    )
  end

  def mocked_charges
    VehiclesManagement::ChargeableFleet.new(read_response('chargeable_vehicles.json'))
  end

  def mocked_unpaid_charges
    VehiclesManagement::ChargeableFleet.new(read_response('chargeable_vehicles_with_unpaid_dates.json'))
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

World(MockFleet)
