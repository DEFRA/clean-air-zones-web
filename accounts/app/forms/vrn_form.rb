# frozen_string_literal: true

##
# The form used to validate vrn in VehiclesController.submit_details
#
class VrnForm < BaseForm
  # Submitted vehicle registration number
  attr_reader :vrn

  validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }
  validates :vrn, length: {
    minimum: 2,
    maximum: 7,
    too_short: I18n.t('vrn_form.errors.vrn_too_short'),
    too_long: I18n.t('vrn_form.errors.vrn_too_long')
  }
  validate :validate_format

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn&.upcase&.delete(' ')
  end

  # returns first error message from the errors collection
  def error_message
    errors.messages.values.flatten.first
  end

  private

  # Validates format against possible ones
  def validate_format
    return if FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn).present?
    end

    errors.add(:vrn, I18n.t('vrn_form.errors.vrn_invalid'))
  end

  # Possible vrn formats
  FORMAT_REGEXPS = [
    /^[A-Z]{3}[0-9]{3}$/, # AAA999
    /^[A-Z][0-9]{3}[A-Z]{3}$/, # A999AAA
    /^[A-Z]{3}[0-9]{3}[A-Z]$/, # AAA999A
    /^[A-Z]{3}[0-9]{4}$/, # AAA9999
    /^[A-Z]{2}[0-9]{2}[A-Z]{3}$/, # AA99AAA
    /^[0-9]{4}[A-Z]{3}$/, # 9999AAA
    /^[A-Z][0-9]$/, # A9
    /^[0-9][A-Z]$/, # 9A
    /^[A-Z]{2}[0-9]$/, # AA9
    /^[A-Z][0-9]{2}$/, # A99
    /^[0-9][A-Z]{2}$/, # 9AA
    /^[0-9]{2}[A-Z]$/, # 99A
    /^[A-Z]{3}[0-9]$/, # AAA9
    /^[A-Z][0-9]{3}$/, # A999
    /^[A-Z]{2}[0-9]{2}$/, # AA99
    /^[0-9][A-Z]{3}$/, # 9AAA
    /^[0-9]{2}[A-Z]{2}$/, # 99AA
    /^[0-9]{3}[A-Z]$/, # 999A
    /^[A-Z][0-9][A-Z]{3}$/, # A9AAA
    /^[A-Z]{3}[0-9][A-Z]$/, # AAA9A
    /^[A-Z]{3}[0-9]{2}$/, # AAA99
    /^[A-Z]{2}[0-9]{3}$/, # AA999
    /^[0-9]{2}[A-Z]{3}$/, # 99AAA
    /^[0-9]{3}[A-Z]{2}$/, # 999AA
    /^[0-9]{4}[A-Z]$/, # 9999A
    /^[A-Z][0-9]{4}$/, # A9999
    /^[A-Z][0-9]{2}[A-Z]{3}$/, # A99AAA
    /^[A-Z]{3}[0-9]{2}[A-Z]$/, # AAA99A
    /^[0-9]{3}[A-Z]{3}$/, # 999AAA
    /^[A-Z]{2}[0-9]{4}$/, # AA9999
    /^[0-9]{4}[A-Z]{2}$/ # 9999AA
  ].freeze
end
