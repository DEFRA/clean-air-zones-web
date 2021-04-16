# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::History, type: :model do
  subject { described_class.new(SecureRandom.uuid, SecureRandom.uuid, true) }

  describe '.pagination' do
    before do
      api_response = read_response('payment_history/payments.json')['1']
      allow(PaymentHistoryApi).to receive(:payments).and_return(api_response)
    end

    it 'returns an PaymentHistory::PaginatedPayment instances' do
      expect(subject.pagination(page: 1, per_page: 10)).to be_an_instance_of(PaymentHistory::PaginatedPayment)
    end
  end
end
