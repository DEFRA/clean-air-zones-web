# frozen_string_literal: true

##
# Module used for manage users flow
#
module UsersManagement
  ##
  # Service responsible for extracting emails for specific account users.
  #
  class EmailFetcher
    ##
    # Initializer method
    #
    # ==== Params
    #
    # * +account_id+ - uuid, id of the account
    def initialize(account_id:)
      @account_id = account_id
    end

    # Selects user from the account users list based on the account_user_id parameter.
    def for_account_user(account_user_id)
      find_email_for_user_where { |user| user['accountUserId'] == account_user_id }
    end

    # Selects owner user from the account users list.
    def for_owner
      find_email_for_user_where { |user| user['owner'] == true }
    end

    private

    attr_reader :account_id

    # Performs an API call in order to fetch all account users associated with the provided account.
    def account_users
      @account_users ||= AccountsApi::Users.users(account_id: account_id)['users']
    end

    # Helper method used to fetch specific user based on the provided block condition.
    def find_email_for_user_where(&block)
      extract_email(account_users.find(&block))
    end

    # Helper method used to fetch nullable email attribute.
    def extract_email(user)
      user.try(:[], 'email')
    end
  end
end
