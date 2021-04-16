# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Represents the virtual model of the fleet.
  #
  class Fleet
    include LogAction
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
    def pagination(page: 1, per_page: 10, only_chargeable: false, vrn: nil) # rubocop:disable Metrics/MethodLength
      @pagination ||= begin
        log_action('Getting paginated vehicles in the fleet')
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
      log_action('Checking if there are any vehicles in the fleet')
      api_call['vehicles'].empty?
    end

    # Checks what is total count of stored vehicles.
    def total_vehicles_count
      log_action('Getting the total count of stored vehicles in the fleet')
      api_call['totalVehiclesCount']
    end

    # Checks if there are any undetermined vehicles in the fleet.
    # Return boolean.
    def any_undetermined_vehicles
      log_action('Checking if there are any undetermined vehicles in the fleet')
      api_call['anyUndeterminedVehicles']
    end

    private

    # Reader for Account ID from backend DB
    attr_reader :account_id

    # Make api call to get vehicles in the fleet
    def api_call
      FleetsApi.vehicles(account_id: account_id, page: 1, per_page: 1)
    end
  end
end
