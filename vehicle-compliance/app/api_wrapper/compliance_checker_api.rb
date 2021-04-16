# frozen_string_literal: true

##
# This class wraps calls being made to the VCCS backend API.
# The base URL for the calls is configured by +COMPLIANCE_CHECKER_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
class ComplianceCheckerApi < BaseApi
  base_uri "#{ENV.fetch('COMPLIANCE_CHECKER_API_URL', 'localhost:3001')}/v1/compliance-checker"
  headers('Content-Type' => 'application/json', 'X-Correlation-ID' => -> { SecureRandom.uuid })

  class << self
    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/details+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
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
    # * +exempt+ - boolean, determines if the vehicle is exempt from charges
    #
    # ==== Serialization
    #
    # {Vehicle details model}[rdoc-ref:VehicleDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vehicle_details(vrn)
      log_action 'Making request for vehicle details with VRN'
      request(:get, "/vehicles/#{vrn}/details")
    end

    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/compliance+ endpoint with +GET+ method
    # and returns compliance details of the requested vehicle for all zones.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.vehicle_compliance('0009-AA')
    #
    # ==== Result
    #
    # Returned compliance details will have following fields:
    # * +registrationNumber+
    # * +isRetrofitted+ - boolean
    # * +exempt+ - boolean, determines if the vehicle is exempt from charges
    # * +complianceOutcomes+ - array of objects
    #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
    #   * +name+ - string, eg. "Birmingham"
    #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
    #   * +phgvDiscountAvailable+ - True if the vehicle's tax class is equal to PRIVATE HGV and body type is equal to either MOTOR HOME/CARAVAN or LIVESTOCK CARRIER
    #   * +informationUrls+ - object containing CAZ dedicated info links
    #     * +mainInfo+
    #     * +exemptionOrDiscount+
    #     * +becomeCompliant+
    #     * +boundary+
    #
    # ==== Serialization
    #
    # {Compliance model}[rdoc-ref:Compliance]
    # can be used to wrap the call and
    # {Compliance details model}[rdoc-ref:ComplianceDetails]
    # for each zone.
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vehicle_compliance(vrn)
      log_action 'Making request for vehicle compliance in all zones'
      request(:get, "/vehicles/#{vrn}/compliance")
    end

    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/register-details endpoint with +GET+ method
    # and returns information about vehicle existence on specific registers.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.register_details('0009-AA')
    #
    # ==== Result
    #
    # Returned response will have the following attributes:
    # * +registerCompliant+ - boolean, states if vehicle features in Retrofit or is compliant in GPW
    # * +registerExempt+ - boolean, states if vehicle features in MOD or is exempt in GPW
    # * +registeredMOD+ - boolean, states if vehicle features in MOD
    # * +registeredGPW+ - boolean, states if vehicle features in GPW
    # * +registeredNTR+ - boolean, states if vehicle features in NTR
    # * +registeredRetrofit+ - boolean, states if vehicle features in Retrofit
    #
    # ==== Serialization
    #
    # {Register details model}[rdoc-ref:RegisterDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def register_details(vrn)
      log_action 'Making request for vehicle presence on specific registers'
      request(:get, "/vehicles/#{vrn}/register-details")
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
    # * +mainInfoUrl+ - URL, this represents a link to general info about CAZ
    # * +exemptionUrl+ - URL, this represents a link to information about exemptions
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
      log_action 'Getting clean air zones'
      request(:get, '/clean-air-zones')['cleanAirZones']
    end
  end
end
