# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set user details returned from api call to the session
  #
  class SetEditUser < BaseManipulator
    # Adds next values to the +edit_user+ in the session. Used by the class level method +.call+
    # * +email+ - email, email of the user
    # * +name+ - string, name of the user
    # * +owner+ - boolean, determines if the user is owner
    # * +permissions+ - permission names of the user
    def call
      session[:edit_user] = params
    end
  end
end
