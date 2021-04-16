# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::DetailsPayment, type: :model do
  subject do
    described_class.new(vrn: SecureRandom.uuid,
                        items: read_response('payment_history/payment_details.json')['lineItems'])
  end

  describe '.dates' do
    it 'returns an Array' do
      expect(subject.dates).to be_a(Array)
    end

    it 'returns a proper value' do
      expect(subject.dates.first).to eq('Sunday 26 July 2020')
    end
  end

  describe '.total_paid' do
    it 'returns a proper value' do
      expect(subject.total_paid).to eq(237.5)
    end
  end
end
