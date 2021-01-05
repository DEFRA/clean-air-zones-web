# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Represents the virtual model of the user, used in +app/views/users_management/users/edit.html.haml+.
  #
  class EditUser
    # Reader for an account_user_id
    attr_accessor :account_user_id

    def initialize(data, account_user_id)
      @data = data.transform_keys { |key| key.underscore.to_sym }
      @account_user_id = account_user_id
    end

    # user name
    def name
      data[:name]
    end

    # user email
    def email
      data[:email]
    end

    # user permissions
    def permissions
      data[:permissions]
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
