# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Controller used to pay for fleet
  #
  class PaymentsController < ApplicationController # rubocop:disable Metrics/ClassLength
    include CheckPermissions
    include ChargeabilityCalculator
    include CazLock

    before_action -> { check_permissions(allow_make_payments?) }
    before_action :check_la, only: %i[matrix submit review select_payment_method no_chargeable_vehicles
                                      in_progress vrn_not_found submit_search]
    before_action :check_job_status, only: %i[index local_authority matrix vrn_not_found submit_search]
    before_action :clear_make_payment_history, only: %i[index]
    before_action :release_lock_on_caz, only: %i[success failure]
    before_action :assign_zone_and_dates, only: %i[matrix vrn_not_found]
    before_action :assign_debit, only: %i[select_payment_method]
    before_action :check_new_payment_data, only: %i[review confirm_review]

    ##
    # Renders the list of available local authorities
    # If the fleet is empty, redirects to {first_upload}[rdoc-ref:FleetsController.first_upload]
    #
    # ==== Path
    #
    #    :GET /payments
    #
    def index
      return redirect_to first_upload_fleets_path if current_user.fleet.total_vehicles_count < 2

      @back_button_url = determinate_back_button_url
      @zones = current_user.beta_tester ? CleanAirZone.all : CleanAirZone.active
    end

    ##
    # Validates and saves selected local authority.
    #
    # ==== Path
    #
    #    :POST /payments
    #
    def local_authority
      form = Payments::LocalAuthorityForm.new(caz_id: la_params['caz_id'])
      if form.valid?
        determinate_lock_caz(form.caz_id)
      else
        redirect_to payments_path, alert: confirmation_error(form, :caz_id)
      end
    end

    ##
    # Renders payment matrix page.
    #
    # ==== Path
    #
    #    :GET /payments/matrix
    #
    def matrix
      return redirect_to in_progress_payments_path if caz_locked?

      clear_upload_job_data
      @search = helpers.payment_query_data[:search]
      validate_and_search
    end

    ##
    # Renders no results page when no vrn is found
    #
    # ==== Path
    #
    #    :GET /payments/matrix/vrn_not_found
    #
    def vrn_not_found
      @search = helpers.payment_query_data[:search]
    end

    ##
    # Validates a search form and redirects to the proper page
    #
    # ==== Path
    #
    #    :POST /payments/matrix/vrn_not_found
    #
    def submit_search
      form = VrnForm.new(params.dig('payment', 'vrn_search'))
      if form.valid?
        session[:payment_query][:search] = form.vrn
        redirect_to matrix_payments_path
      else
        assign_zone_and_dates
        render_vrn_not_found(form)
      end
    end

    ##
    # Renders page informing users that they have no chargeable vehicles in the selected zone
    #
    # ==== Path
    #
    #    :GET /payments/no_chargeable_vehicles
    #
    # ==== Params
    # * +caz_id+ - id of the selected CAZ, required in the session
    def no_chargeable_vehicles
      @clean_air_zone_name = CleanAirZone.find(@zone_id).name
    end

    ##
    # Saves payment and query details.
    # If commit value equals 'Continue' redirects to :review,
    # else redirects to matrix with new query data.
    #
    # ==== Path
    #
    #    :POST /payments/submit
    #
    def submit
      SessionManipulation::AddPaymentDetails.call(session: session, params: payment_params)
      return redirect_to review_payments_path if params[:commit] == 'Continue'

      SessionManipulation::AddQueryDetails.call(session: session, params: payment_params)
      redirect_to matrix_payments_path
    end

    ##
    # Clears search form on payment matrix.
    #
    # ==== Path
    #
    #    :GET /payments/clear_search
    #
    def clear_search
      SessionManipulation::ClearVrnSearch.call(session: session)
      redirect_to matrix_payments_path
    end

    ##
    # Renders review payment page.
    #
    # ==== Path
    #
    #    :GET /payments/review
    #
    def review
      @zone = CleanAirZone.find(@zone_id)
      @days_to_pay = helpers.days_to_pay(helpers.new_payment_data[:details])
      @total_to_pay = total_to_pay_from_session
    end

    ##
    # Validates user has confirmed review payment.
    # If it is valid, redirects to {select payment method page}[rdoc-ref:select_payment_method]
    # If not, renders {not found}[rdoc-ref:review] with errors
    #
    # ==== Path
    #    POST /payments/confirm_review
    #
    def confirm_review
      form = Payments::PaymentReviewForm.new(params['confirm_not_exemption'])
      session[:new_payment]['confirm_not_exemption'] = params['confirm_not_exemption']

      if form.valid?
        redirect_to select_payment_method_payments_path
      else
        redirect_to review_payments_path, alert: confirmation_error(form)
      end
    end

    ##
    # Renders review details
    #
    # ==== Path
    #
    #    :GET /payments/review_details
    #
    def review_details
      @details = helpers.vrn_to_pay(helpers.new_payment_data[:details])
    end

    ##
    # Renders the select payment method page
    # If no caz active mandates are present redirects to the initiate card payment page
    #
    # ==== Path
    #
    #    :GET /payments/select_payment_method
    #
    def select_payment_method
      return if helpers.direct_debits_enabled? && @debit.caz_mandates(@zone_id).present?

      redirect_to initiate_payments_path
    end

    ##
    # Validate submit payment method and depending on the type, redirects to:
    #  {rdoc-ref:DirectDebitsController.confirm_direct_debit} if +direct_debit_method+ value is true
    #  or call {rdoc-ref:initiate_card_payment} method if +direct_debit_method+ value is false
    #  or render errors if +direct_debit_method+ value is null
    #
    # ==== Path
    #
    #    :POST /payments/confirm_payment_method
    #
    # ==== Params
    # * +caz_id+ - id of the selected CAZ, required in the session
    def confirm_payment_method
      session[:new_payment]['payment_method'] = params['payment_method']
      case params['payment_method']
      when 'true'
        redirect_to confirm_debits_path
      when 'false'
        redirect_to initiate_payments_path
      else
        @errors = 'Choose Direct Debit or card payment'
        render :select_payment_method
      end
    end

    ##
    # Renders page after successful payment
    #
    # ==== Path
    #   GET /payments/success
    #
    # ==== Params
    # * +payment_reference+ - payment reference, required in the session
    # * +external_id+ - external payment id, required in the session
    # * +user_email+ - email of the user which performed the payment, required in the session
    # * +caz_id+ - selected local authority ID
    def success
      payments = helpers.initiated_payment_data
      @payment_details = Payments::Details.new(session_details: payments,
                                               entries_paid: helpers.days_to_pay(payments[:details]),
                                               total_charge: helpers.total_to_pay(payments[:details]))
    end

    ##
    # Render page after unsuccessful payment
    #
    # ==== Path
    #   GET /payments/failure
    #
    # ==== Params
    # * +payment_reference+ - payment reference, required in the session
    # * +external_id+ - external payment id, required in the session
    def failure
      data = helpers.initiated_payment_data
      @payment_details = Payments::Details.new(session_details: data,
                                               entries_paid: helpers.days_to_pay(data[:details]),
                                               total_charge: helpers.total_to_pay(data[:details]))
    end

    ##
    # Render page with payment details.
    #
    # ==== Path
    #   GET /payments/post_payment_details
    #
    def post_payment_details
      @details = helpers.vrn_to_pay(helpers.initiated_payment_data[:details])
    end

    ##
    # Render the payment in progress page. If CAZ is no longer locked redirects to payment matrix
    #
    # ==== Path
    #   GET /payments/in_progress
    #
    def in_progress
      return determinate_lock_caz(@zone_id) unless caz_locked?

      api_response = AccountsApi::Users.user(account_id: caz_lock_account_id,
                                             account_user_id: caz_lock_user_id)
      @user = UsersManagement::User.new(api_response)
      @zone = CleanAirZone.find(@zone_id)
    end

    private

    # Check if provided VRN in search is valid
    def validate_search_params
      form = VrnForm.new(@search)
      return if form.valid?

      SessionManipulation::ClearVrnSearch.call(session: session)
      form.error_message
    end

    # Fetches charges with params saved in the session
    def charges
      query_data = helpers.payment_query_data
      data = current_user.charges(zone_id: @zone_id, vrn: query_data[:vrn], direction: query_data[:direction])
      SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
      data
    end

    # Fetches charges with vrn saved in session
    def charges_by_vrn
      data = current_user.charges_by_vrn(zone_id: @zone_id, vrn: helpers.payment_query_data[:search])
      SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
      data
    end

    # Permits all the form params
    def payment_params
      params.permit(:authenticity_token, :commit, :allSelectedCheckboxesCount,
                    payment: [:vrn_search, :next_vrn, :previous_vrn, :vrn_list, { vehicles: {} }])
    end

    # Permits caz_id
    def la_params
      params.permit('caz_id', :authenticity_token, :commit)
    end

    # After selecting Clean Air Zone method checks if user has any chargeable
    # vehicles and redirects him accordingly.
    def determine_next_page(zone_id)
      charges_exists = current_user.fleet.any_chargeable_vehicles_in_caz?(zone_id)
      charges_exists ? matrix_payments_path : no_chargeable_vehicles_payments_path
    end

    # Assigns +zone+, +dates+ and +d_day_notice+
    def assign_zone_and_dates
      @zone = CleanAirZone.find(@zone_id)
      service = Payments::PaymentDates.new(charge_start_date: @zone.active_charge_start_date)
      @dates = current_user.beta_tester ? service.all_chargeable_dates : service.chargeable_dates
      @d_day_notice = service.d_day_notice
    end

    # Returns back link url
    def determinate_back_button_url
      last_path = request.referer || []
      if last_path.include?(success_payments_path)
        success_payments_path
      elsif last_path.include?(success_debits_path)
        success_debits_path
      elsif last_path.include?(in_progress_payments_path)
        in_progress_payments_path
      else
        dashboard_path
      end
    end

    # Redirects to local authority selection page when there is no payment data in session
    def check_new_payment_data
      redirect_to payments_path if helpers.new_payment_data.blank?
    end

    # Validates search form and redirects to the proper page
    def validate_and_search
      flash.now[:alert] = validate_search_params unless @search.nil?
      @charges = flash.alert || @search.nil? ? charges : charges_by_vrn
      redirect_to vrn_not_found_payments_path if @search.present? && !@charges.any_results?
    end

    # Assigns errors and renders the vrn not found page
    def render_vrn_not_found(form)
      @search = form.vrn
      flash.now[:alert] = form.error_message
      render :vrn_not_found
    end
  end
end
