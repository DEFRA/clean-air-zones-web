# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Base Controller class used for helper methods
  #
  class BaseController < ApplicationController
    include CheckPermissions

    rescue_from BaseApi::Error404Exception, with: :user_not_found

    private

    # Redirects to {not_found page}[rdoc-ref:ErrorsController.not_found]
    def user_not_found
      redirect_to not_found_path
    end

    # account_user_id from params
    def account_user_id
      params['id']
    end
  end
end
