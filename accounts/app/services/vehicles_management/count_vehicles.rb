# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Service used to count number of vehicles and compare with threshold settings
  #
  class CountVehicles < BaseService
    ##
    # Initializer method
    #
    # ==== Params
    #
    # * +file+ - uploaded file
    #
    def initialize(file:)
      @file = file
    end

    # Count number of vehicles and compare with threshold settings
    #
    # Returns a boolean
    def call
      log_action('Counting number of vehicles in uploaded file')
      vehicles_count
    end

    # Streaming file and count lines without load the whole file into memory
    # This operation not takes header into consideration
    def vehicles_count
      `wc -l "#{file.path}"`.strip.split[0].to_i - 1
    end

    private

    # Attributes used internally
    attr_reader :file
  end
end
