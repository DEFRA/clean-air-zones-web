# frozen_string_literal: true

require 'rails_helper'

describe Organisations::VerifyAccount do
  subject { described_class.call(token: token) }

  let(:token) { 'd9ffd832-c22e-49e7-9261-b6c6619e9d97' }

  before { allow(AccountsApi::Accounts).to receive(:verify_user).and_return(true) }

  it { is_expected.to eq :success }

  it 'calls AccountsApi::Accounts.verify_user with proper params' do
    expect(AccountsApi::Accounts).to receive(:verify_user).with(token: token)
    subject
  end

  context 'when API responds with an error' do
    before do
      allow(AccountsApi::Accounts)
        .to receive(:verify_user)
        .and_raise(BaseApi::Error404Exception.new(404, 'User not found', {}))
    end

    it { is_expected.to eq :invalid }
  end

  context 'when API responds with 422 error' do
    before do
      allow(AccountsApi::Accounts)
        .to receive(:verify_user)
        .and_raise(BaseApi::Error422Exception.new(422, 'User already confirmed',
                                                  'errorCode' => error_code))
    end

    context 'when user is already confirmed' do
      let(:error_code) { 'emailAlreadyVerified' }

      it 'raises UserAlreadyConfirmedException' do
        expect { subject }.to raise_error(UserAlreadyConfirmedException)
      end
    end

    context 'when verification token is expired' do
      let(:error_code) { 'expired' }

      it 'raises UserAlreadyConfirmedException' do
        expect(subject).to eq(:expired)
      end
    end

    context 'when verification token is invalid' do
      let(:error_code) { 'invalid' }

      it 'raises UserAlreadyConfirmedException' do
        expect(subject).to eq(:invalid)
      end
    end
  end
end
