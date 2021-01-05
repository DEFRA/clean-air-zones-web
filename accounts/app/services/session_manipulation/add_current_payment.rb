# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Saves submitted vehicles and initiated payment details.
  # Session used to store provided data after payment initiation.
  #
  class AddCurrentPayment < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:initiated_payment] = session[:new_payment]
    end
  end
end
