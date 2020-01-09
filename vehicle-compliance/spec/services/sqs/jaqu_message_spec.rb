# frozen_string_literal: true

require 'rails_helper'

describe Sqs::JaquMessage do
  subject(:service) { described_class.call(contact_form: form) }

  let(:message_id) { SecureRandom.uuid }
  let(:form) { ContactForm.new(params) }
  let(:mocked_msg) { OpenStruct.new(message_id: message_id) }

  let(:params) do
    {
      first_name: 'James',
      last_name: 'Smith',
      email: 'test@example.com',
      email_confirmation: 'test@example.com',
      type_of_enquiry: 'Compliance',
      message: 'Test message'
    }
  end

  context 'when the call to SQS is successful' do
    it_behaves_like 'a SQS email', Rails.configuration.x.contact_email
  end

  context 'when the call to SQS is unsuccessful' do
    before do
      allow(AWS_SQS).to receive(:send_message).and_raise(
        Aws::SQS::Errors::InvalidMessageContents.new('', '')
      )
    end

    it 'returns false' do
      expect(service).to be_falsey
    end
  end
end
