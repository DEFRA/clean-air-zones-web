# frozen_string_literal: true

##
# Module used for payment history flow
module PaymentHistory
  ##
  # This class represents payment modifications data and is used to display data
  # in +app/views/payment_history/payment_history/payment_history_details.html.haml+.
  class PaymentModification
    include ::TimeZoneHelper
    ##
    # Creates an instance of a class
    #
    # ==== Attributes
    #
    # * +refund+ - hash of refund details
    #
    def initialize(data)
      @data = data
    end

    # Returns string, e.g. 'CU57ABC'
    def vrn
      data['vrn']
    end

    # Returns string, e.g. 'Friday 12 February 2021'
    def travel_date
      parse_utc_date(data['travelDate']).to_date.strftime('%A %d %B %Y')
    end

    # Returns integer, e.g. '25'
    def amount
      data['amount'].to_f / 100
    end

    # Returns string, e.g. '2590'
    def reference
      data['caseReference']
    end

    private

    attr_reader :data
  end
end
