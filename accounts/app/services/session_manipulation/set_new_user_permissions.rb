# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set New User permissions data provided by user in the add new user process.
  #
  class SetNewUserPermissions < BaseManipulator
    # Adds the +permissions+ to the +new_user+ in the session. Used by the class level method +.call+
    def call
      session[:new_user]['permissions'] = params[:permissions]
    end
  end
end
