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
  def initialize(vrn)
    @vrn = vrn
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
  #   * +main_info+
  #   * +public_transport_options+
  #   * +exemption_or_discount+
  #   * +become_compliant+
  #   * +boundary+
  def compliance_outcomes
    @compliance_outcomes ||= compliance_api['complianceOutcomes'].map do |v|
      ComplianceDetails.new(v, compliance_api['isRetrofitted'])
    end
    @compliance_outcomes.sort_by(&:zone_name)
  end

  # Method iterates over compliance outcomes and verifies if there's at least one
  # Clean Air Zone in which the vehicle should be charged.
  # Returns a boolean.
  def any_caz_chargeable?
    compliance_outcomes.any?(&:charged?)
  end

  # Checks if PHGV discount is available
  def phgv_discount_available?
    compliance_api['phgvDiscountAvailable']
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
  # * +isRetrofitted+ - boolean
  # * +exempt+ - boolean, determines if the vehicle is exempt from charges
  # * +complianceOutcomes+ - array of objects
  #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
  #   * +name+ - string, eg. 'Birmingham'
  #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
  #   * +informationUrls+ - object containing CAZ dedicated info links
  #     * +mainInfo+
  #     * +publicTransportOptions+
  #     * +exemptionOrDiscount+
  #     * +becomeCompliant+
  #     * +boundary+
  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_compliance(vrn)
  end
end
