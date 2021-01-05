# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  module MockedResponses
    def mock_users
      api_response = read_response('users_management/users.json')
      allow(AccountsApi::Users).to receive(:users).and_return(api_response)
    end

    def mock_empty_users_list
      api_response = read_response('users_management/empty_users.json')
      allow(AccountsApi::Users).to receive(:users).and_return(api_response)
    end

    def mock_user_details
      allow(AccountsApi::Users).to receive(:user).and_return(read_response('users_management/user.json'))
    end

    def mock_second_user_details(account_id, user_id)
      api_response = {
        name: 'Mary Smith',
        email: 'second_user@email.com',
        owner: true,
        permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS]
      }.stringify_keys
      allow(AccountsApi::Users).to receive(:user).with(account_id: account_id, account_user_id: user_id)
                                                 .and_return(api_response)
    end

    def mock_update_user
      allow(AccountsApi::Users).to receive(:update_user).and_return({})
    end

    def mock_delete_user
      allow(AccountsApi::Users).to receive(:delete_user).and_return({})
    end
  end
end
