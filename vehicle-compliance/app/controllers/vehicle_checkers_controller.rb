# frozen_string_literal: true

##
# Controller class for first steps of checking the vehicle compliance
#
class VehicleCheckersController < ApplicationController
  # 404 HTTP status from API mean vehicle in not found in DLVA database. Redirects to the proper page.
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

  # checks if VRN is present in the session
  before_action :check_vrn, except: %i[enter_details submit_details]

  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicle_checkers/enter_details
  #
  def enter_details
    @errors = {}
  end

  ##
  # Validates submitted VRN. If successful, adds submitted VRN to the session and
  # redirects to {confirm details}[rdoc-ref:VehicleCheckersController.confirm_details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehicleCheckersController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicle_checkers/submit_details
  #
  # GET method redirects to {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  # * +registration-country+ - country of the vehicle registration, UK or NON-UK, required in the query
  #
  # ==== Validations
  # Validations are done by {VrnForm}[rdoc-ref:VrnForm]
  #
  def submit_details
    form = VrnForm.new(parsed_vrn, country)
    unless form.valid?
      @errors = form.error_object
      log_invalid_form 'Rendering :enter_details.'
      return render enter_details_vehicle_checkers_path
    end

    add_vrn_to_session
    redirect_to non_uk? ? non_uk_vehicle_checkers_path : confirm_details_vehicle_checkers_path
  end

  ##
  # Renders vehicle details form.
  # To do it, performs {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_details] for given VRN
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db - redirects to {number not found}[rdoc-ref:VehicleCheckersController.number_not_found]
  # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN - redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error - redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  #
  # Other connection exceptions also redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def confirm_details
    @vehicle_details = VehicleDetails.new(vrn)
    return unless @vehicle_details.exempt?

    Rails.logger.info "Vehicle with VRN #{vrn} is exempt. Redirecting to :exemption"
    redirect_to exemption_vehicle_checkers_path
  end

  ##
  # Verifies if user confirms data returned from the API.
  # If yes, redirects to {the next step}[rdoc-ref:AirZonesController.caz_selection] of the checking compliance process.
  # If no, redirects to {incorrect details}[rdoc-ref:VehicleCheckersController.incorrect_details]
  #
  # ==== Path
  #    GET /vehicle_checkers/user_confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects back to {confirm details}[rdoc-ref:VehicleCheckersController.confirm_details]
  #
  def user_confirm_details
    form = ConfirmationForm.new(confirmation, undetermined)
    unless form.valid?
      log_invalid_form 'Redirecting back.'
      return redirect_to confirm_details_vehicle_checkers_path, alert: form.message
    end
    determinate_next_page(form)
  end

  ##
  # Renders a static page for users who selected that DVLA data in incorrect
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def incorrect_details
    # to be defined later
  end

  ##
  # Renders a page for not found vehicles. Returns HTTP status 404 (not found)
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/number_not_found
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def number_not_found
    @vehicle_registration = vrn
    render(status: :not_found)
  end

  ##
  # Renders a page for vehicles exempt from the charges in all CAZs.
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/exemption
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def exemption
    @vehicle_registration = vrn
  end

  ##
  # Renders a Cannot determine compliance page
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/cannot_determinate
  #
  def cannot_determinate
    @vehicle_registration = vrn
  end

  ##
  # Renders a page for vehicles that are not registered within the UK
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/non_uk
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def non_uk
    @vehicle_registration = vrn
  end

  private

  # Returns uppercased VRN from the query params without any space, eg. 'CU1234'
  def parsed_vrn
    @parsed_vrn ||= params[:vrn].upcase&.delete(' ')
  end

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle']
  end

  # Returns vehicles's registration country from the query params, values: 'UK', 'Non-UK', nil
  def country
    params['registration-country']
  end

  # Returns status for the vehicle type, values: 'true', 'false'
  def undetermined
    params['undetermined']
  end

  # Checks if selected registration country equals Non-UK.
  # Returns boolean.
  def non_uk?
    country == 'Non-UK'
  end

  # Redirects to {number not found}[rdoc-ref:VehicleCheckersController.number_not_found]
  def vehicle_not_found
    redirect_to number_not_found_vehicle_checkers_path
  end

  ##
  # ==== Params
  # * +undetermined+ - status for the vehicle type if it is not possible to determine, eg. 'true'

  # Verifies if vehicles's registration not determined and if user confirms data returned from the API.
  # If vehicles's registration form was not confirmed, redirects to
  #   {incorrect details}[rdoc-ref:VehicleCheckersController.incorrect_details]
  # If vehicles's registration not determined redirects to
  #   {the next step}[rdoc-ref:VehicleCheckersController.cannot_determinate] of the checking compliance process.
  # If vehicles's registration determined redirects to
  #   {the next step}[rdoc-ref:AirZonesController.caz_selection] of the checking compliance process.
  #
  def determinate_next_page(form)
    return redirect_to incorrect_details_vehicle_checkers_path unless form.confirmed?

    if form.undetermined?
      redirect_to cannot_determinate_vehicle_checkers_path
    else
      redirect_to caz_selection_air_zones_path
    end
  end

  # add vrn to session and clear checked_zones from session
  def add_vrn_to_session
    session[:vrn] = parsed_vrn
    clear_checked_la
  end
end
