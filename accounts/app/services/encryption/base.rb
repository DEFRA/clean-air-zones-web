# frozen_string_literal: true

##
# Module used for encrypting token sent to users.
# https://pawelurbanek.com/rails-secure-encrypt-decrypt
#
module Encryption
  # Base service for the module
  class Base < BaseService
    # Key used to performed encryption
    KEY = ActiveSupport::KeyGenerator.new(
      ENV.fetch('SECRET_KEY_BASE')
    ).generate_key(
      ENV.fetch('ENCRYPTION_SERVICE_SALT', 'aaaaaaaa'),
      ActiveSupport::MessageEncryptor.key_len
    ).freeze

    private_constant :KEY

    # Initializer method
    #
    # ==== Attributes
    # * +value+ - any object - a value you want to encrypt/decrypt
    #
    def initialize(value:)
      @value = value
    end

    private

    # Reader for the value
    attr_reader :value

    # Returns the instance of Encryption Engine
    def encryptor
      ActiveSupport::MessageEncryptor.new(KEY)
    end
  end
end
