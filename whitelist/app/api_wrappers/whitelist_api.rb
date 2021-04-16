# frozen_string_literal: true

##
# This class wraps calls being made to the Whitelist backend API.
# The base URL for the calls is configured by +WHITELIST_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
class WhitelistApi < BaseApi
  base_uri "#{ENV.fetch('WHITELIST_API_URL', 'localhost:3001')}/v1/whitelisting/vehicles"

  headers(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

  class << self
    ##
    # Calls +/v1/whitelisting/vehicles/:vrn+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +vrn+ - string, eg. 'CU12345'
    # * +manufacturer+ - string, eg. 'ZAZ'
    # * +category+ - string, eg. 'Early Adopter'
    # * +reasonUpdated+ - string, eg. 'Testing'
    # * +email+ - string, eg. 'example@email.com'
    # * +uploaderId+ - string, eg. '3fa85f64-5717-4562-b3fc-2c963f66afa6'
    # * +updateTimestamp+ - date
    #
    # ==== Serialization
    #
    # {Vehicle details model}[rdoc-ref:VrnDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vrn_details(vrn)
      log_action('Getting vehicle details')
      request(:get, "/#{vrn}")
    end

    ##
    # Calls +/v1/whitelisting/vehicles endpoint with +POST+ method
    # to add the vehicle to the whitelisting.
    #
    # ==== Attributes
    #
    # * +vrn+ - string, eg. 'CU12345'
    # * +manufacturer+ - string, eg. 'ZAZ'
    # * +category+ - string, eg. 'Early Adopter'
    # * +reasonUpdated+ - string, eg. 'Testing'
    # * +email+ - string, eg. 'example@email.com'
    # * +uploaderId+ - string, eg. '3fa85f64-5717-4562-b3fc-2c963f66afa6'
    #
    # ==== Result
    #
    # Returns true.
    #
    # ==== Serialization
    #
    # {Vehicle details model}[rdoc-ref:VrnDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def add_vrn(vrn_details, current_user)
      log_action('Adding a new vrn')

      body = {
        vrn: vrn_details[:vrn],
        category: vrn_details[:category],
        manufacturer: vrn_details[:manufacturer],
        reasonUpdated: vrn_details[:reason],
        email: current_user.username,
        uploaderId: current_user.preferred_username
      }.to_json

      request(:post, '', body: body)
    end

    ##
    # Calls +/v1/whitelisting/vehicles/:vrn+ endpoint with +DELETE+ method
    # to delete the vehicle from the whitelisting.
    #
    # ==== Attributes
    #
    # * +vrn+ - string, eg. 'CU12345'
    # * +user_uuid+ - UUID of Cognito `sub` of a user
    # * +user_email+ - string, eg. 'example@email.com'
    #
    # ==== Additional header
    # * +X-Modifier-ID+ - UUID of Cognito `sub` of a user that is making a deleting
    #
    # ==== Result
    #
    # Returns true
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def delete_vrn(vrn, user_uuid, user_email)
      log_action('Deleting a vrn')

      request(:delete, "/#{vrn}",
              headers: {
                'X-Modifier-ID' => user_uuid,
                'X-Modifier-Email' => user_email
              })
    end

    ##
    # Calls +/v1/vehicles/:vrn/whitelist-info-historical+ endpoint with +GET+ method
    # and returns paginated list of vehicle's information
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number, eg. 'CU12345'
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +start_date+ - string, date format, eg '2010-01-01'
    # * +end_date+ - string, date format, eg '2020-03-24'
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +page+ - number of available pages
    # * +pageCount+ - number of available pages
    # * +perPage+ - number of available pages
    # * +totalChangesCount+ - integer, the total number of changes associated with this vehicle
    # * +changes+ - array of objects, history of changes for current vrn
    #   * +modifyDate+ - string, date format
    #   * +action+ - string, status of current VRM for a specific date range
    #   * +category+ - string, eg. 'Early Adopter'
    #   * +manufacturer+ - string, eg. 'ZAZ'
    #   * +reasonUpdated+ - string, eg. 'Testing'
    #   * +uploaderId+ - string, eg. '3fa85f64-5717-4562-b3fc-2c963f66afa6'
    #
    def whitelist_info_historical(vrn:, page:, start_date:, end_date:, per_page: 10)
      log_action("Getting the historical details for page: #{page}, start_date: #{start_date}"\
               " and end_date: #{end_date}")

      query = {
        'pageNumber' => calculate_page_number(page),
        'pageSize' => per_page,
        'startDate' => start_date,
        'endDate' => end_date
      }

      request(:get, "/#{vrn}/whitelist-info-historical", query: query)
    end

    ##
    # Calls +/v1/whitelisting/vehicles/csv_exports endpoint with +POST+ method
    # to generate a CSV file and save it on S3 and then returns +fileUrl+ .
    #
    #
    # ==== Result
    #
    # {
    #   "fileUrl": "https://s3.eu-west-2.amazonaws.com/csv-export-bucket/generated-file.csv",
    #   "bucketName": "csv-export-bucket"
    # }
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - bad request
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def csv_exports
      log_action('Downloading a csv file')
      request(:post, '/csv-exports')['fileUrl']
    end

    private

    # escape negative page number
    def calculate_page_number(page)
      result = page - 1
      result.negative? ? 0 : result
    end
  end
end
