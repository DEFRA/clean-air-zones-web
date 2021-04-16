# frozen_string_literal: true

##
# This class represents data returned by {NTR API endpoint}[rdoc-ref:VehiclesCheckerApi.licence_info_historical]
# and is used to display data in +app/views/vehicles/historic_search.html.haml+.
class HistoricalVrnDetails
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all spaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +page+ - string, used to paginate the changes list for vehicle
  # * +start_date+ - string, date format, eg '2010-01-01'
  # * +end_date+ - string, date format, eg '2020-03-24'
  #
  def initialize(vrn, page, start_date, end_date)
    @vrn = vrn.upcase.gsub(/\s+/, '')
    @page = page.to_i
    @start_date = start_date
    @end_date = end_date
  end

  # Checks if there are any entries in the +changes+ array
  def changes_empty?
    whitelist_api['changes'].empty?
  end

  # Checks if +totalChangesCount+ is not a zero
  def total_changes_count_zero?
    whitelist_api['totalChangesCount'].zero?
  end

  # Returns a paginated vrn history with all changes.
  # Includes data about page and total pages count.
  def pagination
    @pagination ||= PaginatedVrnHistory.new(whitelist_api)
  end

  # Parses start_date to expected format (e.g. '10/03/2020')
  def parsed_start_date
    parse_date(start_date)
  end

  # Parses end_date to expected format (e.g. '14/03/2020')
  def parsed_end_date
    parse_date(end_date)
  end

  private

  attr_reader :vrn, :page, :start_date, :end_date

  # Calls api and returns paginated list of vehicle's information
  def whitelist_api
    @whitelist_api ||= WhitelistApi.whitelist_info_historical(
      vrn: vrn,
      page: page,
      start_date: start_date,
      end_date: end_date
    )
  end

  def parse_date(date)
    Date.parse(date).strftime('%d/%m/%Y')
  end
end
