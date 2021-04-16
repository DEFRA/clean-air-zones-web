# frozen_string_literal: true

require 'rails_helper'

describe 'Api.account_details - GET' do
  subject { AccountsApi::Users.account_details(account_user_id: account_user_id) }

  let(:account_user_id) { SecureRandom.uuid }
  let(:url) { "/users/#{account_user_id}" }

  context 'when the response status is 200' do
    before do
      account_details = read_unparsed_response('/account_details/user.json')
      stub_request(:get, /#{url}/).to_return(status: 200, body: account_details)
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, %r{users/#{account_user_id}})
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly('accountId', 'accountName', 'accountUserId', 'email',
                                              'name', 'owner', 'removed')
    end

    context 'when the response status is 404' do
      before do
        stub_request(:get, /#{url}/).to_return(
          status: 404,
          body: { message: 'Account or user not found' }.to_json
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
