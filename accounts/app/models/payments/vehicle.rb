# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Represents the virtual model of the vehicle from PaymentsApi.chargeable_vehicles endpoint.
  #
  class Vehicle
    # Initializer method.
    #
    # ==== Params
    # * +data+ - hash
    #    * +vrn+ - string, vehicle registration number
    #    * +charge+ - float, charge for given CAZ
    #    * +tariffCode+ - string, tariff that was used for calculations
    #    * +paidDates+ - an array of dates that were already paid
    #
    def initialize(data)
      @data = data
    end

    # Returns vehicle's registration number
    def vrn
      data['vrn']
    end

    # Returns the charge for given CAZ in float
    def charge
      data['charge']
    end

    # Return a tariff code
    def tariff
      data['tariffCode']
    end

    # Returns an array of dates in '%Y-%m-%d' format
    def paid_dates
      data['paidDates'] || []
    end

    # Returns a hash with proper data
    def serialize
      {
        vrn: vrn,
        tariff: tariff,
        charge: charge,
        dates: []
      }
    end

    private

    # Reader for data hash
    attr_reader :data
  end
end
