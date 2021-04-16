# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::AccountUsers do
  subject { described_class.call(account_id: account_id, user_id: user_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe '#call' do
    before { mock_users }

    it 'returns users without owner and without removed' do
      expect(subject.count).to eq(9)
    end

    it 'returns a proper downcase name for the first value' do
      expect(subject.first.name).to eq('anisah Melendez')
    end

    it 'returns a proper downcase name for the last value' do
      expect(subject.last.name).to eq('Reef Giles')
    end

    it 'returns UsersManagement::User instance' do
      expect(subject.first).to be_a(UsersManagement::User)
    end

    it 'calls AccountsApi with proper params' do
      subject
      expect(AccountsApi::Users).to have_received(:users).with(account_id: account_id)
    end
  end

  describe '#filtered' do
    subject { described_class.new(account_id: account_id, user_id: user_id).filtered_users }

    before { mock_users }

    it 'returns users without owner and without removed' do
      expect(subject.count).to eq(9)
    end

    it 'returns a proper first value' do
      expect(subject.first['name']).to eq('John Doe')
    end

    it 'returns a proper last value' do
      expect(subject.last['name']).to eq('Giles Kelsea')
    end

    it 'returns Array instance' do
      expect(subject).to be_a(Array)
    end

    it 'calls AccountsApi with proper params' do
      subject
      expect(AccountsApi::Users).to have_received(:users).with(account_id: account_id)
    end
  end
end
