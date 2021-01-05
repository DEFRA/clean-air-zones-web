# frozen_string_literal: true

require 'rails_helper'

describe DirectDebits::Mandate, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'cazId' => zone_id,
      'cazName' => zone_name,
      'mandates' => mandates
    }
  end

  let(:mandates) do
    {
      'id' => mandate_id,
      'reference' => reference,
      'status' => status
    }
  end

  let(:zone_id) { @uuid }
  let(:zone_name) { 'Leeds' }
  let(:mandate_id) { @uuid }
  let(:reference) { '1626' }
  let(:status) { 'pending_submission' }

  describe '.zone_id' do
    it 'returns ID' do
      expect(subject.zone_id).to eq(zone_id)
    end
  end

  describe '.zone_name' do
    it 'returns name' do
      expect(subject.zone_name).to eq(zone_name)
    end
  end

  describe '.id' do
    it 'returns ID' do
      expect(subject.id).to eq(mandate_id)
    end
  end

  describe '.status' do
    context 'when status is pending_submission' do
      it 'returns a proper value' do
        expect(subject.status).to eq('Pending')
      end
    end

    context 'when status is pending_customer_approval' do
      let(:status) { 'pending_customer_approval' }

      it 'returns a proper value' do
        expect(subject.status).to eq('Pending')
      end
    end

    context 'when status is submitted' do
      let(:status) { 'submitted' }

      it 'returns a proper value' do
        expect(subject.status).to eq('Pending')
      end
    end

    context 'when status is active' do
      let(:status) { 'active' }

      it 'returns a proper value' do
        expect(subject.status).to eq('Active')
      end
    end

    context 'when status is nil' do
      let(:status) { nil }

      it 'returns a nil' do
        expect(subject.status).to be_nil
      end
    end
  end
end
