# frozen_string_literal: true

##
# This is an abstract class used as a base for all API exceptions.
class ApiException < StandardError
  ##
  # Attributes used internally
  attr_reader :status, :status_message, :body_message

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +status+ - string or integer, HTTP error status
  # * +status_message+ - string, HTTP error message
  # * +body+ - request body
  def initialize(status, status_message, body)
    @status         = status.to_i
    @status_message = status_message
    @body_message   = body.is_a?(Hash) ? body.symbolize_keys[:message] : status_message
    @body           = body
  end

  ##
  # Displays error message from body with a status
  #
  # ==== Example
  #
  #    "Status: 404; Message: 'Vehicle was not found'"
  def message
    "Error status: #{status}; Message: #{@body_message || 'not received'}"
  end

  ##
  # Returns request body or an empty hash if there was no body
  def body
    @body || {}
  end
end
