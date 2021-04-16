# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.account - GET' do
  subject { AccountsApi::Accounts.account(account_id: account_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:url) { "/accounts/#{account_id}" }

  context 'when the response status is 200' do
    before do
      stub_request(:get, /#{url}/).to_return(status: 200, body: { accountName: 'Company name' }.to_json)
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, %r{accounts/#{account_id}})
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly('accountName')
    end

    context 'when the response status is 404' do
      before do
        stub_request(:get, /#{url}/).to_return(
          status: 404,
          body: { message: 'Account not found' }.to_json
        )
      end

      it 'raises Error404Exception' do
        expect { subject }.to raise_exception(BaseApi::Error404Exception)
      end
    end

    context 'when the response status is 500' do
      before do
        stub_request(:get, /#{url}/).to_return(
          status: 500,
          body: { message: 'Something went wrong' }.to_json
        )
      end

      it 'raises Error500Exception' do
        expect { subject }.to raise_exception(BaseApi::Error500Exception)
      end
    end
  end
end
