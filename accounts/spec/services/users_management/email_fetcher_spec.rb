# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::EmailFetcher do
  subject { described_class.new(account_id: account_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:existing_user_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' }
  let(:non_existing_user_id) { 'ee369462-63fe-4869-8ad9-0f02d03da1d6' }

  before { mock_users }

  describe '#for_account_user' do
    it 'calls AccountsApi with proper params' do
      subject.for_account_user(account_id)
      expect(AccountsApi::Users).to have_received(:users).with(account_id: account_id)
    end

    it 'returns email for existing user' do
      expect(subject.for_account_user(existing_user_id)).to eq('john@example.com')
    end

    it 'returns nil for non existing user' do
      expect(subject.for_account_user(non_existing_user_id)).to eq(nil)
    end
  end

  describe '#for_owner' do
    it 'calls AccountsApi with proper params' do
      subject.for_owner
      expect(AccountsApi::Users).to have_received(:users).with(account_id: account_id)
    end

    it 'returns email for owner' do
      expect(subject.for_owner).to eq('test@example.com')
    end
  end
end
