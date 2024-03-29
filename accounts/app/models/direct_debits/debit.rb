# frozen_string_literal: true

##
# Module used for Direct Debits flow
module DirectDebits
  ##
  # Serializes DirectDebit functionality. Used to manage mandates.
  #
  class Debit
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    # * +beta_tester+ - status of user if he is in beta group
    #
    def initialize(account_id, user_beta_tester: false)
      @account_id = account_id
      @user_beta_tester = user_beta_tester
    end

    # It calls {rdoc-ref:DebitsApi.mandates} to fetch data.
    # Returns `DirectDebits::Mandate` instances where enabled cazes with mandate only in `active` or `pending_submission` status
    def mandates
      @mandates ||= begin
        result = enabled_cazes.each do |obj|
          active = obj['mandates'].find { |mandate| select_active_api_statuses(mandate['status']) }
          obj['mandates'] = (active || [])
        end

        result.map { |mandate_data| DirectDebits::Mandate.new(mandate_data) }.sort_by(&:zone_name)
      end
    end

    # Returns an array of associated DirectDebits::Mandate instances in `active` or `pending_submission` statuses
    def active_mandates
      Rails.logger.info "[#{self.class.name}] Getting active mandates"
      mandates.select { |mandate| select_active_statuses(mandate.status) }
    end

    # Returns an array of associated DirectDebits::Mandate instances without `active` or `pending_submission` statuses
    def inactive_mandates
      Rails.logger.info "[#{self.class.name}] Getting inactive mandates"
      mandates.reject { |mandate| select_active_statuses(mandate.status) }
    end

    # Calls {rdoc-ref:DebitsApi.caz_mandates} to fetch data.
    # Find the mandate in 'active' or `pending_submission` status
    #
    # ==== Params
    # * +account_id+ - ID of the account associated with the fleet
    # * +zone_id+ - uuid, ID of the CAZ
    #
    def caz_mandates(zone_id)
      @caz_mandates ||= begin
        api_response ||= DebitsApi.caz_mandates(account_id: account_id, zone_id: zone_id)
        api_response&.find { |mandate| select_active_api_statuses(mandate['status']) }
      end
    end

    private

    # Readers
    attr_reader :account_id, :user_beta_tester

    # Returns true if status can be considered as an 'active' received from api response
    def select_active_api_statuses(status)
      return false unless status

      %w[pending_customer_approval pending_submission submitted active].include?(status.downcase)
    end

    # Returns true if status can be considered as an 'active', status already humanized in DirectDebits::Mandate.status
    def select_active_statuses(status)
      return false unless status

      %w[pending submitted active].include?(status.downcase)
    end

    # Returns an array of enabled cazes if user is not in a beta group
    def enabled_cazes
      if user_beta_tester
        DebitsApi.mandates(account_id: account_id)
      else
        DebitsApi.mandates(account_id: account_id).select { |caz| caz['directDebitEnabled'] == true }
      end
    end
  end
end
