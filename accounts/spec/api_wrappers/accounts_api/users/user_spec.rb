# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Users.user - GET' do
  subject { AccountsApi::Users.user(account_id: account_id, account_user_id: account_user_id) }

  let(:account_id) { '3fa85f64-5717-4562-b3fc-2c963f66afa6' }
  let(:account_user_id) { 'f1409c5e-3241-44b8-8224-8d40ee0fcac6' }
  let(:url) { "/accounts/#{account_id}/users/#{account_user_id}" }

  context 'when the response status is 200' do
    before do
      user_details = read_unparsed_response('/users_management/user.json')
      stub_request(:get, /#{url}/).to_return(status: 200, body: user_details)
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, %r{accounts/#{account_id}/users})
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly('name', 'email', 'owner', 'permissions')
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
