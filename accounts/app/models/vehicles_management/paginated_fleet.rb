# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Class used to display fleet on the manage vehicles page
  #
  class PaginatedFleet
    # Attributes reader
    attr_reader :per_page, :page

    # Take data returned from the FleetsApi.vehicles
    def initialize(data, page, per_page)
      @data = data
      @page = page
      @per_page = per_page || 10
    end

    # Returns an array of VehiclesManagement::Vehicle model instances
    def vehicle_list
      @vehicle_list ||= data['vehicles'].map { |vehicle_data| VehiclesManagement::Vehicle.new(vehicle_data) }
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

    # Determinate how many per page options should show
    def results_per_page
      case total_vehicles_count
      when 11..20
        [10, 20]
      when 21..30
        [10, 20, 30]
      when 31..40
        [10, 20, 30, 40]
      else
        [10, 20, 30, 40, 50]
      end
    end

    private

    # Attributes reader
    attr_reader :data
  end
end
