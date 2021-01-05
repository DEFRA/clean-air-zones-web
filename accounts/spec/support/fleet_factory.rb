# frozen_string_literal: true

module FleetFactory
  def create_empty_fleet
    create_fleet([], 0)
  end

  def create_fleet(vehicles = mocked_vehicles, total_vehicles_count = 45)
    instance_double(VehiclesManagement::Fleet,
                    pagination: paginated_fleet(vehicles, total_vehicles_count),
                    add_vehicle: true,
                    delete_vehicle: true,
                    empty?: vehicles.empty?,
                    total_vehicles_count: total_vehicles_count,
                    any_undetermined_vehicles: false)
  end

  def mock_fleet(fleet_instance = create_fleet)
    allow(VehiclesManagement::Fleet).to receive(:new).and_return(fleet_instance)
  end

  private

  def mocked_vehicles
    vehicles_data = read_response('vehicles.json')['1']['vehicles']
    vehicles_data.map { |data| VehiclesManagement::Vehicle.new(data) }
  end

  def paginated_fleet(vehicles, total_vehicles_count)
    instance_double(
      VehiclesManagement::PaginatedFleet,
      vehicle_list: vehicles,
      page: 1,
      total_pages: 5,
      range_start: 1,
      range_end: 5,
      total_vehicles_count: total_vehicles_count
    )
  end
end
