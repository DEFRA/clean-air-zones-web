# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+.
class ComplianceDetails
  include ComplianceDetailsBase
  ##
  # Creates an instance of a class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +details+ - hash
  # * +retrofit+ - boolean
  #
  # ==== Result
  #
  # Returns
  # * A boolean retrofit indicating whether the vehicle is retrofitted
  # * A hash with following fields:
  #   * +clean_air_zone_id+ - UUID, this represents CAZ ID in the DB
  #   * +name+ - string, eg. 'Birmingham'
  #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
  #   * +information_urls+ - object containing CAZ dedicated info links
  #     * +main_info+
  #     * +public_transport_options+
  #     * +exemption_or_discount+
  #     * +become_compliant+
  #     * +boundary+
  def initialize(details, retrofit)
    @compliance_data = details.deep_transform_keys { |key| key.underscore.to_sym }
    @retrofit = retrofit
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

  # Returns charge amount
  def charge_amount
    compliance_data[:charge].to_f
  end

  # Returns a string, eg. 'www.example.com'.
  def main_info_url
    url(:main_info)
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    url(:boundary)
  end

  # Returns a string, eg. 'www.example.com'.
  def exemption_or_discount_url
    url(:exemption_or_discount)
  end

  # Returns a string, eg. 'Bath and North East Somerset'.
  def operator_name
    compliance_data[:operator_name]
  end

  # Returns a string, eg. 'www.example.com'.
  def public_transport_options_url
    url(:public_transport_options)
  end

  # Returns a string, eg. 'www.example.com'.
  def become_compliant_url
    url(:become_compliant)
  end

  private

  # Retrieves the value object corresponding to the 'name' attribute
  #
  # ==== Attributes
  #
  # * +name+ - symbol, eg. ':main_info'
  #
  # ==== Result
  #
  # Returns a string, eg. 'www.example.com'.
  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  attr_reader :compliance_data
end
