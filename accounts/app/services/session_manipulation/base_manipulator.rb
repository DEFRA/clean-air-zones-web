# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  # Base class used to improve session management
  class BaseManipulator < BaseService
    include PaymentsHelper

    def initialize(session:, params: {})
      @session = session
      @params = params
    end

    private

    # Attributes reader
    attr_reader :session, :params
  end
end
