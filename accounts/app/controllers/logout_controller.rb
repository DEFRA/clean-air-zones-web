# frozen_string_literal: true

##
# Controller class used to automatically sign out user
#
class LogoutController < ApplicationController
  include CazLock

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :assign_logout_notice_back_url
  skip_before_action :check_password_age
  before_action :release_lock_on_caz, only: :timedout_user

  ##
  # Renders the sign out page
  #
  # ==== Path
  #
  #    :GET /sign-out
  #
  def sign_out_page
    render 'devise/sessions/sign_out'
  end

  ##
  # Stores page to which user should be taken back after clicking `Continue` on the logout notice page.
  #
  # ==== Path
  #
  #     :POST /assign_logout_notice_back_url
  #
  def assign_logout_notice_back_url
    session[:logout_notice_back_url] = params[:logout_notice_back_url]
    head :no_content
  end

  ##
  # Renders the logout notice page
  #
  # ==== Path
  #
  #    :GET /logout_notice
  #
  def logout_notice
    @back_button_url = session[:logout_notice_back_url]
    render 'devise/sessions/logout_notice'
  end

  ##
  # Logs out user and redirects him to login page with notice about timeout.
  #
  # ==== Path
  #
  #    :GET /timedout_user
  #
  def timedout_user
    sign_out(current_user)
    flash[:notice] = I18n.t('inactivity_logout')
    redirect_to new_user_session_path
  end
end
