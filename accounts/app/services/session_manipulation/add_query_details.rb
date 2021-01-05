# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  ##
  # It saves query details for other actions than +Submit+
  #
  class AddQueryDetails < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:payment_query] = {}
      save_search_value if commit == 'SEARCH'
      save_direction_and_vrn('next') if commit == 'NEXT'
      save_direction_and_vrn('previous') if commit == 'PREVIOUS'
    end

    private

    # Extracts commit
    def commit
      params[:commit].upcase
    end

    # Saves direction and vrn
    def save_direction_and_vrn(direction)
      session[:payment_query][:direction] = direction
      session[:payment_query][:vrn] = params.dig(:payment, "#{direction}_vrn")
    end

    # Saves search value
    def save_search_value
      session[:payment_query][:search] = params.dig(:payment, :vrn_search)
    end
  end
end
