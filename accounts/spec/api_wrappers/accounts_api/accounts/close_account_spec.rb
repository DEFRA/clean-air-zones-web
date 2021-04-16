# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.close_account - POST' do
  subject { AccountsApi::Accounts.close_account(account_id: account_id, reason: reason) }

  let(:account_id) { 'c4d782f7-d823-49fc-afcb-f95a514fe358' }
  let(:reason) { 'NON_OPERATIONAL_BUSINESS' }

  context 'when the response status is 204' do
    before { stub_request(:post, /accounts/).to_return(status: 204) }

    it 'calls API with proper body' do
      body = { reason: reason }
      subject
      expect(WebMock).to have_requested(:post, /accounts/).with(body: body).once
    end
  end

  context 'when the response status is 400' do
    before do
      stub_request(:post, /accounts/).to_return(
        status: 400,
        body: { message: 'Reason is invalid' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end
end
