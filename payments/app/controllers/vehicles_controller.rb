# frozen_string_literal: true

##
# Controls the first steps of the payment process regarding user's vehicle data.
#
class VehiclesController < ApplicationController # rubocop:disable Metrics/ClassLength
  # 404 HTTP status from API mean vehicle in not found in DLVA database. Redirects to the proper page.
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

  # checks if VRN is present in the session
  before_action :check_vrn, except: %i[enter_details submit_details not_determined]
  skip_around_action :handle_history, only: %i[enter_details submit_details]

  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicles/enter_details
  #
  def enter_details
    @errors = {}
    hide_inputs_if_coming_from_successful_payment
  end

  ##
  # Validates submitted VRN. If successful, adds submitted VRN to the session and
  # redirects to {details}[rdoc-ref:VehiclesController.details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehiclesController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehiclesController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicles/submit_details
  #
  # GET method redirects to {enter details}[rdoc-ref:VehiclesController.enter_details]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  # * +registration-country+ - country of the vehicle registration, UK or NON-UK, required in the query
  #
  # ==== Validations
  # Validations are done by {VrnForm}[rdoc-ref:VrnForm]
  #
  def submit_details
    form = VrnForm.new(session, params[:vrn], country)

    if form.valid?
      form.submit
      redirect_to form.redirection_path
    else
      rerender_enter_details(form)
    end
  end

  ##
  # Renders vehicle details form.
  #
  # ==== Path
  #
  #    GET /vehicles/details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def details
    process_details_action
  end

  ##
  # Verifies if user confirms the vehicle's details.
  # If yes, renders to {incorrect details}[rdoc-ref:VehiclesController.local_authority]
  # If no, redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  # ==== Path
  #    POST /vehicles/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  def confirm_details
    form = ConfirmationForm.new(confirmation)
    if form.valid?
      redirect_to process_detail_form(form)
    else
      redirect_to details_vehicles_path(id: transaction_id), alert: form.error_message
    end
  end

  ##
  # Renders vehicle UK registered page
  #
  # ==== Path
  #
  #    GET /vehicles/uk_registered_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def uk_registered_details
    process_details_action
  end

  ##
  # Verifies if user confirms the vehicle's details.
  # If yes, redirects to {local authority}[rdoc-ref:local_authority]
  # If no, redirects to {incorrect details}[rdoc-ref:incorrect_details]
  #
  # ==== Path
  #    POST /vehicles/confirm_uk_registered_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  def confirm_uk_registered_details
    form = ConfirmationForm.new(confirmation)
    if form.valid?
      redirect_to process_detail_form(form)
    else
      redirect_to uk_registered_details_vehicles_path(id: transaction_id), alert: form.error_message
    end
  end

  ##
  # Renders a static page for users who selected that DVLA data in incorrect.
  #
  # ==== Path
  #
  #    GET /vehicles/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def incorrect_details
    # Used to determine the previous step in ChargesController#local_authority
    SessionManipulation::SetIncorrect.call(session: session)
    @return_path = if vehicle_details('possible_fraud')
                     uk_registered_details_vehicles_path
                   else
                     details_vehicles_path
                   end
  end

  ##
  # Renders a static page for users who selected that DVLA data is incorrect.
  #
  # ==== Path
  #
  #    GET /vehicles/unrecognised
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def unrecognised
    @vrn = vrn
  end

  ##
  # Verifies if user confirms that the registration number is correct.
  # If yes, renders to {choose type}[rdoc-ref:NonDvlaVehiclesController.choose_type]
  # If no, redirects to {non_dvla_vehicles}[rdoc-ref:VehiclesController.unrecognised]
  #
  # ==== Path
  #    POST /vehicles/confirm_unrecognised
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-registration+ - user confirmation that the registration number is correct.
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-registration+ - lack of it redirects to {non_dvla_vehicles}[rdoc-ref:VehiclesController.unrecognised]
  #
  def confirm_unrecognised
    form = ConfirmationForm.new(params['confirm-registration'])
    if form.confirmed?
      perform_unrecognised_vehicle_redirect
    else
      redirect_to unrecognised_vehicles_path, alert: true
    end
  end

  ##
  # Renders a static page for users which VRN is recognised as not determined
  #
  # ==== Path
  #
  #    GET /vehicles/not_determined
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def not_determined
    @types = VehicleTypes.call
  end

  ##
  # Renders a static page for users which VRN is recognised as compliant (no charge in all LAs)
  #
  # ==== Path
  #
  #    GET /vehicles/compliant
  #
  def compliant
    # Renders a static page
  end

  ##
  # Renders a static page for users which VRN is recognised as exempt
  #
  # ==== Path
  #
  #    GET /vehicles/exempt
  #
  def exempt
    render :compliant
  end

  ##
  # Verifies if user choose a type of vehicle.
  # If yes, renders {local authorities}[rdoc-ref:LocalAuthoritiesController.index]
  # If no, redirects to {choose_type}[rdoc-ref:VehiclesController.not_determined]
  #
  # ==== Path
  #
  #    POST /vehicles/submit_type
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +vehicle-type+ - user's type of vehicle
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +vehicle-type+ - lack of it redirects to {choose_type}[rdoc-ref:VehiclesController.not_determined]
  #
  def submit_type
    type = params['vehicle-type']
    if type.blank?
      redirect_to not_determined_vehicles_path, alert: true
    else
      SessionManipulation::SetType.call(session: session, type: type)
      redirect_to local_authority_charges_path
    end
  end

  private

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle']
  end

  # Returns vehicles's registration country from the query params, values: 'UK', 'Non-UK', nil
  def country
    params['registration-country']
  end

  # Process action which is done on submit details and uk registered details
  def process_details_action # rubocop:disable Metrics/AbcSize
    @vehicle_details = VehicleDetails.new(vrn)
    return redirect_to(exempt_vehicles_path(id: transaction_id)) if @vehicle_details.exempt?

    SessionManipulation::SetWeeklyTaxi.call(session: session) if @vehicle_details.weekly_taxi?
    SessionManipulation::SetType.call(session: session, type: @vehicle_details.type)
    SessionManipulation::SetUndetermined.call(session: session) if @vehicle_details.undetermined
    SessionManipulation::SetUndeterminedTaxi.call(session: session) if @vehicle_details.undetermined_taxi?
  end

  # Checks if the unrecognized vehicle is a taxi and performs a proper redirect
  def perform_unrecognised_vehicle_redirect
    registered_taxi = RegisterDetails.new(vrn).register_taxi?
    if registered_taxi
      SessionManipulation::SetUndeterminedTaxi.call(session: session)
      redirect_to local_authority_charges_path
    else
      SessionManipulation::SetUnrecognised.call(session: session)
      redirect_to choose_type_non_dvla_vehicles_path
    end
  end

  # Redirects to {vehicle not found}[rdoc-ref:VehiclesController.unrecognised_vehicle]
  def vehicle_not_found
    redirect_to unrecognised_vehicles_path(id: transaction_id)
  end

  # Renders enter_details page and log errors
  def rerender_enter_details(form)
    @hide_session_values = true
    @errors = form.errors.messages
    render enter_details_vehicles_path
  end

  # persists whether or not vehicle details are correct into session and returns correct onward path
  def process_detail_form(form)
    SessionManipulation::SetConfirmVehicle.call(session: session, confirm_vehicle: form.confirmed?)
    return incorrect_details_vehicles_path(id: transaction_id) unless form.confirmed?
    return not_determined_vehicles_path(id: transaction_id) if confirmed_undetermined?

    local_authority_charges_path(id: transaction_id)
  end

  # check if user confirmed details for undetermined vehicle
  def confirmed_undetermined?
    session['vehicle_details']['undetermined'].present?
  end

  # Hide VRN and country when paying for another vehicle from the success payment page
  def hide_inputs_if_coming_from_successful_payment
    return unless request.referer&.include?(success_payments_path)

    @hide_session_values = true
  end
end
