# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set payment ID returned by the Payments API.
  #
  class SetPaymentId < BaseManipulator
    # Adds the +payment_id+ to the session. Used by the class level method +.call+
    def call
      session[:new_payment] ||= {}
      session[:new_payment][:payment_id] = params[:payment_id]
    end
  end
end
