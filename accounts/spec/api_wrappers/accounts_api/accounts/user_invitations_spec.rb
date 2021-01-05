# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Accounts.user_invitations - POST' do
  subject do
    AccountsApi::Accounts.user_invitations(
      account_id: account_id,
      user_id: user_id,
      new_user_data: new_user_data
    )
  end

  let(:account_id) { 'f1409c5e-3241-44b8-8224-8d40ee0fcac6' }
  let(:user_id) { @uuid }
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }
  let(:verification_url) { 'https://google.com' }
  let(:permissions) { %w[MANAGE_VEHICLES MANAGE_USERS] }
  let(:new_user_data) do
    {
      email: email,
      name: name,
      verification_url: verification_url,
      permissions: permissions
    }
  end
  let(:url) { "/accounts/#{account_id}/user-invitations" }

  context 'when the response status is 200' do
    before do
      stub_request(:post, /#{url}/).to_return(status: 200, body: '{}')
    end

    it 'calls API with proper body' do
      body = {
        isAdministeredBy: user_id,
        email: email,
        name: name,
        verificationUrl: verification_url,
        permissions: permissions
      }.to_json
      subject
      expect(WebMock).to have_requested(:post, /#{url}/).with(body: body).once
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 404,
        body: { message: 'The user who initiated the invitation was not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end
end
