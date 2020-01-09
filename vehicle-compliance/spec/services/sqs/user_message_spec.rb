# frozen_string_literal: true

require 'rails_helper'

describe Sqs::UserMessage do
  subject(:service) { described_class.call(contact_form: form) }

  let(:message_id) { SecureRandom.uuid }
  let(:form) { ContactForm.new(params) }
  let(:params) do
    {
      first_name: first_name,
      last_name: last_name,
      email: 'test@example.com',
      email_confirmation: 'test@example.com',
      type_of_enquiry: type,
      message: 'Test message'
    }
  end
  let(:first_name) { 'James' }
  let(:last_name) { 'Smith' }
  let(:type) { 'Compliance' }

  context 'when the call to SQS is successful' do
    it_behaves_like 'a SQS email', 'test@example.com'
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

  describe '.message_details' do
    subject(:details) do
      described_class.new(contact_form: form).send(:message_details)
    end

    it 'returns forename' do
      expect(JSON.parse(details)['forename']).to eq(first_name)
    end

    it 'returns reference' do
      freeze_time do
        reference = "#{last_name.upcase}#{Time.current.strftime('%H%M%S')}"
        expect(JSON.parse(details)['reference']).to eq(reference)
      end
    end

    it 'returns subject' do
      freeze_time do
        reference = "#{last_name.upcase}#{Time.current.strftime('%H%M%S')}"
        expect(JSON.parse(details)['subject']).to eq("#{type} - #{reference}")
      end
    end
  end
end
