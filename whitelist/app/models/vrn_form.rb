# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicles/add.html.haml+ and
# +app/views/vehicles/remove.html.haml+.
#
class VrnForm
  include ActiveModel::Validations

  # VRN getter
  attr_reader :vrn

  # Check if VRN is present
  validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }
  # Checks if VRN has valid length
  validates :vrn, length: {
    minimum: 2, too_short: I18n.t('vrn_form.errors.vrn_too_short'),
    maximum: 14, too_long: I18n.t('vrn_form.errors.vrn_too_long')
  }
  # Checks if VRN contains only alphanumerics
  validate :check_vrn_format
  ##
  # Initializer method
  # Returns uppercased VRN without any space
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  #
  def initialize(vrn)
    @vrn = vrn&.delete(' ')&.upcase
  end

  # Used in form view and should return nil when the object is not persisted.
  def to_key
    nil
  end

  private

  # Checks if VRN contains only alphanumerics
  def check_vrn_format
    return if /^[A-Za-z0-9]+$/.match(vrn).present?

    errors.add(:vrn, I18n.t('vrn_form.errors.vrn_invalid_format'))
  end
end
