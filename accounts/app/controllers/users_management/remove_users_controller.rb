# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to remove users
  #
  class RemoveUsersController < BaseController
    include UsersHelper
    before_action :authenticate_user!
    before_action -> { check_permissions(allow_manage_users?) }
    before_action -> { check_account_ownership?(account_user_id) }
    before_action :check_edit_user

    ##
    # Renders the user removal confirmation page
    #
    # ==== Path
    #
    #    GET /users/:id/remove
    #
    def remove
      @is_mandate_creator = UsersManagement::IsDirectDebitCreator.call(
        account_id: current_user.account_id,
        account_user_id: params[:id]
      )

      return unless @is_mandate_creator

      email_fetcher = UsersManagement::EmailFetcher.new(account_id: current_user.account_id)
      @user_email = email_fetcher.for_account_user(params[:id])
      @owner_email = email_fetcher.for_owner
    end

    ##
    # Removes the user from the account if the user confirms this
    #
    # ==== Path
    #
    #    POST /users/:id/remove
    #
    def confirm_remove
      if confirmation
        process_user_deletion
      else
        flash.now[:alert] = I18n.t('remove_user.choose_answer')
        render :remove
      end
    end

    private

    # Calls api if user deletion confirmed or redirect to users page
    def process_user_deletion
      if confirmation == 'yes'
        AccountsApi::Users.delete_user(account_id: current_user.account_id, account_user_id: account_user_id)
        flash[:success] = I18n.t('remove_user.removed', full_user_name: full_user_name)
        redirect_to users_path
      else
        redirect_to edit_user_path(account_user_id)
      end
    end

    # user remove confirmation, e.g 'yes'
    def confirmation
      params['confirm-remove-user']
    end

    # Checks edit user data in session, redirect to manage users page if data missing
    def check_edit_user
      return if full_user_name

      Rails.logger.warn 'Edit user data is missing in the session. Redirecting to manage users page'
      redirect_to users_path
    end

    # Returns edit user name
    def full_user_name
      session.dig(:edit_user, 'name')
    end
  end
end
