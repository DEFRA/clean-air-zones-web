# frozen_string_literal: true

require 'rails_helper'

describe DirectDebits::Details, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      referenceNumber: payment_reference,
      externalPaymentId: external_id
    }.stringify_keys
  end

  let(:payment_reference) { 'WYP3HNDP' }
  let(:external_id) { SecureRandom.uuid }

  describe '.payment_reference' do
    it 'returns payment reference' do
      expect(subject.payment_reference).to eq(payment_reference)
    end
  end

  describe '.external_id' do
    it 'returns external id' do
      expect(subject.external_id).to eq(external_id)
    end
  end
end
