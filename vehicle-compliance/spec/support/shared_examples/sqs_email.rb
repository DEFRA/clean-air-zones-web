# frozen_string_literal: true

RSpec.shared_examples 'a SQS email' do |expected_email|
  let(:mocked_msg) { OpenStruct.new(message_id: message_id) }

  before do
    allow(AWS_SQS).to receive(:send_message).and_return(mocked_msg)
  end

  it 'returns the message id' do
    expect(service).to eq(message_id)
  end

  it 'calls :send_message with JAQU email' do
    expect(AWS_SQS).to receive(:send_message) do |attributes|
      email = JSON.parse(attributes[:message_body])['emailAddress']
      expect(email).to eq(expected_email)
      mocked_msg
    end
    service
  end

  it 'calls :send_message with proper subject' do
    travel_to Time.zone.local(2019, 11, 13, 1, 4, 35)
    expect(AWS_SQS).to receive(:send_message) do |attributes|
      body = JSON.parse(attributes[:message_body])['personalisation']
      subject = JSON.parse(body)['subject']
      expect(subject).to eq('Compliance - SMITH010435')
      mocked_msg
    end
    service
  end
end
