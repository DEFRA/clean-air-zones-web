# frozen_string_literal: true

##
# This class wraps calls being made to the Payments backend API which is proxied to VCCS backend API.
# The base URL for the calls is configured by +PAYMENTS_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
#
class ComplianceCheckerApi < BaseApi
  base_uri "#{ENV.fetch('PAYMENTS_API_URL', 'localhost:3001')}/v1/payments"

  class << self
    ##
    # Calls +/v1/payments/vehicles/:vrn/details+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.vehicle_details('0009-AA')
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +registrationNumber+
    # * +type+ - string, eg. 'car'
    # * +make+ - string, eg. 'Audi'
    # * +colour+ - string, eg. 'red'
    # * +fuelType+ - string, eg. 'diesel'
    # * +taxiOrPhv+ - boolean, determines if the vehicle is a taxi or a PHV
    # * +licensingAuthoritiesNames+ - array of strings, list of LA where vehicle is registered as a taxi
    # * +exempt+ - boolean, determines if the vehicle is exempt from charges
    #
    # ==== Serialization
    #
    # {Vehicle details model}[rdoc-ref:VehiclesManagement::VehicleDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vehicle_details(vrn)
      log_action('Getting vehicle details')
      request(:get, "/vehicles/#{vrn}/details")
    end

    ##
    # Calls +/v1/payments/clean-air-zones+ endpoint with +GET+ method
    # and returns the list of available Clean Air Zones.
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.clean_air_zones
    #
    # ==== Result
    #
    # Each returned CAZ will have following fields:
    # * +name+ - string, eg. "Birmingham"
    # * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
    # * +boundaryUrl+ - URL, this represents a link to eg. a map with CAZ boundaries
    #
    # ==== Serialization
    #
    # {Caz model}[rdoc-ref:Caz] can be used to create an instance of Clean Air Zone
    #
    # ==== Exceptions
    #
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def clean_air_zones
      log_action('Getting clean air zones')
      request(:get, '/clean-air-zones')['cleanAirZones']
    end
  end
end
