# frozen_string_literal: true

##
# Module used to show sidebar only for proper controllers
module Sidebar
  ##
  # Controller class for managing vrn's in database
  #
  # rubocop:disable Metrics/ClassLength
  class VehiclesController < BaseController
    # 404 HTTP status from API mean vehicle in not found in database. Redirects to the not found page.
    rescue_from BaseApi::Error404Exception, with: :vrn_not_found
    # 422 HTTP status from API mean vehicle is already present in database. Redirects to the proper page.
    rescue_from BaseApi::Error422Exception, with: :vrn_exists
    # checks if VRN is present in the session
    before_action :check_vrn, only: %i[index historic_search]
    before_action :check_results, only: %i[historic_search]

    ##
    # Renders the search page
    #
    # ==== Path
    #    :GET /vehicles/search
    #
    def search
      @errors = {}
    end

    ##
    # Validates submitted VRN. If successful, redirects to {details}[rdoc-ref:index].
    #
    # Any invalid params values triggers rendering {search page}[rdoc-ref:search] with @errors
    # displayed.
    #
    # ==== Path
    #    :POST /vehicles/submit_search
    #
    def submit_search
      form = SearchVrnForm.new(adjusted_params)
      if form.valid?
        session[:vrn] = form.vrn
        determinate_results_page(form)
      else
        @errors = form.errors.messages
        render :search
      end
    end

    ##
    # Renders search results page
    #
    # ==== Path
    #    :GET /vehicles
    #
    def index
      @vrn_details = VrnDetails.new(vrn)
    end

    ##
    # Renders the historical results page
    #
    # ==== Path
    #    :GET /vehicles/historic_search
    #
    def historic_search
      @vrn = vrn
      @pagination = @vrn_details.pagination
    end

    ##
    # Renders add a vrn page
    #
    # ==== Path
    #    :GET /vehicles/add
    #
    def add
      # renders static page
    end

    ##
    # Validates the new vrn form and redirects to success page if form valid and api returns created status.
    # If not returns to add a vrn page
    #
    # ==== Path
    #    :POST /vehicles/add
    #
    def create
      form = NewVrnForm.new(adjusted_new_vrn_params)
      if form.valid?
        call_api_and_redirect
      else
        @errors = transform_errors(form.errors.messages)
        render :add
      end
    end

    private

    # Redirects to {search}[rdoc-ref:VehiclesController.search]
    def vrn_not_found
      flash[:warning] = I18n.t('search_vrn_form.errors.not_found', vrn: session[:vrn])
      redirect_to search_vehicles_path
    end

    # renders add a vrn page with error message
    def vrn_exists
      @vrn = vrn
      @errors = { vrn_exists: I18n.t('add_vrn_form.errors.vrn_exists') }
      render :add
    end

    # Checks if VRN is present in session.
    # If not, redirects to VehiclesController#search
    def check_vrn
      return if vrn

      redirect_to search_vehicles_path
    end

    # Returns the list of permitted params and uppercased +vrn+ without any space, eg. 'CU1234'
    def adjusted_new_vrn_params
      strong_params = params.require(:new_vrn_form).permit(
        :vrn,
        :category,
        :manufacturer,
        :reason
      )
      strong_params['vrn'] = strong_params['vrn']&.delete(' ')&.upcase
      strong_params
    end

    # keep only first error message for each attribute
    def transform_errors(errors)
      errors.each_with_object({}) do |error, hash|
        hash[error.first] = error.second.first
      end
    end

    # Call API to add a new vrn and redirects to success page
    def call_api_and_redirect
      session[:vrn] = adjusted_new_vrn_params[:vrn]
      WhitelistApi.add_vrn(adjusted_new_vrn_params, current_user)
      flash[:success] = I18n.t('add_vrn_form.success', vrn: session[:vrn])
      redirect_to add_vehicles_path
    end

    # Gets Start Date from session. Returns string, eg '2010-01-01'
    def start_date
      session[:start_date]
    end

    # Gets End Date from session. Returns string, eg '2020-03-24'
    def end_date
      session[:end_date]
    end

    # Returns the list of permitted params and uppercased +vrn+ without any space, eg. 'CU1234'
    def adjusted_params
      strong_params = params.require(:search).permit(
        :vrn, :historic, :start_date_day, :start_date_month, :start_date_year, :end_date_day,
        :end_date_month, :end_date_year
      )
      strong_params['vrn'] = strong_params['vrn']&.delete(' ')&.upcase
      strong_params
    end

    # Returns redirect to the results page depending on the +historic+ value
    def determinate_results_page(form)
      if form.historic == 'true'
        session[:start_date] = form.start_date
        session[:end_date] = form.end_date
        redirect_to historic_search_vehicles_path
      else
        redirect_to vehicles_path
      end
    end

    # Calls api and returns paginated list of vehicle's information
    # Redirects to search vehicle page if no records found
    def check_results
      page = (params[:page] || 1).to_i
      @vrn_details = HistoricalVrnDetails.new(vrn, page, start_date, end_date)
      return unless @vrn_details.total_changes_count_zero?

      assign_flash_warning
      redirect_to search_vehicles_path
    end

    # Assign flash warning
    def assign_flash_warning
      flash[:warning] = I18n.t('search_vrn_form.errors.historic_not_found',
                               vrn: session[:vrn],
                               start_date: @vrn_details.parsed_start_date,
                               end_date: @vrn_details.parsed_end_date)
    end
  end
  # rubocop:enable Metrics/ClassLength
end
