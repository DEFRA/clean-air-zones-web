# frozen_string_literal: true

##
# Module used to show sidebar only for proper controllers
module Sidebar
  ##
  # Controller class for managing vrn's in database
  #
  class RemoveVehiclesController < BaseController
    # 404 HTTP status from API mean vehicle in not found in database. Redirects to the not found page.
    rescue_from BaseApi::Error404Exception, with: :vrn_not_found
    # checks if VRN is present in the session
    before_action :check_remove_vrn, only: %i[confirm_remove delete]

    ##
    # Renders the remove vehicle page
    #
    # ==== Path
    #    :GET /vehicles/remove
    #
    def remove
      # render static page
    end

    ##
    # Validates submitted VRN. If successful, redirects to {confirm_remove}
    # [rdoc-ref:RemoveVehiclesController.confirm_remove]
    #
    # Any invalid params values triggers rendering {remove}
    # [rdoc-ref:RemoveVehiclesController.remove] with @errors displayed
    #
    # ==== Path
    #    :POST /vehicles/remove
    #
    def submit_remove
      form = VrnForm.new(params[:vrn])
      if form.valid?
        session[:remove_vrn] = parsed_vrn(params[:vrn])
        redirect_to confirm_remove_vehicles_path
      else
        @errors = form.errors.messages[:vrn]
        render :remove
      end
    end

    ##
    # Renders the confirm remove vehicle page
    #
    # ==== Path
    #    :GET /vehicles/confirm_remove
    #
    def confirm_remove
      # render static page
    end

    ##
    # If +confirmation+ is 'yes' it calls {api} [rdoc-ref:WhitelistApi.delete] and redirects to the remove vehicles page
    # If +confirmation+ is 'no' it redirects to the remove vehicles page
    #
    # ==== Path
    #    :POST /vehicles/confirm_remove
    #
    def delete
      if confirmation
        determinate_next_step
      else
        @errors = I18n.t('confirm_remove_vrn_form.errors.answer_required')
        render :confirm_remove
      end
    end

    private

    def confirmation
      params.dig(:confirm_remove_form, :confirmation)
    end

    # Redirects to {vehicle not found}[rdoc-ref:RemoveVehiclesController.not_found]
    def vrn_not_found
      flash[:warning] = I18n.t('confirm_remove_vrn_form.vrn_not_exist', vrn: remove_vrn)
      redirect_to remove_vehicles_path
    end

    # Checks if VRN is present in session.
    # If not, redirects to [rdoc-ref:RemoveVehiclesController.remove]
    def check_remove_vrn
      return if remove_vrn

      redirect_to remove_vehicles_path
    end

    # Gets VRN from session. Returns string, eg 'CU1234'
    def remove_vrn
      session[:remove_vrn]
    end

    # If +confirmation+ is 'yes' it call {remove_vrn}[rdoc-ref:WhitelistApi.remove_vrn] and add the message to alert
    # Then redirects to [rdoc-ref:RemoveVehiclesController.remove]
    #
    def determinate_next_step
      if confirmation == 'yes'
        WhitelistApi.delete_vrn(remove_vrn, current_user.preferred_username, current_user.email)
        message = I18n.t('confirm_remove_vrn_form.vrn_removed', vrn: remove_vrn)
      end
      session[:remove_vrn] = nil
      flash[:success] = message
      redirect_to remove_vehicles_path
    end
  end
end
