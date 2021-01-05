# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to store payment information returned after payment
  # creation in Payments API.
  #
  class SetPaymentDetails < BaseManipulator
    ##
    # Initializer function. User by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +email+ - an email address
    # * +payment_reference+ - central reference number of the payment
    # * +external_id+ - external identifier in uuid format
    def initialize(session:, email:, payment_reference:, external_id:)
      @session = session
      @email = email
      @payment_reference = payment_reference
      @external_id = external_id
    end

    ##
    # Adds provided parameters to users session.
    # Used by the class level method +.call+
    def call
      session[:initiated_payment][:user_email] = email
      session[:initiated_payment][:payment_reference] = payment_reference
      session[:initiated_payment][:external_id] = external_id
    end

    private

    # Attributes reader
    attr_reader :email, :payment_reference, :external_id
  end
end
