# frozen_string_literal: true

##
# Module used to show sidebar only for proper controllers
module Sidebar
  ##
  # Abstract controller class user for search vrn's flow
  #
  class BaseController < ApplicationController
    # checks if a user is logged in
    before_action :authenticate_user!
    # checks if a user belongs to proper group
    layout 'sidebar'
  end
end
