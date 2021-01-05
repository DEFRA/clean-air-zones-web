# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::AccountUsers do
  subject { described_class.call(account_id: @uuid, user_id: @uuid) }

  describe '#call' do
    before { mock_users }

    it 'returns users without owner and without removed' do
      expect(subject.count).to eq(9)
    end

    it 'returns sorted users by downcase name' do
      expect(subject.first.name).to eq('anisah Melendez')
      expect(subject.last.name).to eq('Reef Giles')
    end

    it 'returns UsersManagement::User instance' do
      expect(subject.first).to be_a(UsersManagement::User)
    end

    it 'calls AccountsApi with proper params' do
      expect(AccountsApi::Users).to receive(:users).with(account_id: @uuid)
      subject
    end
  end

  describe '#filtered' do
    subject { described_class.new(account_id: @uuid, user_id: @uuid).filtered_users }

    before { mock_users }

    it 'returns users without owner and without removed' do
      expect(subject.count).to eq(9)
    end

    it 'returns not sorted users by name' do
      expect(subject.first['name']).to eq('John Doe')
      expect(subject.last['name']).to eq('Giles Kelsea')
    end

    it 'returns Array instance' do
      expect(subject).to be_a(Array)
    end

    it 'calls AccountsApi with proper params' do
      expect(AccountsApi::Users).to receive(:users).with(account_id: @uuid)
      subject
    end
  end
end
