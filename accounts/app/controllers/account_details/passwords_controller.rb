# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update password for primary and non-primary users
  #
  class PasswordsController < ApplicationController
    include CheckPermissions

    ##
    # Renders the update password page
    #
    # ==== Path
    #
    #    :GET /edit_password
    #
    def edit
      @back_button_url = account_management_url
    end

    ##
    # Updates user password by calling AccountsApi::Auth.update_password
    #
    # ==== Path
    #
    #    :PATCH /edit_password
    #
    def update
      form = UpdatePasswordForm.new(
        user_id: current_user.user_id,
        old_password: params.dig(:passwords, :old_password),
        password: params.dig(:passwords, :password),
        password_confirmation: params.dig(:passwords, :password_confirmation)
      )

      return rerender_edit(form.errors.messages) unless form.valid? && form.submit

      redirect_to account_management_url
    end

    private

    # Renders :edit with assigned errors
    def rerender_edit(errors)
      @errors = errors
      render :edit
    end

    # Current user account details page path
    def account_management_url
      current_user.owner ? primary_users_account_details_path : non_primary_users_account_details_path
    end
  end
end
