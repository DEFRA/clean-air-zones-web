# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Represents the virtual model of the fleet.
  #
  class Fleet
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    #
    def initialize(account_id)
      @account_id = account_id
    end

    # Returns a VehiclesManagement::PaginatedFleet with vehicles associated with the account.
    # Includes data about page and total pages count.
    def pagination(page: 1, per_page: 10, only_chargeable: false, vrn: nil)
      @pagination ||= begin
        data = FleetsApi.vehicles(
          account_id: account_id,
          page: page,
          per_page: per_page,
          only_chargeable: only_chargeable,
          vrn: vrn
        )
        VehiclesManagement::PaginatedFleet.new(data, page, per_page)
      end
    end

    # Returns a VehiclesManagement::ChargeableFleet with vehicles associated with the account.
    def charges(zone_id:, vrn: nil, direction: nil)
      @charges ||= begin
        data = PaymentsApi.chargeable_vehicles(
          account_id: account_id,
          zone_id: zone_id,
          vrn: vrn,
          direction: direction
        )
        VehiclesManagement::ChargeableFleet.new(data)
      end
    end

    # Returns a VehiclesManagement::ChargeableFleet with vehicles associated with the account for provided vrn.
    def charges_by_vrn(zone_id:, vrn:)
      @charges_by_vrn ||= begin
        data = PaymentsApi.chargeable_vehicle(
          account_id: account_id,
          zone_id: zone_id,
          vrn: vrn
        )
        VehiclesManagement::ChargeableFleet.new(data)
      end
    rescue BaseApi::Error404Exception
      VehiclesManagement::ChargeableFleet.new({})
    end

    # Adds a new vehicle to the fleet. Returns boolean.
    #
    # ==== Params
    # * +vrn+ - string, vehicle registration number, required
    # * +vehicle_type+ - string, caz vehicle type, required
    #
    def add_vehicle(vrn, vehicle_type)
      FleetsApi.add_vehicle_to_fleet(vrn: vrn, vehicle_type: vehicle_type, account_id: account_id)
    rescue BaseApi::Error422Exception
      false
    end

    # Removes a vehicle from the fleet.
    #
    # ==== Params
    # * +vrn+ - string, vehicle registration number, required
    #
    def delete_vehicle(vrn)
      FleetsApi.remove_vehicle_from_fleet(vrn: vrn, account_id: account_id)
    end

    # Checks if there are any vehicles in the fleet. Returns boolean.
    def empty?
      FleetsApi.vehicles(account_id: account_id, page: 1, per_page: 1)['vehicles'].empty?
    end

    # Checks what is total count of stored vehicles.
    def total_vehicles_count
      FleetsApi.vehicles(account_id: account_id, page: 1, per_page: 1)['totalVehiclesCount']
    end

    # Checks if there are any undetermined vehicles in the fleet.
    # Return boolean.
    def any_undetermined_vehicles
      FleetsApi.vehicles(account_id: account_id, page: 1, per_page: 1)['anyUndeterminedVehicles']
    end

    # Checks if there are any chargeable vehicles in the provided clean air zone.
    # Return boolean.
    def any_chargeable_vehicles_in_caz?(zone_id)
      charges(zone_id: zone_id).any_results?
    end

    private

    # Reader for Account ID from backend DB
    attr_reader :account_id
  end
end
