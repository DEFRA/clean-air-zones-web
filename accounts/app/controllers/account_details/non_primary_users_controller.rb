# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to manage the non-primary user settings
  #
  class NonPrimaryUsersController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner == false) }

    ##
    # Renders the management page for non-primary users.
    #
    # ==== Path
    #
    #    :GET /non_primary_account_details
    #
    def non_primary_account_details
      api_response = AccountsApi::Users.account_details(account_user_id: current_user.user_id)
      @user = AccountDetails::User.new(api_response)
    end
  end
end
