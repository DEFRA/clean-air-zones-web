# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Class used to display chargeable vehicles on the matrix page
  #
  class PaginatedVehicles
    # Attributes reader
    attr_reader :per_page, :page

    # Take data returned from the FleetsApi.vehicles
    def initialize(data, page, per_page)
      @data = data
      @page = page
      @per_page = per_page
    end

    # Returns an array of Payments::Vehicle model instances
    def vehicle_list
      @vehicle_list ||= (results || []).map { |vehicle_data| Payments::Vehicle.new(vehicle_data) }
    end

    # Returns the number of available pages
    def total_pages
      data['pageCount']
    end

    # Returns the total number of vehicles in the fleet
    def total_vehicles_count
      data['totalVehiclesCount']
    end

    # Returns the index of the first vehicle on the page
    def range_start
      page * per_page - (per_page - 1)
    end

    # Returns the index of the last vehicle on the page
    def range_end
      max = page * per_page
      max > total_vehicles_count ? total_vehicles_count : max
    end

    # Checks if all dates was already paid
    def all_days_unpaid?
      return false unless results

      (results.map { |value| value['paidDates'] }).flatten.empty?
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
