# frozen_string_literal: true

require 'rails_helper'

describe VrnDetails, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }
  let(:email) { 'user@example.com' }
  let(:date) { '2020-06-22 19:10:25-07' }

  let(:response) do
    {
      vrn: vrn,
      category: 'Early Adopter',
      manufacturer: 'ZAZ',
      reasonUpdated: 'Testing',
      email: email,
      updateTimestamp: date
    }.stringify_keys
  end

  let(:whitelisted) { true }

  before do
    allow(WhitelistApi).to receive(:vrn_details).and_return(response)
  end

  describe '.registration_number' do
    it 'returns a proper registration number' do
      expect(subject.registration_number).to eq(vrn)
    end
  end

  describe '.category' do
    it 'returns a proper value' do
      expect(subject.category).to eq('Early Adopter')
    end
  end

  describe '.manufacturer' do
    it 'returns a proper value' do
      expect(subject.manufacturer).to eq('ZAZ')
    end
  end

  describe '.reason_updated' do
    it 'returns a proper value' do
      expect(subject.reason_updated).to eq('Testing')
    end
  end

  describe '.email' do
    it 'returns a proper value' do
      expect(subject.email).to eq(email)
    end
  end

  describe '.update_timestamp' do
    it 'returns a proper value' do
      expect(subject.update_timestamp).to eq(date)
    end
  end
end
