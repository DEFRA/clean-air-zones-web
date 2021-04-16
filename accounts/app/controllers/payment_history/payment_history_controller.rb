# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Controller used to show detailed information about the all company and users payments
  #
  class PaymentHistoryController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(allow_view_details_history?) }, only: :payment_history_details

    ##
    # Renders the payment history page
    #
    # ==== Path
    #
    #    :GET /payment_history
    #
    def payment_history
      check_history_permissions
      @back_button_url = determinate_back_link_url
    rescue BaseApi::Error400Exception
      return redirect_to payment_history_path unless page_number == 1
    end

    ##
    # Renders the payment details page
    #
    # ==== Path
    #
    #    :GET /payment_history_details
    #
    def payment_history_details
      @details =  PaymentHistory::Details.new(payment_id)
      @payments = @details.payments
      @payment_modifications = @details.payment_modifications
      @back_button_url = determinate_back_link
    end

    private

    # Checks permissions and assigns paginated payment history
    def check_history_permissions
      if allow_view_payment_history?
        assign_paginated_history
      elsif allow_make_payments?
        assign_paginated_history(user_payments: true)
      else
        Rails.logger.warn('Access Denied. Redirects to :not_found page')
        redirect_to not_found_path
      end
    end

    # Assign paginated history to variable
    def assign_paginated_history(user_payments: false)
      @pagination = PaymentHistory::History.new(
        current_user.account_id, current_user.user_id, user_payments
      ).pagination(page: page_number, per_page: per_page)
    end

    # page number from params
    def page_number
      (params[:page] || 1).to_i
    end

    # per page size from params
    def per_page
      (params[:per_page] || 10).to_i
    end

    # payment_id from params
    def payment_id
      params['payment_id']
    end

    # Returns back link url, e.g '.../company_payment_history?page=3?back=true'
    def determinate_back_link_url
      PaymentHistory::BackLinkHistory.call(
        session: session,
        back_button: request.query_parameters['page']&.include?('back'),
        page: page_number,
        default_url: dashboard_url,
        url: payment_history_url
      )
    end

    # Returns back link url on the payment history details page
    # Assign +company_payment_history+ and +payment_details_back_link+ to the session
    def determinate_back_link
      session[:company_payment_history] = true if request.referer&.include?(payment_history_path)
      session[:payment_details_back_link] = request.referer || payment_history_path
    end
  end
end
