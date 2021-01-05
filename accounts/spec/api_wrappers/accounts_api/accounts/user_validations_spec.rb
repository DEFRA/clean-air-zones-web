# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.user_validations - POST' do
  subject { AccountsApi::Accounts.user_validations(account_id: account_id, email: email, name: name) }

  let(:account_id) { 'f1409c5e-3241-44b8-8224-8d40ee0fcac6' }
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }
  let(:url) { "/accounts/#{account_id}/user-validations" }

  context 'when the response status is 200' do
    before do
      stub_request(:post, /#{url}/).to_return(status: 200, body: '{}')
    end

    it 'calls API with proper body' do
      body = { email: email, name: name }.to_json
      subject
      expect(WebMock).to have_requested(:post, /#{url}/).with(body: body).once
    end
  end

  context 'when the response status is 400' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 400,
        body: { message: 'Email already exists' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end
end
