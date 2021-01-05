# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Represents the virtual model of the user, used in:
  # +../primary_users/primary_account_details.html.haml+.
  # +../non_primary_users/non_primary_account_details.html.haml+.
  #
  class User
    ##
    # Creates an instance of a form class, make keys underscore and transform to symbols.
    #
    # ==== Attributes
    #
    # * +data+ - hash
    #   * +name+ - string, eg. 'John Doe'
    #   * +email+ - downcase email of the user
    #   * +accountName+ - string, name of the account, eg. 'My company name'
    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # user name
    def name
      data[:name]
    end

    # downcase user email
    def email
      data[:email].downcase
    end

    # company name
    def account_name
      data[:account_name]
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
