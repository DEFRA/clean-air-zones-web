# frozen_string_literal: true

##
# The form used to validate search vrn in VehiclesManagement::FleetsController.submit_search and in
# Payments::PaymentsController.submit_search
#
class SearchVrnForm < BaseForm
  # Submitted vehicle registration number
  attr_reader :vrn

  validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }

  # Checks if VRN contains only alphanumerics
  validates :vrn, format: {
    with: /\A[A-Za-z0-9]+\z/,
    message: I18n.t('vrn_form.errors.vrn_invalid')
  }, allow_blank: true

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn&.upcase&.delete(' ')
  end
end
