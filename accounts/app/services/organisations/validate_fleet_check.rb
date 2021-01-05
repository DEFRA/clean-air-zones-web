# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # Service used to validate fleet check and throw exception if is not valid.
  #
  class ValidateFleetCheck < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +confirm_fleet_check+ - string, the company name submitted by the user
    #
    def initialize(confirm_fleet_check:)
      @confirm_fleet_check = confirm_fleet_check
    end

    ##
    # The caller method for the service.
    # Invokes validation for company name format and performs a request to API.
    # When response is other than :created (201) then throws an exception.
    def call
      validate_params
      fleet_check
    end

    private

    # Attributes reader
    attr_reader :confirm_fleet_check

    # validate provided params.
    def validate_params
      form = Organisations::FleetCheckForm.new(confirm_fleet_check: confirm_fleet_check)
      return if form.valid?

      raise InvalidFleetCheckException, form.first_error_message
    end

    # Used to check if account confirmed two or more vehicle in the fleet.
    def fleet_check
      raise AccountForMultipleVehiclesException if confirm_fleet_check == 'less_than_two'
    end
  end
end
