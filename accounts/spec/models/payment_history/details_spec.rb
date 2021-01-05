# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::Details, type: :model do
  subject { described_class.new(@uuid) }

  before do
    api_response = read_response('payment_history/payment_details.json')
    allow(PaymentHistoryApi).to receive(:payment_details).and_return(api_response)
  end

  describe '.payments' do
    it 'returns an PaymentHistory::DetailsPayment instances' do
      expect(subject.payments).to all(be_a(PaymentHistory::DetailsPayment))
    end
  end

  describe '.payer_name' do
    it 'returns a proper value' do
      expect(subject.payer_name).to eq('John Doe')
    end
  end

  describe '.date' do
    it 'returns a proper value' do
      expect(subject.date).to eq('Wednesday 29 July 2020')
    end
  end

  describe '.reference' do
    it 'returns a proper value' do
      expect(subject.reference).to eq(2981)
    end
  end

  describe '.provider_payment_id' do
    it 'returns a proper value' do
      expect(subject.provider_payment_id).to eq('gr4q4tedct2vqqo39uvb2o1ei4')
    end
  end
end
