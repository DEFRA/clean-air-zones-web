# frozen_string_literal: true

##
# This class is used to validate new vehicle data added in form.
class NewVrnForm < VrnForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Attribute used in new vrn view
  attr_accessor :vrn, :category, :manufacturer, :reason

  # validates attributes to presence
  validates :category, :reason, presence: { message: I18n.t('input_form.errors.missing') }

  # Checks if +manufacturer+ and +reason+ has valid length
  validates :manufacturer, :reason, length: {
    maximum: 50, too_long: I18n.t('input_form.errors.too_long')
  }

  # validates +manufacturer+ format
  validates :manufacturer, format: {
    with: %r{\A[a-zA-Z0-9,'"\\\-()./\[\]{} ]+\z},
    message: I18n.t('input_form.errors.invalid_format')
  }, allow_blank: true

  # validates +reason+ format
  validates :reason, format: {
    with: /\A[a-zA-Z0-9 ]+\z/,
    message: I18n.t('input_form.errors.invalid_format')
  }, allow_blank: true

  # Overrides default initializer for compliance with form_for method in content_form view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end
end
