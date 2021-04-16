# frozen_string_literal: true

##
# This class represents data returned by {Whitelist API endpoint}[rdoc-ref:WhitelistApi.vrn_details]
# and is used to display data in +app/views/vehicles/index.html.haml+.
class VrnDetails
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all spaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn&.delete(' ')&.upcase
  end

  # Returns a string, eg. 'CU57ABC'.
  def registration_number
    vrn
  end

  # returns a string, e.g. 'user@example.com'
  def email
    whitelist_api['email']
  end

  # returns string, e.g. 'Early Adopter'
  def category
    whitelist_api['category']
  end

  # returns string, e.g. 'ZAZ'
  def manufacturer
    whitelist_api['manufacturer']
  end

  # returns string, e.g. 'Testing'
  def reason_updated
    string_field('reasonUpdated')
  end

  # returns date, e.g. '22 - 06 - 2020'
  def update_timestamp
    string_field('updateTimestamp')
  end

  # returns formatted date, e.g. '3 March 2020''
  def formatted_timestamp
    Date.parse(update_timestamp).strftime('%-d %B %Y')
  end

  private

  # Reader function for the vehicle registration number
  attr_reader :vrn

  ##
  # Converts the first character of +key+ value to uppercase.
  #
  # ==== Attributes
  #
  # * +key+ - string, eg. 'type'
  #
  # ==== Result
  # Returns a nil if +key+ value is blank or equal to 'null'.
  # Returns a string, eg. 'Car' if +key+ value is present.
  # Returns a nil if +key+ value is not present.
  def string_field(key)
    return nil if whitelist_api[key].blank? || whitelist_api[key].downcase == 'null'

    whitelist_api[key]&.capitalize
  end

  def whitelist_api
    @whitelist_api ||= WhitelistApi.vrn_details(vrn)
  end
end
