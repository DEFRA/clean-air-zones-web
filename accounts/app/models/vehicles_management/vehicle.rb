# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Represents the virtual model of the vehicle.
  #
  class Vehicle
    # Initializer method.
    #
    # ==== Params
    # * +data+ - hash
    #    * +registrationNumber+ - string, vehicle registration number
    #    * +vehicleType+ - string, type of the vehicle
    #    * +isExempt+ - boolean, set if vehicle is exempt
    #    * +complianceOutcomes+ - array of hashes
    #       * +cleanAirZoneId+ - UUID, ID of the CAZ
    #       * +charge+ - float, charge for given CAZ
    #       * +tariffCode+ - string, tariff that was used for calculations
    #
    def initialize(data)
      @data = data
    end

    # Returns vehicle's registration number
    def vrn
      data['vrn']
    end

    # Returns vehicle's type
    def type
      (data['vehicleType'] || 'undetermined').humanize
    end

    # Returns if vehicle is exempt
    def exempt
      data['isExempt']
    end

    # Returns the charge for given CAZ in float
    def charge(caz_id)
      cached_charge = data['cachedCharges'].find { |res| res['cazId'] == caz_id }
      return nil if cached_charge.blank? || cached_charge['charge'].blank?

      cached_charge['charge'].to_f
    end

    # Returns the parsed charge for given CAZ
    # Returns 'Unknown' if the charge is undefined.
    # Returns 'No charge' if the charge equals zero
    def formatted_charge(caz_id)
      return 'Exempt' if exempt

      charge = charge(caz_id)
      return 'Undetermined' unless charge

      return 'No charge' if charge.zero?

      return "£#{charge.to_i}" if (charge % 1).zero?

      "£#{format('%<pay>.2f', pay: charge)}"
    end

    private

    # Reader for data hash
    attr_reader :data
  end
end
