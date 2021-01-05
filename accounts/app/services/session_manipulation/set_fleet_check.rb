# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set Fleet Check selected by user in the Fleet check step of sign up.
  #
  class SetFleetCheck < BaseManipulator
    # Adds the +company_name+ to the session. Used by the class level method +.call+
    def call
      session[:new_account] ||= {}
      session[:new_account][:confirm_fleet_check] = params[:confirm_fleet_check]
    end
  end
end
