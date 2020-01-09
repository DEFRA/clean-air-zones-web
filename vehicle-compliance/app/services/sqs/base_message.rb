# frozen_string_literal: true

##
# Module used to enqueueing messages on AWS SQS to be later caught by Notification Gateway microservice.
#
module Sqs
  ##
  # Base class for the SQS services
  #
  class BaseMessage < BaseService
    ##
    # Initializer method. Used by class level +:call+ method
    #
    # ==== Attributes
    #
    # * +contact_form+ - a valid instance of {Contact Form model}[rdoc-ref:ContactForm]
    #
    def initialize(contact_form:)
      @reference = email_reference(contact_form)
      @subject = email_subject(contact_form)
      @email = contact_form.email
      @full_name = "#{contact_form.first_name} #{contact_form.last_name}"
      @body = contact_form.message
    end

    ##
    # Performs a call to SQS.
    #
    # Returns assigned message ID (UUID) if the call was successful.
    #
    # If the call fails, returns false.
    #
    # ==== Exceptions
    #
    # All Aws::SQS::Errors are escaped and service will return false.
    #
    def call
      log_action("Sending SQS message with attributes: #{attributes}")
      id = send_message.message_id
      log_action("SQS message with id: #{id} nad reference: #{reference} was sent")
      id
    rescue Aws::SQS::Errors::ServiceError => e
      log_error(e)
      false
    end

    private

    # Private variables set by the initializer
    attr_reader :subject, :email, :reference, :full_name, :body

    # Assigns attributes and performs the SQS call.
    # Returns SQS message struct or raises a SQS exception.
    def send_message
      AWS_SQS.send_message(
        queue_url: ENV.fetch('NOTIFY_QUEUE_URL', ''),
        message_group_id: ENV.fetch('NOTIFY_GROUP_ID', 'VCCS_CONTACT_FORM'),
        message_body: attributes,
        message_attributes: {
          'contentType' => { string_value: 'application/json', data_type: 'String' }
        }
      )
    end

    # Serializes message body attributes.
    # Returns a JSON string.
    def attributes
      {
        'templateId' => template_id,
        'emailAddress' => receiver_email,
        'personalisation' => message_details,
        'reference' => reference
      }.to_json
    end

    # Creates an email reference containing the user's last name and a timestamp
    # Return string, eg. "SMITH131500"
    def email_reference(form)
      "#{form.last_name.upcase.delete(' ')}#{Time.current.strftime('%H%M%S')}"
    end

    # Creates email subject by combining the reference and the selected type of enquiry
    # Returns string, eg. "Compliance - SMITH010435"
    def email_subject(form)
      "#{form.type_of_enquiry} - #{reference}"
    end
  end
end
