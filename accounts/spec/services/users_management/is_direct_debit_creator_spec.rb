# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::IsDirectDebitCreator do
  subject { described_class.call(account_id: account_id, account_user_id: account_user_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:existing_mandate_user_id) { '61c193b6-30b4-4fef-831f-7af7513e40e6' }
  let(:non_existing_mandate_user_id) { 'c72d54fd-e1f9-40d6-899d-d4dff4fc37bb' }

  before { mock_debits }

  describe '#call' do
    context 'when user is mandate creator' do
      let(:account_user_id) { existing_mandate_user_id }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when user is not a mandate creator' do
      let(:account_user_id) { non_existing_mandate_user_id }

      it 'return false' do
        expect(subject).to be_falsey
      end
    end
  end
end
