# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+.
# It's purpose is to be similar to +ComplianceDetails+ class
class NonUkCompliantVehicleDetails
  include ComplianceDetailsBase
  ##
  # Creates an instance of a class
  #
  # ==== Attributes
  #
  # * +caz_data+ - hash
  #
  def initialize(caz_data)
    @caz_data = caz_data
  end

  # Name of the Clean Air Zone
  # Returns a string, e.g. 'Birmingham'
  def zone_name
    caz_data['name']
  end

  # Stub for .charged? attribute which states if vehicle is chargeable;
  # Compliant non-uk vehicles are not chargeable.
  def charged?
    false
  end

  # Stub for .charge attribute which states how much vehicle is supposed to be charged.
  # Compliant non-uk vehicles are not chargeable.
  def charge
    0
  end

  # Stub for .charge attribute which states how much vehicle is supposed to be charged.
  # Compliant non-uk vehicles are not chargeable.
  def charge_amount
    0
  end

  # Returns a string, e.g. 'www.example.com'
  def main_info_url
    caz_data['mainInfoUrl']
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data['boundaryUrl']
  end

  # Returns a string, eg. 'www.example.com'
  def exemption_or_discount_url
    caz_data['exemptionUrl']
  end

  # Returns a string, eg. 'Bath and North East Somerset Council'
  def operator_name
    caz_data['operatorName']
  end

  private

  attr_reader :caz_data
end
