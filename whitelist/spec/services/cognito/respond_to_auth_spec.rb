# frozen_string_literal: true

require 'rails_helper'

describe Cognito::RespondToAuthChallenge do
  subject do
    described_class.call(user: user, password: password, confirmation: password_confirmation)
  end

  let(:password) { 'password' }
  let(:password_confirmation) { password }

  let(:user) do
    new_user(
      aws_session: 'a651dc86-2c3f-4ba2-8b1e-c23b5cdeb59a',
      hashed_password: Digest::MD5.hexdigest('temporary_password')
    )
  end

  let(:cognito_user) { new_user }
  let(:auth_response) { OpenStruct.new(authentication_result: OpenStruct.new(access_token: token)) }
  let(:token) { 'a651dc86-2c3f-4ba2-8b1e-c23b5cdeb59a' }

  before do
    allow(Cognito::GetUser).to receive(:call)
      .with(access_token: token, user: user, username: user.username)
      .and_return(cognito_user)
    allow(Cognito::Client.instance).to receive(:respond_to_auth_challenge)
      .with(
        challenge_name: 'NEW_PASSWORD_REQUIRED',
        client_id: anything,
        session: user.aws_session,
        challenge_responses: {
          'NEW_PASSWORD' => password,
          'USERNAME' => user.username,
          'userAttributes.email': user.username
        }
      ).and_return(auth_response)
  end

  it 'returns a cognito user' do
    expect(subject).to eq(cognito_user)
  end

  context 'when NewPasswordForm returns invalid' do
    let(:form) { OpenStruct.new(valid?: false, error_object: {}) }
    let(:error) { I18n.t('password.errors.password_unchanged') }

    before { allow(NewPasswordForm).to receive(:new).and_return(form) }

    it 'raises exception' do
      expect { subject }.to raise_exception(NewPasswordException)
    end
  end

  context 'when Cognito returns InvalidPasswordException' do
    let(:error) { I18n.t('password.errors.complexity') }

    before do
      allow(Cognito::Client.instance).to receive(:respond_to_auth_challenge).and_raise(
        Aws::CognitoIdentityProvider::Errors::InvalidPasswordException.new('', '')
      )
    end

    it 'raises the new password exception' do
      expect { subject }.to raise_exception(NewPasswordException)
    end
  end

  context 'when Cognito returns other exception' do
    let(:error) { I18n.t('expired_session') }

    before do
      allow(Cognito::Client.instance).to receive(:respond_to_auth_challenge).and_raise(
        Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('', '')
      )
    end

    it 'raises exception' do
      expect { subject }.to raise_exception(Cognito::CallException, error)
    end
  end
end
