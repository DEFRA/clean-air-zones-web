# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.verify_user - POST' do
  subject { AccountsApi::Accounts.verify_user(token: token) }

  let(:token) { '80a367e3-6dc0-4430-97e3-36eb1549cac3' }
  let(:url) { %r{/accounts/verify} }

  context 'when the response status is 200' do
    before do
      stub_request(:post, url).to_return(status: 200, body: '{}')
    end

    it 'calls API with no body' do
      body = { token: token }.to_json
      subject
      expect(WebMock).to have_requested(:post, url).with(body: body).once
    end
  end

  context 'when the response status is 400' do
    before do
      stub_request(:post, url).to_return(
        status: 400,
        body: { message: 'Email already confirmed' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, url).to_return(
        status: 404,
        body: { message: 'User not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end
end
