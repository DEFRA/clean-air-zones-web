# frozen_string_literal: true

##
# Module used for creating an organisation
module Organisations
  ##
  # This class is used to validate user data filled in
  class FleetCheckForm < BaseForm
    # Attribute used internally
    attr_accessor :confirm_fleet_check

    validates :confirm_fleet_check,
              presence: { message: I18n.t('fleet_check_form.errors.confirm_fleet_check') }
  end
end
