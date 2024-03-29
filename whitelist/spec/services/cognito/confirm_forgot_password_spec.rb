# frozen_string_literal: true

require 'rails_helper'

describe Cognito::ConfirmForgotPassword do
  subject do
    described_class.call(username: username, password: password, code: code, password_confirmation: password)
  end

  let(:username) { 'wojtek@example.com' }
  let(:password) { 'password' }
  let(:code) { '123456' }
  let(:cognito_response) { true }
  let(:form) { OpenStruct.new(valid?: true) }

  before do
    allow(Cognito::Client.instance).to receive(:confirm_forgot_password).with(
      client_id: anything,
      username: username,
      password: password,
      confirmation_code: code
    ).and_return(cognito_response)

    allow(ConfirmResetPasswordForm).to receive(:new).with(
      password: password,
      confirmation: password,
      code: code
    ).and_return(form)
  end

  context 'when subject is valid and cognito returns 200' do
    it 'returns true' do
      expect(subject).to be_truthy
    end

    it 'calls ResetPasswordForm' do
      expect(ConfirmResetPasswordForm).to receive(:new)
      subject
    end

    it 'calls Cognito' do
      expect(Cognito::Client.instance).to receive(:confirm_forgot_password)
      subject
    end
  end

  context 'when subject is invalid' do
    let(:cognito_response) { true }
    let(:form) { OpenStruct.new(valid?: false, message: error) }
    let(:error) { 'Something went wrong' }

    it 'raises exception with proper params' do
      expect { subject }.to raise_exception(Cognito::CallException, error)
    end
  end

  context 'when Cognito call fails' do
    let(:form) { OpenStruct.new(valid?: true) }
    let(:error) { "User with username '#{username}' was not found" }

    before do
      allow(Cognito::Client.instance).to receive(:confirm_forgot_password).with(
        client_id: anything,
        username: username,
        password: password,
        confirmation_code: code
      ).and_raise(exception)
    end

    describe 'Aws::CognitoIdentityProvider::Errors::CodeMismatchException' do
      let(:exception) do
        Aws::CognitoIdentityProvider::Errors::CodeMismatchException.new('', '')
      end

      it 'raises exception with proper params' do
        expect { subject }.to raise_exception(
          Cognito::CallException,
          I18n.t('password.errors.code_mismatch')
        )
      end
    end

    describe 'Aws::CognitoIdentityProvider::Errors::CodeMismatchException' do
      let(:exception) do
        Aws::CognitoIdentityProvider::Errors::InvalidPasswordException.new('', '')
      end

      it 'raises exception with proper params' do
        expect { subject }.to raise_exception(
          Cognito::CallException,
          I18n.t('password.errors.complexity')
        )
      end
    end

    describe 'other error' do
      let(:exception) do
        Aws::CognitoIdentityProvider::Errors::InternalErrorException.new('', '')
      end

      it 'raises exception with proper params' do
        expect { subject }.to raise_exception(Cognito::CallException, 'Something went wrong')
      end
    end
  end
end
