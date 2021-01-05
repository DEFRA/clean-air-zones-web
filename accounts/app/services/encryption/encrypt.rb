# frozen_string_literal: true

##
# Module used for encrypting token sent to users.
module Encryption
  # Service used to decrypt token
  #
  # ==== Usage
  #    token = { user_id: 5 }
  #    Encryption::Encrypt.call(value: token)
  #
  class Encrypt < Base
    # Instance level .call method used by class level .call
    def call
      encryptor.encrypt_and_sign(value)
    end
  end
end
