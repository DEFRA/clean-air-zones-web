# frozen_string_literal: true

module Sqs
  ##
  # Service used to send the contact form information to JAQU team
  #
  # ==== Usage
  #    form = ContactForm.new(params['contact_form'])
  #    if form.valid?
  #       message_id = Sqs::JaquMessage.call(contact_form: form)
  #    end
  #
  class JaquMessage < BaseMessage
    private

    # Returns assigned Notify Template ID
    def template_id
      ENV.fetch('NOTIFY_TEMPLATE_ID', '7337cc7a-6aee-4558-850f-fd5ca50bd1b3')
    end

    # Returns assigned JAQU team email address
    def receiver_email
      Rails.configuration.x.contact_email
    end

    # Serializes email personalisation details containing name, user's email, subject and submitted data
    # Returns a JSON string
    def message_details
      {
        name: full_name,
        email: email,
        body: body,
        subject: subject
      }.to_json
    end
  end
end
