# frozen_string_literal: true

# helper methods for manage vehicles flow
module MockFleet
  def mock_empty_fleet
    mock_fleet
  end

  def mock_one_vehicle_fleet
    mock_fleet(vehicles, page, 1)
  end

  def mock_vehicles_in_fleet(page = 1)
    mock_fleet(vehicles, page, 15)
  end

  def vehicles
    vehicles_data = read_response('vehicles.json')['1']['vehicles']
    vehicles_data.map { |data| VehiclesManagement::Vehicle.new(data) }
  end

  def mock_unavailable_fleet
    allow(VehiclesManagement::Fleet).to receive(:new).and_raise(BaseApi::Error500Exception.new(503, '', {}))
  end

  def mock_undetermined_vehicles_in_fleet
    mock_fleet(vehicles, 1, any_undetermined_vehicles: true)
  end

  private

  def mock_fleet(vehicles = [], # rubocop:disable Metrics/ParameterLists
                 page = 1,
                 total_vehicles_count = 0,
                 per_page = 10,
                 any_undetermined_vehicles: false)
    @fleet = instance_double(VehiclesManagement::Fleet,
                             pagination: paginated_vehicles(vehicles, page, per_page),
                             add_vehicle: true,
                             delete_vehicle: true,
                             empty?: vehicles.empty?,
                             total_vehicles_count: total_vehicles_count,
                             any_undetermined_vehicles: any_undetermined_vehicles)
    allow(VehiclesManagement::Fleet).to receive(:new).and_return(@fleet)
  end

  def paginated_vehicles(vehicles, page, per_page)
    instance_double(VehiclesManagement::PaginatedFleet,
                    vehicle_list: vehicles, page: page, per_page: per_page, total_pages: 2,
                    range_start: 1, range_end: 10, total_vehicles_count: 15,
                    results_per_page: [10, 20, 30, 40, 50])
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
