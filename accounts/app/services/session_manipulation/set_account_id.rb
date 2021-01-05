# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set Company Name provided by user in the first step of sign up.
  #
  class SetAccountId < BaseManipulator
    # Adds the +account_id+ to the session. Used by the class level method +.call+
    def call
      session[:new_account] ||= {}
      session[:new_account]['account_id'] = params['account_id']
    end
  end
end
