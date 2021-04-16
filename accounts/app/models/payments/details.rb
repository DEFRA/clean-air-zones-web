# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Class used to serialize the payment details on the success page
  #
  # ==== Usage
  #
  #    @payment_details = Payments::Details.new(session[:vehicle_details])
  #
  class Details
    # Attributes reader
    attr_reader :entries_paid, :total_charge

    ##
    # Initializer method
    #
    # ==== Params
    # * +session_details+ - hash
    #   * +external_id+ - payment ID in backend DB
    #   * +user_email+ - user email address
    #   * +reference_number+ - payment reference number
    #   * +caz_id+ - selected local authority ID
    # * +entries_paid+ - quantity of paid days
    # * +total_charge+ - sum of charges for all entries
    #
    def initialize(session_details:, entries_paid:, total_charge:)
      @session_details = session_details
      @entries_paid = entries_paid
      @total_charge = total_charge
    end

    # Returns an 'CleanAirZone' instance
    def clean_air_zone
      CleanAirZone.find(session_details[:caz_id])
    end

    # Returns user email address
    def user_email
      session_details[:user_email]
    end

    # Returns the payment reference number
    def reference
      session_details[:payment_reference]
    end

    # Returns the payment ID in backend DB
    def external_id
      session_details[:external_id]
    end

    private

    # Reader function
    attr_reader :session_details
  end
end
