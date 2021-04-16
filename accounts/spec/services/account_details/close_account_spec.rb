# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::CloseAccount do
  subject { described_class.call(account_id: account_id, reason: reason) }

  let(:account_id) { '0d0e3c3d-5660-459d-8851-9bb27ff097a9' }
  let(:reason) { 'OTHER' }

  before do
    allow(AccountsApi::Accounts).to receive(:close_account).and_return({})
  end

  context 'when API call is successful' do
    it 'returns empty response' do
      expect(subject).to eq({})
    end
  end

  context 'when API call is unsuccessful' do
    before do
      allow(AccountsApi::Accounts).to receive(:close_account)
        .and_raise(BaseApi::Error500Exception.new(503, '', {}))
    end

    it 'raises an exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
