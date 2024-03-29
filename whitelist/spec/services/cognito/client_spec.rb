# frozen_string_literal: true

require 'rails_helper'

describe Cognito::Client do
  subject { Class.new described_class }

  let(:aws_cognito_client) { Aws::CognitoIdentityProvider::Client.new }

  before { allow(Aws::CognitoIdentityProvider::Client).to(receive(:new).and_return(aws_cognito_client)) }

  context 'When cognito client raise ResourceNotFoundException' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException.new('', 'error')
      )
    end

    it 'retries to call after credentials rotation' do
      expect(aws_cognito_client).to receive(:list_users).twice
      begin
        subject.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException # rubocop:disable Lint/SuppressedException
      end
    end
  end

  context 'When cognito client raise UnrecognizedClientException' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::UnrecognizedClientException.new('', 'error')
      )
    end

    it 'retries to call after credentials rotation' do
      expect(aws_cognito_client).to receive(:list_users).twice
      begin
        subject.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::UnrecognizedClientException # rubocop:disable Lint/SuppressedException
      end
    end
  end

  context 'When cognito client raise other exception' do
    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_raise(
        Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('', 'error')
      )
    end

    it 'does not retries the call' do
      expect(aws_cognito_client).to receive(:list_users).once
      begin
        subject.instance.list_users
      rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException # rubocop:disable Lint/SuppressedException
      end
    end
  end

  context 'When cognito client raise other exception' do
    let(:users) { %w[user1 user2] }

    before do
      allow(aws_cognito_client).to(receive(:list_users)).and_return(users)
    end

    it 'returns the result frotm the AWS' do
      response = subject.instance.list_users
      expect(response).to equal(users)
    end

    it 'calls AWS only once' do
      expect(aws_cognito_client).to receive(:list_users).once
      subject.instance.list_users
    end
  end
end
