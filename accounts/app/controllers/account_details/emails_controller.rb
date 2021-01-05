# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update name for primary users
  #
  class EmailsController < ApplicationController
    include CheckPermissions
    include Devise::Models::RemoteAuthenticatable

    skip_before_action :authenticate_user!, only: %i[confirm_email validate_confirm_email]
    before_action -> { check_permissions(current_user.owner == true) }, except:
      %i[confirm_email validate_confirm_email]
    before_action :set_user_details, only: :edit_email

    ##
    # Renders the change email email address page for primary users
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_email
    #
    def edit_email
      @errors = {}
    end

    ##
    # Performs update of the users email address
    #
    # ==== Path
    #
    #    :POST /primary_users/update_email
    #
    def update_email
      form = AccountDetails::EditUserEmailForm.new(email_params)
      if form.valid?
        update_email_and_redirect(form)
      else
        render_edit_email(form)
      end
    rescue BaseApi::Error400Exception
      form.add_invalid_email_errors
      render_edit_email(form)
    end

    ##
    # Renders the email sent page
    #
    # ==== Path
    #
    #    :GET /primary_users/email_sent
    #
    def email_sent
      @email = session[:owners_new_email]
    end

    ##
    # Call api which will resend a verification email after changing email process
    #
    # ==== Path
    #
    #    :GET /primary_users/resend_email
    #
    def resend_email
      update_owner_email(session[:owners_new_email])
      redirect_to email_sent_primary_users_path
    end

    ##
    # Renders the email address updated page
    #
    # ==== Path
    #
    #    :GET /primary_users/confirm_email
    #
    # ==== Params
    # * +token+ - uuid, required in the query
    #
    def confirm_email
      @token = params[:token]
    end

    ##
    # Validates the token and password by calling AccountsApi::Users.confirm_email
    #
    # ==== Path
    #
    #    :GET /primary_users/validate_confirm_email
    #
    # ==== Params
    # * +token+ - token from the email, passes as a hidden param in the form
    # * +passwords+ - hash
    #   * +password+ - string, submitted password
    #   * +password_confirmation+ - string, submitted password confirmation
    #
    def validate_confirm_email
      service = AccountDetails::UpdateEmail.call(
        password: params.dig(:passwords, :password),
        password_confirmation: params.dig(:passwords, :password_confirmation),
        token: params[:token]
      )
      if service.valid?
        sign_in_and_redirect(service)
      else
        render_confirm_email(service.errors)
      end
    end

    private

    # Fetches user details from the API
    def set_user_details
      api_response = AccountsApi::Users.user(
        account_id: current_user.account_id,
        account_user_id: current_user.user_id
      )
      @user = AccountDetails::User.new(api_response)
    end

    # Renders :confirm_email with assigned errors and token
    def render_confirm_email(errors)
      @token = params[:token]
      @errors = errors
      render :confirm_email
    end

    # Redirects to the dashboard page if user already logged in
    # If not, calling api and sign in via devise helper method before redirect
    def sign_in_and_redirect(service)
      return redirect_to dashboard_path if current_user

      user = authentication({
                              email: service.new_user_email,
                              password: service.password,
                              login_ip: request.remote_ip
                            })
      sign_in(user)
      redirect_to dashboard_path
    end

    # Update user email and redirect to the email send page
    def update_email_and_redirect(form)
      update_owner_email(form.email)
      session[:owners_new_email] = form.email
      redirect_to email_sent_primary_users_path
    end

    # downcase email params
    def email_params
      {
        email: params[:email].downcase.strip,
        confirmation: params[:confirmation].downcase.strip,
        account_id: current_user.account_id,
        current_email: current_user.email
      }
    end

    # Sends request to API with change email request
    def update_owner_email(email)
      AccountsApi::Auth.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email,
        confirm_url: confirm_email_primary_users_url
      )
    end

    # Renders :edit_email with assigned errors
    def render_edit_email(form)
      @errors = form.errors.messages
      render :edit_email
    end
  end
end
