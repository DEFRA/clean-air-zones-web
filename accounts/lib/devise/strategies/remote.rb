# frozen_string_literal: true

# Devise gem module
module Devise
  # A strategy is a place where you can put logic related to authentication. Any strategy inherits
  # from Warden::Strategies::Base.
  module Strategies
    ##
    # Class responsible for validating user email and authenticating user.
    #
    class Remote < Devise::Strategies::Authenticatable
      # For an example check:
      # https://github.com/plataformatec/devise/blob/master/lib/devise/strategies/database_authenticatable.rb
      # Method called by warden to authenticate a resource.
      def authenticate!
        params_auth_hash[:email]&.strip!

        return fail! unless validate_login_form

        # mapping.to is a wrapper over the resource model
        resource = mapping.to.new
        return fail! unless resource

        params_auth_hash[:login_ip] = request.remote_ip
        authenticate_user(resource, params_auth_hash)
      end

      # Other validations are made by LoginForm
      def valid?
        params_authenticatable? && valid_params_request? && valid_params?
      end

      private

      # Checks if email and password was submitted and email is in valid format
      def validate_login_form
        form = LoginForm.new(params_auth_hash[:email], params_auth_hash[:password])
        return true if form.valid?

        # Moves form errors to warden errors
        form.errors.each { |error| errors.add(error.attribute, error.message) }
        false
      end

      # Validate params and authenticate an user
      def authenticate_user(resource, auth_params)
        # Validate is a method defined in Devise::Strategies::Authenticatable. It takes
        # a block which must return a boolean value.
        #
        # If the block returns true the resource will be logged in
        # If the block returns false the authentication will fail!
        #
        if validate(resource) { resource = resource.authentication(auth_params) }
          success!(resource)
        else
          add_unauthorized_errors
        end
      rescue BaseApi::Error401Exception, BaseApi::Error400Exception => e
        add_unauthorized_errors(error_code: e.body['errorCode'])
      rescue BaseApi::Error422Exception
        add_unconfirmed_errors
      end

      # Sets errors with base error to display in the error summary
      def add_unauthorized_errors(error_code: nil)
        if error_code == 'pendingEmailChange'
          errors.add(:base, I18n.t('login_form.email_pending_change'))
        else
          errors.add(:base, I18n.t('login_form.incorrect'))
        end
        fail!(:invalid)
      end

      # Sets errors with email error to display in the error summary
      def add_unconfirmed_errors
        errors.add(:email, I18n.t('login_form.email_unconfirmed'))
        fail!(:invalid)
      end
    end
  end
end
