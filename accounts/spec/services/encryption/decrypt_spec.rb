# frozen_string_literal: true

require 'rails_helper'

describe Encryption::Decrypt do
  subject { described_class.call(value: token) }

  let(:value) { { test: 'test' } }
  let(:token) { Encryption::Encrypt.call(value: value) }

  it 'decrypts message' do
    expect(subject).to eq(value)
  end

  context 'when token is nil' do
    let(:token) { nil }

    it 'raises ActiveSupport::MessageEncryptor::InvalidMessage' do
      expect { subject }.to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end
  end

  context 'when token is invalid' do
    let(:token) { 'aaaaaaaaaa' }

    it 'raises ActiveSupport::MessageEncryptor::InvalidMessage' do
      expect { subject }.to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end
  end
end
