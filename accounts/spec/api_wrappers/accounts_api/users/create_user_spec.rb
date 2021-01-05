# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Users.create_user - POST' do
  subject do
    AccountsApi::Users.create_user(
      account_id: account_id,
      email: email,
      password: password,
      verification_url: verification_url
    )
  end

  let(:account_id) { '3fa85f64-5717-4562-b3fc-2c963f66afa6' }
  let(:email) { 'test@example.com' }
  let(:password) { 'password' }
  let(:verification_url) { 'http://example.url' }

  context 'when the response status is 201' do
    before do
      user_details = read_unparsed_response('create_user.json')
      stub_request(:post, /users/).to_return(
        status: 201,
        body: user_details
      )
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly(
        'accountId', 'accountName', 'accountUserId', 'owner', 'permissions', 'email'
      )
    end

    it 'calls API with proper body' do
      body = { email: email, password: password, verificationUrl: verification_url }
      subject
      expect(WebMock).to have_requested(:post, /users/).with(body: body).once
    end

    context 'when email has uppercased signs' do
      let(:email) { 'TEST@example.com' }

      it 'calls API with proper body' do
        body = { email: email.downcase, password: password, verificationUrl: verification_url }
        subject
        expect(WebMock).to have_requested(:post, /users/).with(body: body).once
      end
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, /users/).to_return(
        status: 422,
        body: {
          message: 'Creation failed',
          'details' => %w[emailNotUnique passwordNotValid]
        }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
