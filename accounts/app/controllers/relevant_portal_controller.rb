# frozen_string_literal: true

##
# Controller used to check which portal is relevant for the user.
#
class RelevantPortalController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_password_age
  before_action :set_relevant_portal

  ##
  # Renders the form to check the relevant portal for the user
  #
  # ==== Path
  #    GET /what_would_you_like_to_do
  #
  def what_would_you_like_to_do
    # renders form
  end

  ##
  # Check provided answer and redirect too relevant portal.
  #
  # ==== Path
  #    POST /what_would_you_like_to_do
  #
  def submit_what_would_you_like_to_do
    form = RelevantPortalForm.new(params[:check_vehicle_option])
    if form.valid?
      redirect_to determine_relevant_portal_path(params[:check_vehicle_option])
    else
      flash.now.alert = form.first_error_message
      render :what_would_you_like_to_do
    end
  end

  private

  # chooses rlevant portal url based on the provided option choosen by user.
  def determine_relevant_portal_path(check_vehicle_option)
    if check_vehicle_option == 'single'
      "#{Rails.configuration.x.check_air_standard_url}/vehicle_checkers/enter_details"
    else
      root_path
    end
  end

  # Sets relevant portal variable to hide menu from the navbar.
  def set_relevant_portal
    @relevant_portal = true
  end
end
