# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Auth.update_owner_email - PUT' do
  subject do
    AccountsApi::Auth.update_owner_email(
      account_user_id: account_user_id,
      new_email: new_email,
      confirm_url: confirm_url
    )
  end

  let(:account_user_id) { @uuid }
  let(:new_email) { 'jan@kowalski.com' }
  let(:confirm_url) { 'http://example.com' }

  let(:url) { %r{/auth/email/change-request} }

  before do
    stub_request(:put, url).to_return(
      status: 200,
      body: '{}'
    )
  end

  context 'when the response status is 200' do
    it 'calls API with proper body' do
      subject
      expect(WebMock)
        .to have_requested(:put, url)
        .with(body: { accountUserId: account_user_id, newEmail: new_email, confirmUrl: confirm_url })
        .once
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:put, url).to_return(
        status: 404,
        body: { message: 'User does not exist' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:put, url).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
