# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::Auth.sign_in - POST' do
  subject { AccountsApi::Auth.sign_in(email: email, password: password) }

  let(:email) { 'test@example.com' }
  let(:password) { 'password' }

  context 'when the response status is 200' do
    before do
      user_details = read_unparsed_response('create_user.json')
      stub_request(:post, %r{auth/login}).to_return(
        status: 200,
        body: user_details
      )
    end

    it 'returns a proper fields' do
      expect(subject.keys).to contain_exactly(
        'accountId', 'accountName', 'accountUserId', 'owner', 'permissions', 'email'
      )
    end

    it 'calls API with proper body' do
      body = { email: email, password: password }
      subject
      expect(WebMock).to have_requested(:post, %r{auth/login}).with(body: body).once
    end

    context 'when email has uppercased signs' do
      let(:email) { 'TEST@example.com' }

      it 'calls API with proper body' do
        body = { email: email.downcase, password: password }
        subject
        expect(WebMock).to have_requested(:post, %r{auth/login}).with(body: body).once
      end
    end
  end

  context 'when the response status is 401' do
    before do
      stub_request(:post, %r{auth/login}).to_return(
        status: 401,
        body: { message: 'Unauthorised' }.to_json
      )
    end

    it 'raises Error401Exception' do
      expect { subject }.to raise_exception(BaseApi::Error401Exception)
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, %r{auth/login}).to_return(
        status: 422,
        body: { message: 'Email unconfirmed' }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
