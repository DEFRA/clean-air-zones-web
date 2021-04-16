# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::UpdateEmail do
  subject do
    described_class.call(password: password, password_confirmation: password_confirmation, token: token)
  end

  let(:password) { 'password' }
  let(:password_confirmation) { password }
  let(:token) { SecureRandom.uuid }

  context 'when params are valid' do
    let(:url) { '/auth/email/change-confirm' }

    context 'with api returns correct response' do
      before do
        allow(NewPasswordForm).to receive(:new).and_return(instance_double(NewPasswordForm, valid?: true))
        allow(AccountsApi::Auth).to receive(:confirm_email).and_return(true)
      end

      it { is_expected.to be_valid }

      it 'calls NewPasswordForm with proper params' do
        subject.valid?
        expect(NewPasswordForm).to have_received(:new).with(
          password: password,
          password_confirmation: password_confirmation
        )
      end

      it 'calls AccountsApi::Auth.confirm_email with proper params' do
        subject.valid?
        expect(AccountsApi::Auth).to have_received(:confirm_email).with(token: token, password: password)
      end
    end

    context 'with api returns 422 status' do
      let(:error_code) { 'passwordNotValid' }

      before do
        stub_request(:put, /#{url}/).to_return(
          status: 422,
          body: { message: '', errorCode: error_code }.to_json
        )
        subject.valid?
      end

      context 'when new password is not complex enough' do
        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject.errors[:password].first).to include(
            'Enter a password at least 12 characters long including at least 1 upper case letter, '\
            '1 number and a special character'
          )
        end
      end

      context 'when old password is reused' do
        let(:error_code) { 'newPasswordReuse' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject.errors[:password]).to include(
            'You have already used that password, choose a new one'
          )
        end
      end

      context 'when token is expired ' do
        let(:error_code) { 'expired' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject.errors[:password]).to include(I18n.t('update_password_form.errors.token_expired'))
        end
      end

      context 'when token is invalid ' do
        let(:error_code) { 'invalid' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject.errors[:password]).to include(I18n.t('update_password_form.errors.token_expired'))
        end
      end

      context 'when unknown code returns' do
        let(:error_code) { 'unknown code' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(subject.errors[:password]).to include('Something went wrong')
        end
      end
    end
  end

  context 'when params are not valid' do
    let(:password) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(subject.errors[:password]).to include(I18n.t('new_password_form.errors.password_missing'))
    end
  end
end
