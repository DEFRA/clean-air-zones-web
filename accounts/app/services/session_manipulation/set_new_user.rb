# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Service used to set New User data provided by user in the add new user process.
  #
  class SetNewUser < BaseManipulator
    # Adds the +name+ and +email+ to the +new_user+ in the session. Used by the class level method +.call+
    def call
      session[:new_user] ||= {}
      session[:new_user]['name'] = params[:name]
      session[:new_user]['email'] = params[:email]&.strip
    end
  end
end
