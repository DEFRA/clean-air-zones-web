# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # The form used to validate search vrn in VehiclesController.submit_search
  #
  class SearchVrnForm < BaseForm
    # Submitted vehicle registration number
    attr_reader :vrn

    validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }

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
  end
end
