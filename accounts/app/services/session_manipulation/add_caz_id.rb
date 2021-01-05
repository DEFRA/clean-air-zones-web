# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # Save selected CAZ ID.
  # It doesn't overrides data for the same local authority.
  #
  class AddCazId < BaseManipulator
    ##
    # Initializer function. User by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +caz_id+ - ID of the selected CAZ
    def initialize(session:, caz_id:)
      @session = session
      @caz_id = caz_id
    end

    ##
    # Instance level +call+ method
    #
    def call
      session.delete(:payment_query)
      return if new_payment_data[:caz_id] == caz_id

      session[:new_payment] = { caz_id: caz_id }
    end

    private

    # Attributes reader
    attr_reader :session, :caz_id
  end
end
