# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to handle primary user company name updates
  #
  class OrganisationNamesController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner) }

    ##
    # Renders update company name page
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_name
    #
    def edit_name
      api_response = AccountsApi::Users.account_details(account_user_id: current_user.user_id)
      @user = AccountDetails::User.new(api_response)
    end

    ##
    # Performs update of the users company name
    #
    # ==== Path
    #
    #    :GET /primary_users/update_name
    #
    def update_name
      AccountDetails::UpdateCompanyName.call(
        account_id: current_user.account_id,
        company_name: params[:company_name]
      )
      redirect_to primary_users_account_details_path
    rescue InvalidCompanyNameException, UnableToCreateAccountException => e
      @error = e.message
      render :edit_name
    end
  end
end
