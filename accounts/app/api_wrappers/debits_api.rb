# frozen_string_literal: true

##
# API wrapper for connecting to Payments API.
# Wraps methods regarding Direct Debits management.
# See {PaymentsApi}[rdoc-ref:PaymentsApi] for user related actions.
#
# rubocop:disable Metrics/ParameterLists
class DebitsApi < PaymentsApi
  class << self
    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates/:zone_id+ endpoint with +GET+ method
    # and returns a list of account's Direct Debit mandates assigned to selected Clean Air Zone.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +zone_id+ - requested page of the results
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +mandates+ - array, list of the mandates
    #   * +id+ - uuid, mandate ID
    #   * +status+ - string, status of the mandate eg. 'active'
    #
    def caz_mandates(account_id:, zone_id:)
      log_action('Getting clean air zone mandates')

      request(
        :get,
        "/payments/accounts/#{account_id}/direct-debit-mandates/#{zone_id}"
      )['mandates']
    end

    ##
    # Calls +/v1/payments/direct-debit-payments+ endpoint with +POST+ method
    # which triggers the payment creation and returns details of the payment.
    #
    # ==== Attributes
    #
    # * +caz_id+ - ID of the selected CAZ
    # * +account_id+ - ID of the account associated with the fleet
    # * +user_id+ - ID of the users account from which the payment is being done.
    # * +mandate_id+ - ID of active mandate
    # * +user_email+ - Email of the user who is making the payment.
    # * +transactions+ - array of objects
    #   * +vrn+ - Vehicle registration number
    #   * +travel_date+ - Date of the single transaction
    #   * +tariff_code+ - tariff code used for calculations
    #   * +charge+ - transaction charge value (daily charge)
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +paymentId+ - uuid, ID of the payment created in GovUK.Pay
    # * +referenceNumber+ - integer, central reference number of the payment
    # * +externalPaymentId+ - string, external identifier for the payment
    #
    def create_payment(caz_id:, account_id:, user_id:, mandate_id:, user_email:, transactions:)
      log_action('Creating direct debit payment')

      body = payment_creation_body(
        account_id: account_id,
        caz_id: caz_id,
        user_id: user_id,
        user_email: user_email,
        mandate_id: mandate_id,
        transactions: transactions
      )
      request(:post, '/direct-debit-payments', body: body.to_json)
    end

    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates+ endpoint with +GET+ method
    # and returns a list of clean air zones with the associated Direct Debit mandates.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +cleanAirZones+ - array, list of the CAZ's
    #   * +cazId+ - uuid, CleanAirZone ID
    #   * +cazName+ - string, name of the CAZ
    #   * +mandates+ - array, list of the mandates
    #     * +id+ - uuid, mandate ID
    #     * +status+ - string, status of the mandate eg. 'active'
    #
    def mandates(account_id:)
      request(:get, "/payments/accounts/#{account_id}/direct-debit-mandates")['cleanAirZones']
    end

    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates+ endpoint with +POST+ method
    # which triggers the Direct Debit creation and returns hash with +nextUrl+.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +caz_id+ - uuid, ID of the CAZ
    # * +return_url+ - URL where GoCardless should redirect after the payment is done
    # * +session_id+ - actively logged in user's session token
    # * +account_user_id+ - uuid, id of the user account
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +nextUrl+ - string, path where user should be redirected
    #
    def create_mandate(account_id:, caz_id:, return_url:, session_id:, account_user_id:)
      log_action('Adding a mandate to account')

      body = {
        cleanAirZoneId: caz_id,
        returnUrl: return_url,
        sessionId: session_id,
        accountUserId: account_user_id
      }.to_json
      request(:post, "/payments/accounts/#{account_id}/direct-debit-mandates", body: body)
    end

    # Calls +/v1/payments/direct_debit_redirect_flows/:flowId/complete+ endpoint with +POST+ method which
    # returns the status of mandate creation
    #
    # ==== Attributes
    #
    # * +sessionToken+ - the session token of the actively logged in user, e.g. 'a724ed38b864e7490c91f9c06142ef9a'
    # * +cleanAirZoneId+ - UUID of the Clean Air Zone for which the mandate is being create
    #
    # ==== Result
    #
    #  Returns an empty body
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - sessionToken do not match with session ID returned by GoCardless
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid data or payment has not yet completed
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def complete_mandate_creation(flow_id:, session_id:, caz_id:)
      log_action('Finalising mandate creation')

      body = { sessionToken: session_id, cleanAirZoneId: caz_id }.to_json
      request(
        :post,
        "/payments/direct_debit_redirect_flows/#{flow_id}/complete",
        body: body
      )
    end

    private

    # Returns parsed JSON of the payment creation parameters with proper keys
    def payment_creation_body(account_id:, caz_id:, user_id:, user_email:, mandate_id:, transactions:)
      {
        account_id: account_id,
        clean_air_zone_id: caz_id,
        user_id: user_id,
        user_email: user_email,
        mandate_id: mandate_id,
        transactions: transactions
      }.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
  end
end
# rubocop:enable Metrics/ParameterLists
