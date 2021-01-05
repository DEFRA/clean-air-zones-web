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
  #    :GET /fleets/organisation-account/dashboard
  #
  def index
    @vehicles_count = current_user.fleet.total_vehicles_count
    @mandates_present = check_mandates
    account_users = load_account_users
    @users_present = check_users(account_users)
    @multi_payer_account = account_users.multi_payer_account?
    @days_count = days_to_password_expiry
  end

  private

  # Do not perform api call if direct debits disabled or user don't have permission
  def check_mandates
    return false unless Rails.configuration.x.feature_direct_debits.to_s.downcase == 'true'
    return false unless allow_manage_mandates?

    DirectDebits::Debit.new(current_user.account_id).active_mandates.any?
  end

  # Loads account users
  def load_account_users
    UsersManagement::AccountUsers.new(
      account_id: current_user.account_id,
      user_id: current_user.user_id
    )
  end

  # Do not perform api call if user don't have permission
  def check_users(account_users)
    return false unless allow_manage_users?

    account_users.filtered_users.any?
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
    session[:submission_method] = nil
  end

  # clear manage users inputs
  def clear_manage_users_history
    session[:new_user] = nil
  end

  # clear payments history back links
  def clear_payment_history
    session[:company_back_link_history] = nil
    session[:user_back_link_history] = nil
  end
end
