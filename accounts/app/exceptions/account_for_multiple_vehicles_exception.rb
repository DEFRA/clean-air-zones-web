# frozen_string_literal: true

##
# Raises exception if user crates account for one vehicle.
#
class AccountForMultipleVehiclesException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +errors_object+ - hash - messaged passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
