# frozen_string_literal: true

##
# Controller class for final steps of checking the vehicle compliance
#
class AirZonesController < ApplicationController
  # rescues also from 404 -> the rest is in ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_server_unavailable
  # 422 HTTP status from API means vehicle data incomplete so the compliance calculation is not possible.
  rescue_from BaseApi::Error422Exception, with: :unable_to_determine_compliance
  # checks if vrn is present in the session
  before_action :check_vrn

  ##
  # Renders a result of checking compliance of the vehicle against selected CAZ.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance] for the results.
  #
  # ==== Path
  #    GET /air_zones/compliance
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def compliance
    compliance = Compliance.new(vrn)
    @phgv_discount_available = compliance.phgv_discount_available?
    @compliance_outcomes = compliance.compliance_outcomes
    @any_caz_chargeable = compliance.any_caz_chargeable?
    @vrn = vrn
  end

  ##
  # Renders a static page which looks like a result of checking compliance of the vehicle against selected CAZ.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance] for the results.
  #
  # ==== Path
  #    GET /air_zones/non_uk_compliance
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def non_uk_compliance
    @compliance_outcomes = ComplianceCheckerApi
                           .clean_air_zones
                           .map { |caz| NonUkCompliantVehicleDetails.new(caz) }
    @vrn = vrn
    render 'air_zones/compliance'
  end

  private

  # Redirects to 'Unable to determine compliance' page
  def unable_to_determine_compliance
    redirect_to cannot_determine_vehicle_checkers_path
  end
end
