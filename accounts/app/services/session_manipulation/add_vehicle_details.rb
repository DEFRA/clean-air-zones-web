# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Saves vehicles details from PaymentsApi.chargeable_vehicles for later calculations.
  # It doesn't override details for vehicles from different pages.
  #
  class AddVehicleDetails < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:new_payment] ||= {}
      session[:new_payment][:details] ||= {}
      params.each { |vehicle| serialize_vehicle(vehicle) }
    end

    private

    # Serializes the vehicle. It does not override existing ones.
    def serialize_vehicle(vehicle)
      return if session[:new_payment][:details].keys.include?(vehicle.vrn)

      session[:new_payment][:details][vehicle.vrn] = vehicle.serialize
    end
  end
end
