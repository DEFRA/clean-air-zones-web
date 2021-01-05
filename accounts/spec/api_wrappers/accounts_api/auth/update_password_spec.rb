# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Auth.update_password - POST' do
  subject do
    AccountsApi::Auth.update_password(
      user_id: user_id,
      old_password: old_password,
      new_password: new_password
    )
  end

  let(:user_id) { 'f1409c5e-3241-44b8-8224-8d40ee0fcac6' }
  let(:old_password) { 'old_password12345!' }
  let(:new_password) { 'new_password12345!' }
  let(:url) { %r{auth/password/update} }

  context 'when the response status is 200' do
    before { stub_request(:post, url).to_return(status: 200) }

    it 'calls API with proper body' do
      subject
      expect(WebMock).to have_requested(:post, url).with(
        body: { accountUserId: user_id,
                oldPassword: old_password,
                newPassword: new_password }
      ).once
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, url).to_return(
        status: 422,
        body: { message: 'You have already used that password, choose a new one',
                errorCode: 'newPasswordReuse' }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:post, url).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
