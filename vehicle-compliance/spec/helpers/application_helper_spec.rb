# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '#remove_duplicated_messages' do
    let(:method) { helper.remove_duplicated_messages(errors) }
    let(:message) { 'Email and email address confirmation must be the same' }
    let(:errors) do
      {
        email: [message],
        email_confirmation: [message],
        message: ['Test message']
      }
    end

    it 'removes duplicates messages' do
      expect(method.flatten(1).select { |s| s == message }.size).to eq(1)
    end

    it 'not removes another messages' do
      expect(method.size).to eq(2)
    end
  end
end
