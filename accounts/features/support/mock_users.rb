# frozen_string_literal: true

# helper methods for manage users flow
module MockUsers
  def mock_users
    allow(AccountsApi::Users).to receive(:users).and_return(users_api_response)
  end

  def mock_empty_users_list
    allow(AccountsApi::Users).to receive(:users).and_return(empty_users_api_response)
  end

  def mock_more_then_ten_users
    api_response = users_api_response
    api_response['users'] << users_api_response['users'].last
    allow(AccountsApi::Users).to receive(:users).and_return(api_response)
  end

  def mock_user_on_list # rubocop:disable Metrics/MethodLength
    user = new_user
    api_response = {
      multiPayerAccount: true,
      users: [
        {
          accountUserId: user.user_id,
          name: 'Mary Smith',
          email: 'test@example.com',
          owner: true,
          removed: false
        }.stringify_keys
      ]
    }.stringify_keys
    allow(AccountsApi::Users).to receive(:users).and_return(api_response)
    allow_any_instance_of(User).to receive(:authentication).and_return(user)
    fill_sign_in_form
  end

  def mock_user_details
    allow(AccountsApi::Users).to receive(:user).and_return(read_response('users_management/user.json'))
  end

  def mock_second_user_details
    api_response = {
      name: 'Mary Smith',
      email: 'second_user@email.com',
      owner: true,
      permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS]
    }.stringify_keys
    allow(AccountsApi::Users).to receive(:user).with(account_id: account_id, account_user_id: second_user_id)
                                               .and_return(api_response)
  end

  def mock_account_details
    allow(AccountsApi::Users).to receive(:account_details)
      .and_return(read_response('account_details/user.json'))
  end

  def mock_update_user
    allow(AccountsApi::Users).to receive(:update_user).and_return({})
  end

  def mock_delete_user
    allow(AccountsApi::Users).to receive(:delete_user).and_return({})
  end

  def mock_successful_user_validation
    allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
  end

  def mock_failed_user_validation
    allow(AccountsApi::Accounts).to receive(:user_validations)
      .and_raise(BaseApi::Error400Exception.new(400, '', ''))
  end

  def mock_owners_change_email
    allow(AccountsApi::Auth).to receive(:update_owner_email).and_return(true)
  end

  def mock_actual_account_name
    allow_any_instance_of(User).to receive(:actual_account_name).and_return("Royal Mail's")
  end

  def mock_account_cancellation
    allow(AccountsApi::Accounts).to receive(:close_account).and_return({})
  end

  def uuid
    '6ffc41fd-ff2d-4cc1-a2a2-90006ae26446'
  end

  private

  def users_api_response
    read_response('users_management/users.json')
  end

  def empty_users_api_response
    read_response('users_management/empty_users.json')
  end
end

World(MockUsers)
