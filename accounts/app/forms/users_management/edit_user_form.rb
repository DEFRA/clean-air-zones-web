# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # This class is used to validate user data filled in +app/views/users_management/manage_users/edit.html.haml+.
  class EditUserForm < BaseForm
    # validates permissions attribute to presence
    validates :permissions, presence: { message: I18n.t('add_new_user_form.errors.permissions_missing') }

    ##
    # Initializes the form
    #
    # ==== Attributes
    # * +account_id+ - uuid, the id of the administrator user account
    # + +account_user_id+ - uuid, id of the user account
    # - permissions- -  array, permission names of the user
    #
    def initialize(account_id:, account_user_id:, permissions:)
      @account_id = account_id
      @account_user_id = account_user_id
      @permissions = permissions
    end

    # Call api to update user permissions
    def submit
      AccountsApi::Users.update_user(
        account_id: account_id,
        account_user_id: account_user_id,
        permissions: permissions
      )
    end

    # First error message, e.g 'Select at least one permission type to continue'
    def error_message
      errors.messages[:permissions].first
    end

    private

    # Attributes reader
    attr_reader :account_id, :account_user_id, :permissions
  end
end
