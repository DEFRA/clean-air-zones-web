# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::CompanyPayment, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      paymentId: payment_id,
      payment_date: date,
      payerName: payer_name,
      cazName: caz_name,
      entriesCount: entries_count,
      totalPaid: total_paid
    }.stringify_keys
  end

  let(:payment_id) { @uuid }
  let(:date) { '2020-08-1' }
  let(:payer_name) { 'Administrator' }
  let(:caz_name) { 'Leeds' }
  let(:entries_count) { 1 }
  let(:total_paid) { 61 }

  describe '.payment_id' do
    it 'returns a proper value' do
      expect(subject.payment_id).to eq(payment_id)
    end
  end

  describe '.date' do
    it 'returns a proper value' do
      expect(subject.date).to eq('01/08/2020')
    end
  end

  describe '.payer_name' do
    it 'returns a proper value' do
      expect(subject.payer_name).to eq(payer_name)
    end
  end

  describe '.entries_count' do
    it 'returns a proper value' do
      expect(subject.entries_count).to eq(entries_count)
    end
  end

  describe '.total_paid' do
    it 'returns a proper value' do
      expect(subject.total_paid).to eq(total_paid)
    end
  end
end
