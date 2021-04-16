# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to manage account cancellation
  #
  class AccountCancellationsController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner) }, except: :account_closed
    skip_before_action :authenticate_user!, only: :account_closed

    ##
    # Renders a page informing about account closing process and renders form with confirmation.
    #
    # ==== Path
    #
    #    GET /account_closing_notice
    #
    def account_closing_notice
      # renders static page
    end

    ##
    # Verifies the provided params and redirects either to account cancellation form or redirects back
    # to primary user management page
    #
    # ==== Path
    #
    #    POST /account_closing_notice
    #
    def confirm_account_closing_notice
      @form = AccountDetails::CancellationConfirmationForm.new(confirm_close_account_param)
      if @form.valid?
        redirect_to @form.confirmed? ? account_cancellation_path : primary_users_account_details_path
      else
        flash.now[:alert] = confirmation_error(@form)
        render :account_closing_notice
      end
    end

    ##
    # Renders the account cancellation form for the primary user.
    #
    # ==== Path
    #
    #    GET /account_cancellation
    #
    def account_cancellation
      @form = AccountDetails::AccountCancellationForm.new
    end

    ##
    # Closes the account by calling AccountDetails::CloseAccount service
    #
    # ==== Path
    #
    #    POST /account_cancellation
    #
    def submit_account_cancellation
      @form = AccountDetails::AccountCancellationForm.new(reason: reason_param)
      if @form.valid?
        AccountDetails::CloseAccount.call(account_id: account_id, reason: reason_param)
        sign_out current_user
        redirect_to account_closed_path
      else
        flash.now[:alert] = @form.first_error_message
        render :account_cancellation
      end
    end

    ##
    # Renders the page informing about the account closure
    #
    # ==== Path
    #
    #   GET /account_closed
    def account_closed
      # renders static page
    end

    private

    # Extract 'confirm-close-account' from params
    def confirm_close_account_param
      params['confirm-close-account']
    end

    # Extract 'reason' from params
    def reason_param
      params[:reason]
    end

    # account_id associated with the current_user
    def account_id
      current_user.account_id
    end
  end
end
