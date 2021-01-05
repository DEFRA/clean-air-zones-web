# frozen_string_literal: true

##
# Module used for Direct Debits flow
module DirectDebits
  ##
  # Class used to serialize data from DebitsApi.mandates
  #
  class Mandate
    # Initializer method. Assigns :data
    #
    # ==== Params
    #
    # * +cazId+ - uuid, CleanAirZone ID
    # * +cazName+ - string, name of the CAZ
    # * +mandates+ - hash
    #   * +id+ - uuid, mandate ID
    #   * +status+ - string, status of the mandate eg. 'active'
    #
    def initialize(data)
      @data = data
    end

    # Returns the ID of associated CAZ
    def zone_id
      data['cazId']
    end

    # Returns the name of associated CAZ
    def zone_name
      data['cazName']&.humanize
    end

    # Returns mandate's ID
    def id
      return nil if data['mandates'].empty?

      data.dig('mandates', 'id')
    end

    # Returns mandate status
    def status
      return if data['mandates'].empty? || data.dig('mandates', 'status').nil?

      status = data.dig('mandates', 'status')
      return 'Pending' if %w[pending_customer_approval pending_submission submitted].include?(status.downcase)

      status.humanize
    end

    private

    # Reader for data hash
    attr_reader :data
  end
end
