# frozen_string_literal: true

require 'rails_helper'

describe DirectDebits::Debit, type: :model do
  subject(:debit) { described_class.new(account_id, user_beta_tester: user_beta_tester) }

  let(:account_id) { SecureRandom.uuid }
  let(:user_beta_tester) { false }

  describe '.mandates' do
    subject { debit.mandates }

    context 'when all cazes enabled' do
      before { mock_debits }

      it 'calls DebitsApi.account_mandates with proper params' do
        subject
        expect(DebitsApi).to have_received(:mandates).with(account_id: account_id)
      end

      it 'returns an array of DirectDebits::Mandate instances' do
        expect(subject).to all(be_a(DirectDebits::Mandate))
      end

      it 'returns a proper count of enabled cazes' do
        expect(subject.count).to be(2)
      end

      it 'assigns data to mandates' do
        expect(subject.first.zone_id).not_to be_nil
      end
    end

    context 'when only one caz is enabled and user is not in a beta group' do
      before do
        api_response = read_response('/debits/mandates.json')
        api_response['cleanAirZones'].second['directDebitEnabled'] = false
        allow(DebitsApi).to receive(:mandates).and_return(api_response['cleanAirZones'])
        debit.mandates
      end

      it 'returns an array of DirectDebits::Mandate instances' do
        expect(subject).to all(be_a(DirectDebits::Mandate))
      end

      it 'returns a proper count of enabled cazes' do
        expect(subject.count).to be(1)
      end

      it 'assigns data to mandates' do
        expect(subject.first.zone_id).not_to be_nil
      end
    end

    context 'when only one caz is enabled and user is in a beta group' do
      let(:user_beta_tester) { true }

      before do
        api_response = read_response('/debits/mandates.json')
        api_response['cleanAirZones'].second['directDebitEnabled'] = false
        allow(DebitsApi).to receive(:mandates).and_return(api_response['cleanAirZones'])
        debit.mandates
      end

      it 'returns an array of DirectDebits::Mandate instances' do
        expect(subject).to all(be_a(DirectDebits::Mandate))
      end

      it 'returns a proper count of enabled cazes' do
        expect(subject.count).to be(2)
      end

      it 'assigns data to mandates' do
        expect(subject.first.zone_id).not_to be_nil
      end
    end
  end

  describe '.caz_mandates' do
    subject { debit.caz_mandates(zone_id) }

    before { mock_caz_mandates('caz_mandates') }

    let(:zone_id) { SecureRandom.uuid }

    it 'calls DebitsApi.caz_mandates with proper params' do
      subject
      expect(DebitsApi).to have_received(:caz_mandates).with(account_id: account_id, zone_id: zone_id)
    end

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end

    it 'returns the active mandate' do
      expect(subject['status']).to eq('active')
    end
  end

  describe '.active_mandates' do
    subject { debit.active_mandates }

    before { mock_debits }

    it 'returns an array of DirectDebits::Mandate instances' do
      expect(subject).to all(be_a(DirectDebits::Mandate))
    end

    it 'returns only active mandate' do
      expect(subject.size).to eq(1)
    end
  end

  describe '.inactive_mandates' do
    subject { debit.inactive_mandates }

    before { mock_debits }

    it 'returns an array of DirectDebits::Mandate instances' do
      expect(subject).to all(be_a(DirectDebits::Mandate))
    end

    it 'returns only zone_id' do
      expect(subject.first.zone_id).not_to be_nil
    end

    it 'returns only caz_name' do
      expect(subject.first.zone_name).not_to be_nil
    end

    it 'returns only inactive mandate' do
      expect(subject.size).to eq(1)
    end
  end
end
