# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the detailed payment history
  #
  class Details
    include ::TimeZoneHelper
    # Initializer method.
    #
    # ==== Params
    # * +payment_id+ - Payment ID from backend DB
    #
    def initialize(payment_id)
      @payment_id = payment_id
    end

    # Returns a sorted by vrn PaymentHistory::DetailsPayment with payments associated with the account
    # and sort alphabetically by vrn
    def payments
      result = api_call['lineItems'].group_by { |key| key['vrn'] }
      result.map { |payment| PaymentHistory::DetailsPayment.new(vrn: payment.first, items: payment.second) }
            .sort_by(&:vrn)
    end

    # payment made by
    def payer_name
      api_call['payerName']
    end

    # date of payment, e.g.'Sunday 26 July 2020'
    def date
      Date.parse(api_call['paymentDate']).strftime('%A %d %B %Y')
    end

    # payment reference number
    def reference
      api_call['centralPaymentReference']
    end

    # provider payment id
    def provider_payment_id
      api_call['paymentProviderId']
    end

    # Returns an array of PaymentsHistory::PaymentModification model instances
    def payment_modifications
      group_by_dates = api_call['modificationHistory'].group_by do |e|
        parse_utc_date(e['modificationTimestamp']).in_time_zone.strftime('%A %d %B %Y')
      end
      group_by_types(group_by_dates)
    end

    private

    # Reader for Payment ID from backend DB
    attr_reader :payment_id

    # Calls the api go get all payment details
    def api_call
      @api_call ||= PaymentHistoryApi.payment_details(payment_id: payment_id)
    end

    # Group payment modification items by type and create
    # `PaymentsHistory::PaymentModification` instances
    def group_by_types(group_by_dates) # rubocop:disable Metrics/MethodLength
      group_by_dates.map do |day, modifications|
        {
          day =>
            {
              'refunds' => prepare_payment_modification(modifications.select do |e|
                e['entrantPaymentStatus'] == 'REFUNDED'
              end),
              'charges_back' => prepare_payment_modification(modifications.select do |e|
                e['entrantPaymentStatus'] == 'CHARGEBACK'
              end)
            }
        }
      end
    end

    # Prepare payment modifications items with proper data format and sort alphabetically by vrn
    def prepare_payment_modification(data)
      data.sort_by { |e| e['vrn'] }.map do |payment_modification|
        PaymentHistory::PaymentModification.new(payment_modification)
      end
    end
  end
end
