# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Saves submitted vehicles details.
  # It doesn't override details for vehicles from different pages.
  #
  class AddPaymentDetails < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:new_payment] ||= {}
      current_vehicles.each { |vrn| save_vehicle_data(vrn) }
    end

    private

    # Saves selected dates into the details hash.
    # If VRN is not present in the new data, it assigns an empty array.
    def save_vehicle_data(vrn)
      vehicle_details = new_payment_data.dig(:details, vrn)
      return unless vehicle_details

      vehicle_details.symbolize_keys!
      vehicle_details[:dates] = new_data.try(:[], vrn) || []
      new_payment_data[:details][vrn] = vehicle_details
    end

    # Extracts submitted data from params
    def new_data
      @new_data = params.dig(:payment, :vehicles)
    end

    # Extracts the list of vehicles from the current page
    def current_vehicles
      params.dig(:payment, :vrn_list)&.split(',') || []
    end
  end
end
