# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # This class is used to validate user data filled in +app/views/users/manage.html.haml+.
  class PaymentReviewForm
    include ActiveModel::Validations

    # form confirmation from the query params, values: 'yes', 'no', nil
    attr_reader :confirmation

    validates :confirmation, inclusion: {
      in: %w[yes], message: I18n.t('payment_review.errors.confirmation_alert')
    }

    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +confirmation+ - string, eg. 'yes'
    #
    def initialize(confirmation)
      @confirmation = confirmation
    end

    # Checks if +confirmation+ equality to 'yes'.
    #
    # Returns a boolean.
    def confirmed?
      confirmation == 'yes'
    end
  end
end
