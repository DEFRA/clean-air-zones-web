# frozen_string_literal: true

##
# Module used for connecting to Accounts API
module AccountsApi
  ##
  # Base class for using `base_uri` to Accounts API
  class Base < BaseApi
    base_uri "#{ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001')}/v1"
  end
end
