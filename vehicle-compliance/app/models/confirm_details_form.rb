# frozen_string_literal: true

##
# This class is used to validate user data entered in confirm_details form.
class ConfirmDetailsForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Attributes used in confirm details view
  attr_accessor :confirm_details, :undetermined

  # validates attributes to presence
  validates :confirm_details, presence: { message: I18n.t('confirm_details_form.confirm_details_missing') }

  # Returns status for the vehicle type
  #
  # Returns a boolean.
  def undetermined?
    undetermined == 'true'
  end

  # Checks if user confirmation of vehicle details is equals 'yes'
  #
  # Returns a boolean.
  def confirmed?
    confirm_details == 'yes'
  end

  # Overrides default initializer for compliance with form_for method in confirm_details view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in confirm details view and should return nil when the object is not persisted.
  def to_key
    nil
  end
end
