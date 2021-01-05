# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # Controller used to create a company account
  #
  # rubocop:disable Metrics/ClassLength
  class OrganisationsController < ApplicationController
    include PaymentFeatures

    skip_before_action :authenticate_user!
    # checks if new_company account_id is present in session
    before_action :check_account_id, only: %i[new_credentials create email_sent]
    # checks if new account details is present in session
    before_action :check_account_details, only: %i[email_sent resend_email]
    # add data to session to render it in the text fields after using `Back` link
    before_action :add_credentials_to_session, only: :create
    before_action :assign_payment_enabled, only: :cannot_create

    ##
    # Renders the create account name page.
    #
    # ==== Path
    #
    #    :GET /organisations
    #
    def new
      @error = alert
    end

    ##
    # Validates submitted account name.
    # If successful, redirects to {:new_credentials}[rdoc-ref:new_credentials]
    # If no, redirects to {:new}[rdoc-ref:new]
    #
    # ==== Path
    #
    #    POST /organisations
    #
    # ==== Params
    # * +company_name+ - string, account name e.g. 'Company name'
    #
    def set_name
      create_new_account if account_not_created_or_name_changed?
      redirect_to fleet_check_organisations_path
    rescue InvalidCompanyNameException, UnableToCreateAccountException => e
      @error = e.message
      render 'organisations/organisations/new'
    end

    ##
    # Renders page to check if fleet have more than 2 vehicles.
    #
    # ==== Path
    #
    #    GET /organisations/fleet_check
    #
    def fleet_check
      # renders static page
    end

    ##
    # Creates Account based on provided details.
    # Validates if account will have more than two vehicles in the fleet.
    #
    # ==== Path
    #
    #    POST /organisations/fleet_check
    #
    def submit_fleet_check
      SessionManipulation::SetFleetCheck.call(session: session, params: company_params)
      Organisations::ValidateFleetCheck.call(confirm_fleet_check: company_params[:confirm_fleet_check])
      redirect_to new_credentials_organisations_path
    rescue InvalidFleetCheckException => e
      @error = e.message
      render 'organisations/organisations/fleet_check'
    rescue AccountForMultipleVehiclesException
      redirect_to cannot_create_organisations_path
    end

    ##
    # Renders page to inform that user cannot create account fot less than two vehicles.
    #
    # ==== Path
    #
    #    GET /organisations/cannot_create
    #
    def cannot_create
      # renders static page
    end

    ##
    # Renders the new email and password page.
    #
    # ==== Path
    #
    #    GET /organisations/new_credentials
    #
    # ==== Params
    # * +company_name+ - string, account name stored in the session e.g. 'Company name'
    #
    def new_credentials
      # renders static page
    end

    ##
    # Validates submitted email and password.
    # If successful, redirects to {email_sent}[rdoc-ref:email_sent]
    # If no, redirects to {new_email_and_password}[rdoc-ref:new_email_and_password]
    #
    # ==== Path
    #
    #    POST /organisations/new_credentials
    #
    # ==== Params
    # * +company_name+ - string, account name stored in the session e.g. 'Company name'
    #
    def create
      user = Organisations::CreateUserAccount.call(
        organisations_params: organisations_params,
        account_id: new_account['account_id'],
        verification_url: email_verification_organisations_url
      )
      new_account.merge!(user.serializable_hash.stringify_keys)
      redirect_to email_sent_organisations_path
    rescue NewPasswordException => e
      @errors = e.errors_object
      render :new_credentials
    end

    ##
    # Renders the email sent page.
    #
    # ==== Path
    #
    #    :GET /organisations/email_sent
    #
    def email_sent
      @email = User.new(new_account).email
    end

    ##
    # Resend email by clicking the button
    #
    # ==== Path
    #
    #    :GET /organisations/resend_email
    #
    def resend_email
      AccountsApi::Users.resend_verification(
        account_id: new_account['account_id'],
        user_id: new_account['user_id'],
        verification_url: email_verification_organisations_url
      )
      redirect_to email_sent_organisations_path
    end

    ##
    # Checks the verification token.
    # If the token is valid it calls backend to mark the email address as verified
    # and redirects to :email_verified
    # If verification fails it redirects to :verification_failed
    #
    # ==== Path
    #
    #    :GET /organisations/email_verification
    #
    # ==== Params
    # * +token+ - string, encrypted token with verification data
    #
    def email_verification
      verification_status = Organisations::VerifyAccount.call(token: params[:token])
      path = verification_paths[verification_status]
      session['new_account'] = nil
      redirect_to path
    end

    ##
    # Renders the email verified page.
    #
    # ==== Path
    #
    #    :GET /organisations/email_verified
    #
    def email_verified
      @user = User.new
    end

    ##
    # Renders the error page if verification fails.
    #
    # ==== Path
    #
    #    :GET /organisations/verification_failed
    #
    def verification_failed
      # renders static page
    end

    ##
    # Renders the verification expired page.
    #
    # ==== Path
    #
    #    :GET /organisations/verification_expired
    #
    def verification_expired
      # renders static page
    end

    private

    # Defines redirect for verification status
    def verification_paths
      {
        invalid: verification_failed_organisations_path,
        expired: verification_expired_organisations_path,
        success: email_verified_organisations_path
      }
    end

    # Check if account already created or name changed.
    def account_not_created_or_name_changed?
      new_account['account_id'].blank? || new_account['company_name'] != company_params['company_name']
    end

    # Creates Account and store details in session
    def create_new_account
      SessionManipulation::SetCompanyName.call(session: session, params: company_params)
      account_id = Organisations::CreateAccount.call(company_name: new_account['company_name'])
      SessionManipulation::SetAccountId.call(session: session, params: { 'account_id' => account_id })
    end

    # Returns the list of permitted params
    def organisations_params
      params[:organisations].try(:[], :email)&.strip!
      params[:organisations].try(:[], :email_confirmation)&.strip!

      params.require(:organisations).permit(:email, :email_confirmation, :password,
                                            :password_confirmation)
    end

    # Returns the list of permitted params
    def company_params
      return {} if params[:organisations].blank?

      params.require(:organisations).permit(:company_name, :confirm_fleet_check)
    end

    # Checks if account_id is present in the session.
    # If not, redirects to root path.
    def check_account_id
      return if new_account['account_id']

      Rails.logger.warn('Account id is missing in the session. Redirecting to :root_path')
      redirect_to root_path
    end

    # Checks if new account details is present in the session.
    # If not, redirects to root path.
    def check_account_details
      Rails.logger.warn('Checking credentials from the session')
      redirect_to root_path if (
        %w[email owner user_id account_id account_name permissions login_ip] - new_account.keys
      ).present?
    end

    # Add a new company credentials to the session
    def add_credentials_to_session
      Rails.logger.warn('Adding credentials to the session')
      new_account.merge!(
        'email' => organisations_params['email'],
        'email_confirmation' => organisations_params['email_confirmation']
      )
    end

    # Returns new account details from session
    def new_account
      (session['new_account'] || {}).stringify_keys!
    end
  end
  # rubocop:enable Metrics/ClassLength
end
