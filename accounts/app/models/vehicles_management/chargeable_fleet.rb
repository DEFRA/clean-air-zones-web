# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Class used to serialize data from PaymentsApi.chargeable_vehicles
  #
  class ChargeableFleet
    # Take data returned from the PaymentsApi.chargeable_vehicles
    def initialize(data)
      @data = data
    end

    # Returns an array of VehiclesManagement::ChargeableVehicle model instances
    def vehicle_list
      @vehicle_list ||= (data.dig('chargeableAccountVehicles', 'results') || [])
                        .map { |vehicle_data| VehiclesManagement::ChargeableVehicle.new(vehicle_data) }
    end

    # Checks if the previous page is available
    def previous_page?
      first_vrn.present?
    end

    # Checks if the next page is available
    def next_page?
      last_vrn.present?
    end

    # Returns VRN used to fetch the previous page
    def first_vrn
      data['firstVrn']
    end

    # Returns VRN used to fetch the next page
    def last_vrn
      data['lastVrn']
    end

    # Checks if all dates was already paid
    def all_days_unpaid?
      return false unless results

      (results.map { |value| value['paidDates'] }).flatten.empty?
    end

    # Check if any results are present?
    def any_results?
      results.present?
    end

    private

    # Attributes reader
    attr_reader :data

    # Returns a hash with +results+ data
    def results
      data.dig('chargeableAccountVehicles', 'results')
    end
  end
end
