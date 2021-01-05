# frozen_string_literal: true

##
# Raises exception if invalid email or password was provided.
#
class NewPasswordException < ApplicationException
  # Attribute used internally
  attr_reader :errors_object

  #
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +errors_object+ - hash - messaged passed to parent exception
  def initialize(errors)
    @errors_object = errors
    super(errors_object)
  end
end
