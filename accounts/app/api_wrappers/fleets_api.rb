# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi::Base
  class << self
    ##
    # Calls +/v1/accounts/register-csv-from-s3/jobs+ endpoint with +POST+ method
    # and returns a job UUID
    #
    # ==== Attributes
    #
    # * +filename+ - Csv file name, eg. 'fleet_email@example.com_1579778166'
    # * +correlation_id+ - Correlation id, eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    # * +large_fleet+ - large fleet status for pending job, e.g. false
    #
    # ==== Example
    #
    #    FleetsApi.register_job(
    #       filename: 'fleet_email@example.com_1579778166',
    #       correlation_id: '98faf123-d201-48cb-8fd5-4b30c1f80918',
    #       large_fleet: false
    #    )
    #
    # ==== Result
    #
    # Returns a UUID, eg. '2ad47f86-8365-47ee-863b-dae6dbf69b3e'.
    #
    def register_job(filename:, correlation_id:, large_fleet:)
      log_action('Registering a new upload job')
      request(
        :post,
        '/accounts/register-csv-from-s3/jobs',
        body: {
          'filename' => filename,
          's3Bucket' => ENV.fetch('S3_AWS_BUCKET', 'S3_AWS_BUCKET'),
          'successEmail' => large_fleet
        }.to_json, headers: custom_headers(correlation_id)
      )['jobName']
    end

    ##
    # Calls +/v1/accounts/register-csv-from-s3/jobs/:job_name+ endpoint with +GET+ method
    # and returns a job status and job errors.
    #
    # ==== Attributes
    #
    # * +job_id+ - Job id returned in register_job call, eg '2ad47f86-8365-47ee-863b-dae6dbf69b3e'
    # * +correlation_id+ - Correlation id (same as in register_job call), eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #
    # ==== Example
    #
    #    FleetsApi.job_status(
    #       job_name: '2ad47f86-8365-47ee-863b-dae6dbf69b3e',
    #       correlation_id: '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #    )
    #
    # ==== Result
    #
    # Returns a hash
    # * success - { status: 'SUCCESS', errors: [] }
    # * failure - { status: 'FAILURE', errors: ['Invalid VRN'] }
    #
    def job_status(job_id:, correlation_id:)
      log_action('Getting job status')
      request(
        :get,
        "/accounts/register-csv-from-s3/jobs/#{job_id}",
        headers: custom_headers(correlation_id)
      ).symbolize_keys
    end

    ##
    # Calls +/v1/accounts/:account_id/vehicles+ endpoint with +POST+ method to add the vehicle to the fleet.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +vehicle_type+ - caz vehicle type of the new vehicle
    # * +vrn+ - registration umber of the new vehicle
    #
    # ==== Example
    #
    #    FleetApi.add_vehicle_to_fleet(account_id: '1f30838f-69ee-4486-95b4-7dfcd5c6c67c', vehicle_type: 'CAR', vrn: 'CAS315')
    #
    # ==== Result
    #
    # Returns true.
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def add_vehicle_to_fleet(vrn:, vehicle_type:, account_id:)
      log_action('Adding a new VRN to the fleet')
      body = { vrn: vrn, cazVehicleType: vehicle_type }.to_json
      request(:post, "/accounts/#{account_id}/vehicles", body: body)
      true
    end

    ##
    # Calls +/v1/accounts/:account_id/vehicles/:vrn+ endpoint with +DELETE+ method to remove the vehicle from the fleet.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +vrn+ - registration umber of the new vehicle
    #
    # ==== Example
    #
    #    FleetApi.remove_vehicle_from_fleet(
    #       account_id: '1f30838f-69ee-4486-95b4-7dfcd5c6c67c',
    #       vrn: 'CAS315'
    #    )
    #
    # ==== Result
    #
    # Returns true.
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def remove_vehicle_from_fleet(vrn:, account_id:)
      log_action('Removing vehicles from the fleet')
      request(:delete, "/accounts/#{account_id}/vehicles/#{vrn}")
      true
    end

    ##
    # Calls +/v1/accounts/:account_id/vehicles+ endpoint with +GET+ method
    # and returns paginated list of the fleet vehicles with compliance results.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +only_chargeable+ - flag, to filter out non-charged vehicles
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +vehicles+ - list of the vehicles
    # * +pageCount+ - number of available pages
    # * +totalVehiclesCount+ - total number of vehicles in the fleet
    # * +anyUndeterminedVehicles+ - indicates if any of the vehicles is undetermined
    #
    # ==== Serialization
    #
    # {VehiclesManagement::PaginatedFleet model}[rdoc-ref:VehiclesManagement::PaginatedFleet]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vehicles(account_id:, page:, per_page:, only_chargeable: false, vrn: nil)
      log_action('Getting vehicles')
      query = {
        'pageNumber' => calculate_page_number(page),
        'pageSize' => per_page,
        'onlyChargeable' => only_chargeable,
        'query' => vrn
      }.compact
      request(:get, "/accounts/#{account_id}/vehicles", query: query)
    end
  end
end
