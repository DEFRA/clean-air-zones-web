# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Form used by FleetsController.submit_method to validate submitted method
  #
  class SubmissionMethodForm < BaseForm
    # Attributes accessor
    attr_accessor :choose_method

    # Validates if the method is either +upload+ or +manual+
    validates :choose_method, inclusion: {
      message: I18n.t('submission_method_form.errors.submission_method_missing'),
      allow_blank: false,
      in: %w[upload manual]
    }

    # Return true if submitted method is +manual+
    def manual?
      choose_method == 'manual'
    end
  end
end
