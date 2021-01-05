# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # This class is used to validate users name filled in +app/views/account_details/non_primary_users/edit_name.html.haml+
  class EditUserNameForm < BaseForm
    # Attributes accessor
    attr_accessor :name

    validates :name, presence: { message: I18n.t('edit_user_name_form.errors.name_missing') }
  end
end
