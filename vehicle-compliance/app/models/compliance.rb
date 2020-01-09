# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+.
class Compliance
  ##
  # Initializer method.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +zones+ - array, eg. '["39e54ed8-3ed2-441d-be3f-38fc9b70c8d3"]'
  def initialize(vrn, zones)
    @vrn = vrn
    @zones = zones
  end

  # Creates an array of 'ComplianceDetails' objects.
  #
  # ==== Result
  #
  # Returns a array of objects with following fields:
  # * +clean_air_zone_id+ - UUID, this represents CAZ ID in the DB
  # * +name+ - string, eg. 'Birmingham'
  # * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
  # * +information_urls+ - object containing CAZ dedicated info links
  #   * +emissions_standards+
  #   * +main_info+
  #   * +hours_of_operation+
  #   * +pricing+
  #   * +exemption_or_discount+
  #   * +pay_caz+
  #   * +become_compliant+
  #   * +financial_assistance+
  #   * +boundary+
  def compliance_outcomes
    @compliance_outcomes ||= compliance_api['complianceOutcomes'].map do |v|
      ComplianceDetails.new(v)
    end
  end

  private

  # Reader function for the vehicle registration number
  attr_reader :vrn

  ##
  # Calls +/v1/compliance-checker/vehicles/:vrn/compliance+ endpoint with +GET+ method
  # and returns compliance details of the requested vehicle for requested zones.
  #
  # ==== Result
  #
  # Returned compliance details will have following fields:
  # * +registrationNumber+ - string, eg. 'CAS310'
  # * +retrofitted+ - boolean
  # * +exempt+ - boolean, determines if the vehicle is exempt from charges
  # * +complianceOutcomes+ - array of objects
  #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
  #   * +name+ - string, eg. 'Birmingham'
  #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
  #   * +informationUrls+ - object containing CAZ dedicated info links
  #     * +emissionsStandards+
  #     * +mainInfo+
  #     * +hoursOfOperation+
  #     * +pricing+
  #     * +exemptionOrDiscount+
  #     * +payCaz+
  #     * +becomeCompliant+
  #     * +financialAssistance+
  #     * +boundary+
  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_compliance(vrn, @zones)
  end
end
