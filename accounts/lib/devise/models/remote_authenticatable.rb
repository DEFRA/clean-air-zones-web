# frozen_string_literal: true

# Devise gem module
module Devise
  # A strategy is a place where you can put logic related to authentication. Any strategy inherits
  # from Warden::Strategies::Base.
  module Models
    # Module allow remote authentication with devise, used in User.rb
    module RemoteAuthenticatable
      extend ActiveSupport::Concern

      # If the authentication is successful it should return a resource instance
      # If the authentication fails it should return false
      def authentication(params)
        user_data = AccountsApi::Auth.sign_in(email: params[:email], password: params[:password])
        user = User.serialize_from_api(user_data)
        user.login_ip = params[:login_ip]
        user
      end

      # Devise module
      module ClassMethods
        # Overridden methods from Devise::Models::Authenticatable
        # This method is called from Warden::SessionSerializer in devise
        # It takes as many params as elements had the array returned in serialize_into_session
        # Recreates a resource from session data
        def serialize_from_session(data, _salt)
          new(**data.symbolize_keys)
        end

        #
        # Here you have to return and array with the data of your resource that you want to serialize into the session
        def serialize_into_session(record)
          [record.serializable_hash.stringify_keys, nil]
        end
      end
    end
  end
end
