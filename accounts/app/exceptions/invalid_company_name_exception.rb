# frozen_string_literal: true

##
# Raises exception if company name does not meet requirements.
#
class InvalidCompanyNameException < ApplicationException
  # Attribute used internally
  attr_reader :errors_object

  #
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +errors_object+ - hash - messaged passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
