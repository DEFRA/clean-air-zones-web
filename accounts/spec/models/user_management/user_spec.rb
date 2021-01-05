# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::User, type: :model do
  subject { described_class.new(data) }

  let(:data) { { 'accountUserId' => user_id, 'name' => name, 'email' => email } }
  let(:user_id) { @uuid }
  let(:name) { 'John Doe' }
  let(:email) { 'Test@example.com' }

  describe '.name' do
    it 'returns name' do
      expect(subject.name).to eq(name)
    end
  end

  describe '.email' do
    it 'returns downcase email' do
      expect(subject.email).to eq('test@example.com')
    end
  end

  describe '.user_id' do
    it 'returns user_id' do
      expect(subject.user_id).to eq(user_id)
    end
  end
end
