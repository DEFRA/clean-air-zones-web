# frozen_string_literal: true

##
# Raises exception if email already confirmed.
#
class UserAlreadyConfirmedException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException)
  #
  def initialize
    super('User already confirmed')
  end
end
