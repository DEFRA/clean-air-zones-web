# frozen_string_literal: true

##
# This is an abstract class used as a base form BY all form classes.
class BaseForm
  # Attribute that is being checked in the form, can be any type
  attr_reader :parameter
  # Returned error message, string
  attr_reader :message

  ##
  # Creates an instance of a form class.
  #
  # ==== Attributes
  #
  # * +parameter+ - abstract attribute can be any type, e.g. '["London", "York"]' or 'yes'
  # * +message+ - empty string, default error message
  def initialize(parameter)
    @parameter = parameter
    @message = ''
  end
end
