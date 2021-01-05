# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.create_account - POST' do
  subject do
    AccountsApi::Accounts.update_company_name(account_id: account_id, company_name: name)
  end

  let(:account_id) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:name) { 'Awesome Inc.' }
  let(:url) { "/accounts/#{account_id}" }

  context 'when the response status is 204' do
    before do
      stub_request(:patch, /#{url}/).to_return(status: 204)
    end

    it 'calls API with proper body' do
      body = { accountName: name }
      subject
      expect(WebMock).to have_requested(:patch, /#{url}/).with(body: body).once
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:patch, /#{url}/).to_return(
        status: 422,
        body: { errorCode: 'duplicate' }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:patch, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
