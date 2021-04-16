# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::PaymentModification do
  subject { described_class.new(data) }

  let(:vrn) { 'TST001' }
  let(:amount) { 3000 }
  let(:travel_date) { '2020-12-11' }
  let(:modification_timestamp) { '2020-12-11T01:00:17' }
  let(:payment_status) { 'REFUNDED' }
  let(:reference) { 'CR100000680' }
  let(:data) do
    {
      'vrn' => vrn,
      'amount' => amount,
      'travelDate' => travel_date,
      'modificationTimestamp' => modification_timestamp,
      'entrantPaymentStatus' => payment_status,
      'caseReference' => reference
    }
  end

  describe '.vrn' do
    it 'returns a proper value' do
      expect(subject.vrn).to eq(vrn)
    end
  end

  describe '.travel_date' do
    it 'returns a proper value' do
      expect(subject.travel_date).to eq('Friday 11 December 2020')
    end
  end

  describe '.amount' do
    it 'returns a proper value' do
      expect(subject.amount).to eq(30)
    end
  end

  describe '.reference' do
    it 'returns a proper value' do
      expect(subject.reference).to eq(reference)
    end
  end
end
