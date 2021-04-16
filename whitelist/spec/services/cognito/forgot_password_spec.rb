# frozen_string_literal: true

require 'rails_helper'

describe Cognito::ForgotPassword do
  subject { described_class.call(username: username) }

  let(:username) { 'wojtek@example.com' }
  let(:cognito_response) { true }
  let(:form) { OpenStruct.new(valid?: true) }

  before do
    allow(Cognito::Client.instance).to receive(:forgot_password).with(
      client_id: anything,
      username: username
    ).and_return(cognito_response)
    allow(ResetPasswordForm).to receive(:new).with(username).and_return(form)
  end

  context 'when form is valid and cognito returns 200' do
    it 'returns true' do
      expect(subject).to be_truthy
    end

    it 'calls ResetPasswordForm' do
      expect(ResetPasswordForm).to receive(:new).with(username)
      subject
    end

    it 'calls Cognito' do
      expect(Cognito::Client.instance).to receive(:forgot_password)
      subject
    end
  end

  context 'when form is invalid' do
    let(:cognito_response) { true }
    let(:form) { OpenStruct.new(valid?: false, message: error) }
    let(:error) { 'Something went wrong' }

    it 'raises exception with proper params' do
      expect { subject }.to raise_exception(Cognito::CallException, error) { |ex|
        ex.path == '/passwords/reset'
      }
    end
  end

  context 'when `Cognito.forgot_password` call fails with proper params' do
    let(:form) { OpenStruct.new(valid?: true) }

    context 'when service raises `ServiceError` exception' do
      before do
        allow(Cognito::Client.instance).to receive(:forgot_password).with(
          client_id: anything,
          username: username
        ).and_raise(
          Aws::CognitoIdentityProvider::Errors::ServiceError.new('', 'error')
        )
      end

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when service raises `UserNotFoundException` exception' do
      before do
        allow(Cognito::Client.instance).to receive(:forgot_password).with(
          client_id: anything,
          username: username
        ).and_raise(
          Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('', 'error')
        )
      end

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end
