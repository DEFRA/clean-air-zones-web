# frozen_string_literal: true

module ChargeableVehiclesFactory
  def create_chargeable_vehicles(vehicles = mocked_chargeable_vehicles)
    instance_double(VehiclesManagement::Fleet,
                    charges: vehicles,
                    charges_by_vrn: mocked_chargeable_vehicle,
                    any_chargeable_vehicles_in_caz?: true)
  end

  private

  def mocked_chargeable_vehicles
    VehiclesManagement::ChargeableFleet.new(read_response('chargeable_vehicles.json'))
  end

  def mocked_chargeable_vehicle
    VehiclesManagement::ChargeableFleet.new(read_response('chargeable_vehicle.json'))
  end
end
