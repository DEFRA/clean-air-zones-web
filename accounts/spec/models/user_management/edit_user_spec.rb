# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::EditUser, type: :model do
  subject { described_class.new(data, account_user_id) }

  let(:data) { { 'name' => name, 'email' => email, 'permissions' => permissions } }
  let(:account_user_id) { SecureRandom.uuid }
  let(:name) { 'John Doe' }
  let(:email) { 'Test@example.com' }
  let(:permissions) { %w[MAKE_PAYMENTS MANAGE_MANDATES MANAGE_VEHICLES MANAGE_USERS] }

  describe '.account_user_id' do
    it 'returns account_user_id' do
      expect(subject.account_user_id).to eq(account_user_id)
    end
  end

  describe '.name' do
    it 'returns name' do
      expect(subject.name).to eq(name)
    end
  end

  describe '.email' do
    it 'returns downcase email' do
      expect(subject.email).to eq(email)
    end
  end

  describe '.permissions' do
    it 'returns user_id' do
      expect(subject.permissions).to eq(permissions)
    end
  end
end
