# frozen_string_literal: true

require 'rails_helper'

describe Encryption::Encrypt do
  subject { described_class.call(value: value) }

  let(:value) { { test: 'test' } }

  it 'returns a string' do
    expect(subject).to be_a(String)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'returns a string' do
      expect(subject).to be_a(String)
    end
  end
end
