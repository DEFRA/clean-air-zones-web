# frozen_string_literal: true

##
# Class used to validate data submitted on `What would you like to do?` page.
#
# ==== Usages
#    form = RelevantPortalForm.new(check_vehicle_option: 'single')
#    redirect_to path if form.valid?
#
class RelevantPortalForm < BaseForm
  validates :check_vehicle_option, inclusion: {
    in: %w[single multiple pay], message: I18n.t('relevant_portal_form.errors.missing_answer')
  }

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +check_vehicle_option+ - option selced by the user
  #
  def initialize(check_vehicle_option)
    @check_vehicle_option = check_vehicle_option
  end

  private

  # Attributes reader
  attr_reader :check_vehicle_option
end
