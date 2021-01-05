# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Controller used to show detailed information about the all company and users payments
  #
  class PaymentHistoryController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(allow_view_payment_history?) }, only: :company_payment_history
    before_action -> { check_permissions(allow_make_payments?) }, only: :user_payment_history
    before_action -> { check_permissions(allow_view_details_history?) }, only: :payment_history_details

    ##
    # Renders the company payment history page
    #
    # ==== Path
    #
    #    :GET /company_payment_history
    #
    def company_payment_history
      assign_paginated_history
      @back_button_url = determinate_back_link_url(
        :company_back_link_history,
        dashboard_url,
        company_payment_history_url
      )
    rescue BaseApi::Error400Exception
      return redirect_to company_payment_history_path unless page_number == 1
    end

    ##
    # Renders the user payment history page
    #
    # ==== Path
    #
    #    :GET /user_payment_history
    #
    def user_payment_history
      session[:company_payment_history] = nil
      assign_paginated_history(user_payments: true)
      @back_button_url = determinate_back_link_url(
        :user_back_link_history,
        dashboard_url,
        user_payment_history_url
      )
    rescue BaseApi::Error400Exception
      return redirect_to user_payment_history_path unless page_number == 1
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
      @back_button_url = determinate_back_link
    end

    private

    # Assign paginated history to variable
    def assign_paginated_history(user_payments: false)
      @pagination = PaymentHistory::History.new(
        current_user.account_id,
        current_user.user_id,
        user_payments
      ).pagination(page: page_number)
    end

    # page number from params
    def page_number
      (params[:page] || 1).to_i
    end

    # payment_id from params
    def payment_id
      params['payment_id']
    end

    # Returns back link url, e.g '.../company_payment_history?page=3?back=true'
    def determinate_back_link_url(session_key, default_url, url)
      PaymentHistory::BackLinkHistory.call(
        session: session,
        session_key: session_key,
        back_button: request.query_parameters['page']&.include?('back'),
        page: page_number,
        default_url: default_url,
        url: url
      )
    end

    # Returns back link url on the payment history details page
    # Assign +payment_details_back_link+ and +company_payment_history+ to the session
    def determinate_back_link # rubocop:disable Metrics/AbcSize
      if request.referer&.include?(company_payment_history_path)
        session[:company_payment_history] = true
        session[:payment_details_back_link] = request.referer
      elsif request.referer&.include?(user_payment_history_path)
        session[:payment_details_back_link] = request.referer
      else
        session[:payment_details_back_link] ||= user_payment_history_path
      end
    end
  end
end
