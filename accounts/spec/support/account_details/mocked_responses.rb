# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  module MockedResponses
    def mock_account_details
      api_response = read_response('account_details/user.json')
      allow(AccountsApi::Users).to receive(:account_details).and_return(api_response)
    end
  end
end
