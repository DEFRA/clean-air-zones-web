# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::PasswordsController - PATCH #update', type: :request do
  subject do
    patch edit_password_path,
          params: {
            passwords: {
              old_password: old_password,
              password: password,
              password_confirmation: password_confirmation
            }
          }
  end

  let(:user_id) { SecureRandom.uuid }
  let(:old_password) { 'old_password12345!' }
  let(:password) { 'new_password12345!' }
  let(:password_confirmation) { 'new_password12345!' }

  context 'when signed in as primary user' do
    before { sign_in create_owner }

    context 'when correct parameters are provided' do
      before { allow(AccountsApi::Auth).to receive(:update_password).and_return(true) }

      it 'redirects to the success page' do
        expect(subject).to redirect_to(primary_users_account_details_path)
      end
    end
  end

  context 'when signed in as non primary user' do
    before { sign_in create_user(user_id: user_id) }

    context 'when correct parameters are provided' do
      before { allow(AccountsApi::Auth).to receive(:update_password).and_return(true) }

      it 'redirects to the success page' do
        expect(subject).to redirect_to(non_primary_users_account_details_path)
      end

      it 'calls AccountsApi::Auth.set_password with right params' do
        subject
        expect(AccountsApi::Auth).to have_received(:update_password).with(
          user_id: user_id,
          old_password: old_password,
          new_password: password
        )
      end
    end

    context 'when old password is invalid' do
      let(:old_password) { 'invalid_password' }

      before do
        allow(AccountsApi::Auth).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'oldPasswordInvalid')
        )
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:old_password]).to include(
          I18n.t('update_password_form.errors.old_password_invalid')
        )
      end
    end

    context 'when new password is not complex enough' do
      let(:password) { '12345' }
      let(:password_confirmation) { '12345' }

      before do
        allow(AccountsApi::Auth).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid')
        )
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:password]).to include(
          'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number '\
          'and a special character'
        )
      end
    end

    context 'when old password is reused' do
      let(:password) { 'new_password1234!' }
      let(:password_confirmation) { 'new_password1234!' }

      before do
        allow(AccountsApi::Auth).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse')
        )
        subject
      end

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:password]).to include(I18n.t('update_password_form.errors.password_reused'))
      end
    end

    context 'when fields are missing' do
      let(:old_password) { nil }
      let(:password) { nil }
      let(:password_confirmation) { nil }

      before { subject }

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end

      it 'assigns correct error message' do
        expected_error = {
          old_password: ['Enter your old password'],
          password: ['Enter your new password'],
          password_confirmation: ['Confirm your new password']
        }
        expect(assigns(:errors)).to eq(expected_error)
      end
    end
  end

  it_behaves_like 'a login required'
end
