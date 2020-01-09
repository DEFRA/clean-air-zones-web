# frozen_string_literal: true

##
# Controller class for 2 final steps of checking the vehicle compliance
#
class AirZonesController < ApplicationController
  # rescues also from 404 -> the rest is in ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_server_unavailable
  # 422 HTTP status from API means vehicle data incomplete so the compliance calculation is not possible.
  rescue_from BaseApi::Error422Exception, with: :unable_to_determine_compliance

  # checks if vrn is present in the session
  before_action :check_vrn

  ##
  # Renders a form for a CAZ selection based on available CAZs.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.clean_air_zones] for the CAZ list.
  #
  # ==== Path
  #    GET /air_zones/caz_selection
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.clean_air_zones]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def caz_selection
    @clean_air_zones = ComplianceCheckerApi.clean_air_zones
                                           .map { |caz_data| Caz.new(caz_data) }
                                           .sort_by(&:name)

    @checked_zones = session[:checked_zones]
  end

  ##
  # Renders a result of checking compliance of the vehicle against selected CAZ.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance] for the results.
  #
  # ==== Path
  #    POST /air_zones/caz_selection
  #
  # +GET+ will result with redirect to {caz_selection}[rdoc-ref:AirZonesController.caz_selection]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +caz+ - list of the selected CAZ ids, required in the query params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  # * +caz+ - no selected CAZ redirects back to {caz_selection}[rdoc-ref:AirZonesController.caz_selection]
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def compliance
    form = CazForm.new(caz)
    return redirect_to_caz_selection(form) unless form.valid?

    session[:checked_zones] = caz
    @compliance_outcomes = Compliance.new(vrn, caz).compliance_outcomes
    @vrn = vrn
  end

  private

  # Returns a list of Clean Air Zones from params
  def caz
    params[:caz]
  end

  # redirects to caz selection page and clear checked_zones from session
  def redirect_to_caz_selection(form)
    log_invalid_form 'Redirecting back to :caz_selection.'
    clear_checked_la
    redirect_to caz_selection_air_zones_path, alert: form.message
  end

  # Redirects to 'Unable to determine compliance' page
  def unable_to_determine_compliance
    redirect_to cannot_determinate_vehicle_checkers_path
  end
end
