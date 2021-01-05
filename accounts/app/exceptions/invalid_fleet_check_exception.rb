# frozen_string_literal: true

##
# Raises exception if fleet check params does not meet requirements.
#
class InvalidFleetCheckException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +msg+ - message passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
