# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  # Class to manipulate session and determinate correct page number on the results page
  class BackLinkHistory < BaseService
    include Rails.application.routes.url_helpers

    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +session+ - session object
    # * +session_key+ - session key
    # * +back_button+ - boolean, e.g true if back button was used
    # * +page+ - string, page number, eg. '4'
    # * +default_url+ - string, eg. 'http://www.example.com/dashboard'
    # * +url+ - string, eg. 'http://www.example.com/company_payment_history?page=4?back=true'
    def initialize(session:, session_key:, back_button:, page:, default_url:, url:) # rubocop:disable Metrics/ParameterLists
      @session = session
      @session_key = session_key
      @back_button = back_button
      @page = page
      @default_url = default_url
      @url = url
    end

    # The caller method for the service. It invokes checking back link history and updating it
    #
    # Returns a back link url
    def call
      update_steps_history
      clear_more_then_10_steps
      determinate_back_link_url
    end

    private

    # Creating first step or adding page number to correct step or dont do anything in case if page was refreshed
    def update_steps_history # rubocop:disable Metrics/AbcSize
      if history.nil?
        log_action('Creating first step into the back link history')
        session[session_key] = { '1' => page }
      elsif last_step_page != page
        return clear_unused_steps if back_button && history

        log_action('Adding step to the back link history')
        session[session_key][next_step] = page
      end
    end

    # Removes futures steps when back button was used
    def clear_unused_steps
      log_action('Clearing future steps from the back link history')
      current_step_keys = history.select { |k, _v| k <= previous_step }.keys
      session[session_key] = history.slice(*current_step_keys)
    end

    # Clear first step from history in case if we already have more the 10 steps in the session
    def clear_more_then_10_steps
      session[session_key].shift if history && history.size > 10
    end

    # Returns back link url, e.g '.../vehicles/historic_search?page=3?back=true'
    def determinate_back_link_url
      if history.nil? || history.size == 1
        default_url
      else
        "#{url}?page=#{session.dig(session_key, previous_step)}?back=true"
      end
    end

    # Returns previous number of step, e.g '4'
    def previous_step
      (history.keys.last.to_i - 1).to_s
    end

    # Returns the last step page number, e.g 4
    def last_step_page
      history.values.last
    end

    # Returns previous next of step, e.g '5'
    def next_step
      (history.keys.last.to_i + 1).to_s
    end

    # Back link histories from the session
    def history
      session[session_key]
    end

    # Attributes reader
    attr_reader :session, :session_key, :back_button, :page, :default_url, :url
  end
end
