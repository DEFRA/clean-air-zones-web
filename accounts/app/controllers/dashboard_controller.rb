# frozen_string_literal: true

##
# Controller class for the home page
#
class DashboardController < ApplicationController
  include CheckPermissions
  include CazLock
  include PaymentFeatures

  before_action :set_cache_headers, only: %i[index]
  before_action :clear_input_history, only: :index

  # Handle Bath D-Day notice
  before_action :assign_payment_enabled, only: :index
  before_action :assign_bath_d_day_date, only: :index

  ##
  # Renders the dashboard page.
  #
  # ==== Path
  #
  #    :GET /dashboard
  #
  def index
    @vehicles_count = current_user.fleet.total_vehicles_count
    @any_dd_cazes_enabled = any_dd_cazes_enabled
    @mandates_present = check_mandates
    account_users = load_account_users
    @users_present = check_users(account_users)
    @multi_payer_account = account_users.multi_payer_account?
    @days_count = days_to_password_expiry
    @payments_present = check_payments
  end

  private

  # Do not perform api call if user is not in a beta group or direct debits disabled or user don't have permission
  def check_mandates
    return false unless allow_manage_mandates?

    if current_user&.beta_tester || Rails.configuration.x.feature_direct_debits.to_s.downcase == 'true'
      DirectDebits::Debit.new(current_user.account_id).active_mandates.any?
    else
      false
    end
  end

  # Calls api to check if at least one direct debit caz is enabled for non beta testers
  def any_dd_cazes_enabled
    return true if current_user&.beta_tester

    Rails.logger.info "[#{self.class.name}] Getting enabled direct debit clean air zones"
    DebitsApi.mandates(account_id: current_user.account_id).any? { |caz| caz['directDebitEnabled'] == true }
  end

  # Loads account users
  def load_account_users
    UsersManagement::AccountUsers.new(account_id: current_user.account_id, user_id: current_user.user_id)
  end

  # Do not perform api call if user don't have permission
  def check_users(account_users)
    return false unless allow_manage_users?

    account_users.filtered_users.any?
  end

  # Do not perform api call if user don't have permission
  def check_payments
    if allow_view_payment_history?
      check_payments_present
    elsif allow_make_payments?
      check_payments_present(user_payments: true)
    else
      false
    end
  end

  # Checks if payments assigned to account or user are present.
  def check_payments_present(user_payments: false)
    PaymentHistory::History.new(current_user.account_id, current_user.user_id, user_payments)
                           .pagination(page: 0, per_page: 1)
                           .total_payments_count.positive?
  end

  # clear user flow history from the session
  def clear_input_history
    clear_manage_vehicles_history
    clear_make_payment_history
    clear_manage_users_history
    clear_payment_history
  end

  # clear manage vehicles inputs
  def clear_manage_vehicles_history
    session[:choose_method] = nil
  end

  # clear manage users inputs
  def clear_manage_users_history
    session[:new_user] = nil
  end

  # clear payments history back links
  def clear_payment_history
    session[:back_link_history] = nil
  end
end
