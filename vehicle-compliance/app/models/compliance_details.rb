# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+.
class ComplianceDetails
  ##
  # Creates an instance of a class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +details+ - hash
  #
  # ==== Result
  #
  # Returns a hash with following fields:
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
  def initialize(details)
    @compliance_data = details.deep_transform_keys { |key| key.underscore.to_sym }
  end

  # Returns a string, eg. 'Birmingham'.
  def zone_name
    compliance_data[:name]
  end

  # Determines if the vehicle is should be charged.
  #
  # Returns a boolean
  def charged?
    compliance_data[:charge].to_f > 0.0
  end

  # Determines how much owner of the vehicle will have to pay in this CAZ.
  #
  # rubocop:disable Style/AsciiComments
  # Returns a string, eg. '£10.00'
  # rubocop:enable Style/AsciiComments
  def charge
    "£#{format('%<pay>.2f', pay: compliance_data[:charge].to_f)}"
  end

  # Returns a string, eg. 'www.example.com'.
  def main_info_url
    url(:main_info)
  end

  # Returns a string, eg. 'www.example.com'.
  def emissions_standards_url
    url(:emissions_standards)
  end

  # Returns a string, eg. 'www.example.com'.
  def pricing_url
    url(:pricing)
  end

  # Returns a string, eg. 'www.example.com'.
  def hours_of_operation_url
    url(:hours_of_operation)
  end

  # Returns a string, eg. 'www.example.com'.
  def exemption_or_discount_url
    url(:exemption_or_discount)
  end

  # Returns a string, eg. 'www.example.com'.
  def pay_caz_url
    url(:pay_caz)
  end

  # Returns a string, eg. 'www.example.com'.
  def become_compliant_url
    url(:become_compliant)
  end

  # Returns a string, eg. 'www.example.com'.
  def financial_assistance_url
    url(:financial_assistance)
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    url(:boundary)
  end

  # Returns a string, eg. 'Birmingham'.
  def html_id
    zone_name.delete(' ').underscore
  end

  private

  # Retrieves the value object corresponding to the 'name' attribute
  #
  # ==== Attributes
  #
  # * +name+ - symbol, eg. ':emissions_standards'
  #
  # ==== Result
  #
  # Returns a string, eg. 'www.example.com'.
  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  attr_reader :compliance_data
end
