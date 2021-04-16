# frozen_string_literal: true

##
# API wrapper for connecting to Payments API.
#
class PaymentsApi < BaseApi
  base_uri "#{ENV.fetch('PAYMENTS_API_URL', 'localhost:3001')}/v1"

  class << self
    ##
    # Calls +/v1/accounts/:account_id/chargeable-vehicles+ endpoint with +GET+ method
    # and returns paginated list of the fleet vehicles with compliance results.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +zone_id+ - ID of the CAZ associated with the fleet
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +vrn+ - vehicle registration number, search parameter
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +chargeableAccountVehicles+ - list of the vehicles
    # * +pageCount+ - number of available pages
    # * +totalVehiclesCount+ - total number of vehicles in the fleet
    # * +anyUndeterminedVehicles+ - indicates if any of the vehicles is undetermined
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def chargeable_vehicles(account_id:, zone_id:, page:, per_page:, vrn:)
      query = chargeable_vehicles_body(zone_id, page, per_page, vrn)
      request(:get, "/accounts/#{account_id}/chargeable-vehicles", query: query)
    end

    ##
    # Calls +/v1/payments+ endpoint with +POST+ method which triggers the payment creation
    # and returns details of the requested vehicles.
    #
    # ==== Attributes
    #
    # * +caz_id+ - ID of the selected CAZ
    # * +return_url+ - URL where GOV.UK Pay should redirect after the payment is done.
    # * +user_id+ - ID of the users account from which the payment is being done.
    # * +transactions+ - array of objects
    #   * +vrn+ - Vehicle registration number
    #   * +travel_date+ - Date of the single transaction
    #   * +tariff_code+ - tariff code used for calculations
    #   * +charge+ - transaction charge value (daily charge)
    #
    # ==== Example
    #
    #    PaymentsApi.create_payment(
    #      caz_id: '86b64512-154c-4033-a64d-92e8ed19275f,
    #      return_url: 'http://example.com',
    #      user_id: 'a3053ff1-34a3-400e-bd32-165e90a46276',
    #      transactions: [
    #        {
    #          vrn: 'CAS123',
    #          travel_date: '2020-03-10',
    #          tariff_code: 'BCC01-private_car',
    #          charge: '10'
    #        }
    #      ]
    #    )
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +paymentId+ - uuid, ID of the payment created in GovUK.Pay
    # * +nextUrl+ - URL, url returned by GovUK.Pay to proceed the payment
    #
    # ==== Exceptions
    #
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid data
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def create_payment(caz_id:, return_url:, user_id:, transactions:)
      log_action('Creating payment')
      body = payment_creation_body(
        caz_id: caz_id,
        return_url: return_url,
        user_id: user_id,
        transactions: transactions
      )
      request(:post, '/payments', body: body.to_json)
    end

    # Calls +/v1/payments/:id+ endpoint with +PUT+ method which returns details of the payment.
    #
    # ==== Attributes
    #
    # * +payment_id+ - Payment ID returned by backend API during the payment creation
    # * +caz_name+ - the name of the Clean Air Zone for which the payment is being made
    #
    # ==== Example
    #
    #    PaymentsApi.payment_status(payment_id: '86b64512-154c-4033-a64d-92e8ed19275f',
    #                               caz_name: 'Birmingham')
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +referenceNumber+ - integer, central reference number of the payment
    # * +externalPaymentId+ - string, external identifier for the payment
    # * +status+ - string, status of the payment eg. "success"
    # * +userEmail+ - email, email submitted by the user during the payment process
    #
    # ==== Serialization
    #
    # {Payments::Status model}[rdoc-ref:Payments::Status]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - payment not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def payment_status(payment_id:, caz_name:)
      log_action("Getting a payment status with id: #{payment_id}")
      request(:put, "/payments/#{payment_id}", body: payment_status_body(caz_name))
    end

    private

    # Returns parsed JSON of the payment creation parameters with proper keys
    def payment_creation_body(caz_id:, return_url:, user_id:, transactions:)
      {
        clean_air_zone_id: caz_id,
        return_url: return_url,
        user_id: user_id,
        transactions: transactions,
        telephone_payment: false
      }.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end

    # Returns parsed JSON of the payment status reconciliation parameters with proper keys
    def payment_status_body(caz_name)
      { cleanAirZoneName: caz_name }.to_json
    end

    # Returns parsed JSON with proper keys
    def chargeable_vehicles_body(zone_id, page, per_page, vrn)
      {
        'cleanAirZoneId' => zone_id,
        'pageNumber' => calculate_page_number(page),
        'pageSize' => per_page,
        'query' => vrn&.upcase
      }.compact
    end
  end
end
