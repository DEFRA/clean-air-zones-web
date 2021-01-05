# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to edit users
  #
  class EditUsersController < BaseController
    include UsersHelper
    include PaymentFeatures

    before_action :authenticate_user!
    before_action -> { check_permissions(allow_manage_users?) }
    before_action -> { check_account_ownership?(account_user_id) }
    before_action :check_edit_user, only: %w[update]

    # Handle Bath D-Day notice
    before_action :assign_payment_enabled, only: :edit
    before_action :assign_bath_d_day_date, only: :edit

    ##
    # Renders the manage user permissions page
    #
    # ==== Path
    #
    #    GET /users/:id/edit
    #
    def edit
      api_response = AccountsApi::Users.user(account_id: current_user.account_id,
                                             account_user_id: account_user_id)
      SessionManipulation::SetEditUser.call(session: session, params: api_response)
      @user = UsersManagement::EditUser.new(api_response, account_user_id)
    end

    ##
    # Validates user input and call api to update user permissions
    #
    # ==== Path
    #
    #    PATCH /users/:id/update
    #
    def update
      form = UsersManagement::EditUserForm.new(
        account_id: current_user.account_id,
        account_user_id: account_user_id,
        permissions: params.dig(:edit_user, 'permissions')
      )
      handle_edit_user_form(form)
    end

    private

    # Validates user input and calls api to update the user permissions
    def handle_edit_user_form(form)
      if form.valid?
        form.submit
        redirect_to users_path
      else
        flash[:errors] = form.error_message
        redirect_to edit_user_path
      end
    end

    # Checks edit user data in session, redirect to manage users page if data missing
    def check_edit_user
      return if permissions

      Rails.logger.warn 'Edit user data is missing in the session. Redirecting to manage users page'
      redirect_to users_path
    end

    # Returns edit user permissions
    def permissions
      session.dig(:edit_user, 'permissions')
    end
  end
end
