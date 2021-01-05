# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to show owner users
  #
  class UsersController < BaseController
    before_action :authenticate_user!
    before_action -> { check_permissions(allow_manage_users?) }

    ##
    # Renders manage users page
    #
    # ==== Path
    #
    #    GET /users
    #
    def index
      clear_new_user if request.referer&.include?(confirmation_users_path)
      @users = UsersManagement::AccountUsers.call(account_id: current_user.account_id,
                                                  user_id: current_user.user_id)
    end

    private

    # Clears new user data in session
    def clear_new_user
      session.delete(:new_user)
    end
  end
end
