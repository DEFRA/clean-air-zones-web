# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::User, type: :model do
  subject { described_class.new(data) }

  let(:data) { { name: name, email: email, accountName: account_name }.stringify_keys }
  let(:name) { 'John Doe' }
  let(:email) { 'Test@example.com' }
  let(:account_name) { 'Company name' }

  describe '.name' do
    it 'returns a proper value' do
      expect(subject.name).to eq(name)
    end
  end

  describe '.email' do
    it 'returns a proper value' do
      expect(subject.email).to eq('test@example.com')
    end
  end

  describe '.company_name' do
    it 'returns a proper value' do
      expect(subject.account_name).to eq(account_name)
    end
  end
end
