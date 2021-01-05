# frozen_string_literal: true

##
# Module used for encrypting token sent to users.
module Encryption
  # Service used to decrypt token
  #
  # ==== Usage
  #    token = { user_id: 5 }
  #    encrypted_token = Encryption::Encrypt.call(value: token)
  #    Encryption::Decrypt.call(value: encrypted_token)
  #    # { user_id: 5 }
  #
  # ==== Exceptions
  #
  # Raises ActiveSupport::MessageEncryptor::InvalidMessage when +value+ is nil or decryption fails.
  class Decrypt < Base
    # Instance level .call method used by class level .call
    def call
      raise ActiveSupport::MessageEncryptor::InvalidMessage if value.nil?

      encryptor.decrypt_and_verify(value)
    end
  end
end
