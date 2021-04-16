# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Represents the virtual model of the chargeable vehicles on matrix page.
  #
  class ChargeableVehicles
    include LogAction
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    # * +zone_id+ - UUID, ID of the selected CAZ
    #
    def initialize(account_id, zone_id)
      @account_id = account_id
      @zone_id = zone_id
    end

    # Returns a Payments::PaginatedVehicles with chargeable vehicles associated with the account.
    # Includes data about page and total pages count.
    def pagination(page: 1, per_page: 10, vrn: nil) # rubocop:disable Metrics/MethodLength
      @pagination ||= begin
        log_action('Getting paginated chargeable vehicles')
        data = PaymentsApi.chargeable_vehicles(
          account_id: account_id,
          zone_id: zone_id,
          page: page,
          per_page: per_page,
          vrn: vrn
        )
        Payments::PaginatedVehicles.new(data, page, per_page)
      end
    end

    # Checks what is the total count of stored chargeable vehicles
    def account_vehicles_count
      api_call['totalVehiclesCount']
    end

    # Checks if there are any undetermined chargeable vehicles
    def any_undetermined_vehicles
      api_call['anyUndeterminedVehicles']
    end

    private

    # Attributes reader
    attr_reader :account_id, :zone_id

    # Make api call to get chargeable vehicles
    def api_call
      @api_call ||= begin
        log_action('Getting the count of chargeable vehicles and if there are any undetermined vehicles')
        PaymentsApi.chargeable_vehicles(
          account_id: account_id,
          zone_id: zone_id,
          page: 1,
          per_page: 1,
          vrn: nil
        )
      end
    end
  end
end
