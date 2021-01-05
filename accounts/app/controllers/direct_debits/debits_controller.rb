# frozen_string_literal: true

##
# Module used for Direct Debits flow
module DirectDebits
  ##
  # Controller used to manage and pay Direct Debits
  #
  class DebitsController < ApplicationController # rubocop:disable Metrics/ClassLength
    include CazLock
    include CheckPermissions

    before_action -> { check_permissions(helpers.direct_debits_enabled?) }, only: %i[
      index new create complete_setup
    ]
    before_action -> { check_permissions(allow_manage_mandates?) }, only: %i[index new create complete_setup]
    before_action -> { check_permissions(allow_make_payments?) }, except: %i[index new create complete_setup]
    before_action :check_la, only: %i[confirm first_mandate]
    before_action :assign_debit, only: %i[confirm index new first_mandate]
    before_action :check_active_caz_mandates, only: :first_mandate
    before_action :assign_back_button_url, only: %i[confirm index new first_mandate]
    before_action :clear_payment_method, only: %i[first_mandate initiate]
    before_action :release_lock_on_caz, only: %i[cancel success failure]
    before_action :check_caz_id_in_session, only: :complete_setup

    ##
    # Renders the confirm Direct Debit page
    # Check if any active mandates present for chosen local authority
    # Redirect to {rdoc-ref.first_mandate} if no active mandates
    #
    # ==== Path
    #
    #    :GET /debits/confirm
    #
    def confirm
      caz_mandates = @debit.caz_mandates(@zone_id)
      if caz_mandates.present?
        @zone_name = CleanAirZone.find(@zone_id)&.name
        @mandate_id = caz_mandates['id']
        @created_at = caz_mandates['created']
        @total_to_pay = total_to_pay_from_session
      else
        redirect_to first_mandate_debits_path
      end
    end

    ##
    # Makes a request to initiate Direct Debit payment
    #
    # ==== Path
    #
    #    :POST /debits/initiate
    #
    def initiate
      details = DirectDebits::Details.new(create_direct_debit_payment)
      payment_details_to_session(details)
      redirect_to success_debits_path
    rescue BaseApi::Error400Exception, BaseApi::Error422Exception
      redirect_to failure_debits_path
    end

    ##
    # Renders page after successful Direct Debit payment
    #
    # ==== Path
    #
    #    :GET /debits/success
    #
    def success
      payments = helpers.initiated_payment_data
      @payment_details = Payments::Details.new(session_details: payments,
                                               entries_paid: helpers.days_to_pay(payments[:details]),
                                               total_charge: helpers.total_to_pay(payments[:details]))
    end

    ##
    # Renders the first create a Direct Debit mandate
    #
    # ==== Path
    #
    #    :GET /debits/first_mandate
    #
    def first_mandate
      # renders static page
    end

    ##
    # Renders active Direct Debit mandates
    # Redirect to #new if there is no mandate assigned to the account.
    #
    # ==== Path
    #
    #    GET /debits
    #
    def index
      redirect_to new_debit_path if @debit.active_mandates.empty?

      @mandates = @debit.active_mandates
      @zones_without_mandate = @debit.inactive_mandates
    end

    ##
    # Renders a selector to add a new mandate.
    # If there is no possible new mandates, redirects to the #index
    #
    # ==== Path
    #
    #    GET /debits/new
    #
    def new
      @zones = @debit.inactive_mandates

      redirect_to debits_path if @zones.empty?
    end

    ##
    # Validates and creates a new mandate.
    #
    # ==== Path
    #
    #    POST /debits
    #
    def create
      form = Payments::LocalAuthorityForm.new(caz_id: params['caz_id'])
      if form.valid?
        session[:mandate_caz_id] = form.caz_id
        create_debit_mandate(form.caz_id)
      else
        redirect_to new_debit_path, alert: confirmation_error(form, :caz_id)
      end
    end

    ##
    # Renders the cancel payment page
    #
    # ==== Path
    #
    #    GET /payments/cancel
    #
    def cancel
      # renders static page
    end

    ##
    # Render page after unsuccessful direct debit payment
    #
    # ==== Path
    #   GET /debits/failure
    #
    def failure
      # renders the static page
    end

    ##
    # Complete Direct Debit mandate creation
    #
    # ==== Path
    #
    #    GET /debits/complete_setup
    #
    def complete_setup
      DebitsApi.complete_mandate_creation(
        flow_id: params['redirect_flow_id'],
        session_id: session.id.to_s,
        caz_id: session[:mandate_caz_id]
      )
      redirect_to debits_path
    rescue BaseApi::Error400Exception => e
      redirect_to_after_400_error(e)
    end

    private

    # creates Direct Debit payment for selected mandate.
    def create_direct_debit_payment
      Payments::MakeDebitPayment.call(payment_data: helpers.new_payment_data,
                                      account_id: current_user.account_id,
                                      user_id: current_user.user_id,
                                      user_email: current_user.email,
                                      mandate_id: params['mandate_id'])
    end

    # Saves initiated Direct Debit payment details to the session
    def payment_details_to_session(details)
      SessionManipulation::AddCurrentPayment.call(session: session)
      SessionManipulation::SetPaymentDetails.call(session: session,
                                                  email: current_user.email,
                                                  payment_reference: details.payment_reference,
                                                  external_id: details.external_id)
    end

    # Creates a Direct Debit mandate and redirects to the response url
    def create_debit_mandate(caz_id)
      result = DebitsApi.create_mandate(
        account_id: current_user.account_id,
        caz_id: caz_id,
        return_url: complete_setup_debits_url,
        session_id: session.id.to_s
      )
      redirect_to result['nextUrl']
    end

    # Redirect to {rdoc-ref:index} if active mandates are present
    def check_active_caz_mandates
      redirect_to debits_path if @debit.caz_mandates(@zone_id).present?
    end

    # clear +payment_method+ from the session
    def clear_payment_method
      session[:payment_method] = nil
    end

    # Checks if +mandate_caz_id+ in session. If not, it redirects to the debits page
    def check_caz_id_in_session
      redirect_to debits_path if session[:mandate_caz_id].nil?
    end

    # Redirects to the {rdoc-ref:index} if mandate was already created
    # Otherwise renders the service unavailable page
    def redirect_to_after_400_error(exception)
      if exception.message.include?('Your integration has already completed this redirect flow')
        redirect_to debits_path
      else
        render_server_unavailable(exception)
      end
    end
  end
end
