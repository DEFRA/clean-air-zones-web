# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update name for non-primary users
  #
  class NamesController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner == false) }
    before_action :set_user_details, only: :edit_name

    ##
    # Renders the change name page for non-primary users
    #
    # ==== Path
    #
    #    :GET /non_primary_users/edit_name
    #
    def edit_name
      @errors = {}
    end

    ##
    # Performs update of the users name
    #
    # ==== Path
    #
    #    :GET /non_primary_users/update_name
    #
    def update_name
      form = AccountDetails::EditUserNameForm.new(name: params[:name])
      if form.valid?
        update_user_name(form.name)
        redirect_to non_primary_users_account_details_path
      else
        @errors = form.errors.messages
        render :edit_name
      end
    end

    private

    # Performs request to API with the :name parameter
    def update_user_name(name)
      AccountsApi::Users.update_user(
        account_id: current_user.account_id,
        account_user_id: current_user.user_id,
        name: name
      )
    end

    # Fetches user details from the API
    def set_user_details
      api_response = AccountsApi::Users.user(
        account_id: current_user.account_id,
        account_user_id: current_user.user_id
      )
      @user = AccountDetails::User.new(api_response)
    end
  end
end
