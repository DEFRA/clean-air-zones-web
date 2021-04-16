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
      session[:payment_query] = {} if params[:commit] == 'CLEARSEARCH'
      add_search_vrn if params[:commit] == 'SEARCH'
    end

    private

    # Saves search value to session
    def add_search_vrn
      session[:payment_query] = {}
      session[:payment_query][:search] = params.dig(:payment, :vrn_search)
    end
  end
end
