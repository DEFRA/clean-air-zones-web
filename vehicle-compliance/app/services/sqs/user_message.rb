# frozen_string_literal: true

module Sqs
  ##
  # Service used to send the contact form confirmation copy to the user.
  #
  # ==== Usage
  #    form = ContactForm.new(params['contact_form'])
  #    if form.valid?
  #       message_id = Sqs::UserMessage.call(contact_form: form)
  #    end
  #
  class UserMessage < BaseMessage
    def initialize(contact_form:)
      @forename = contact_form.first_name
      super(contact_form: contact_form)
    end

    private

    attr_reader :forename

    # Returns assigned Notify Copy Template ID
    def template_id
      ENV.fetch('NOTIFY_COPY_TEMPLATE_ID', 'e9c1f384-ad75-471b-96aa-717f406a5806')
    end

    # returns user's email
    def receiver_email
      email
    end

    # Serializes email personalisation details containing the email's subject
    # Returns a JSON string
    def message_details
      {
        subject: subject,
        forename: forename,
        reference: reference
      }.to_json
    end
  end
end
