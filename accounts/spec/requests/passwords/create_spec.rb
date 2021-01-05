# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - POST #create' do
  subject do
    post passwords_path, params: {
      token: token, passwords: { password: password, password_confirmation: confirmation }
    }
  end

  let(:token) { @uuid }
  let(:password) { 'password' }
  let(:confirmation) { password }

  context 'without token in the session' do
    it 'redirect to invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end

  context 'with a valid token in the session' do
    before do
      add_to_session(reset_password_token: token)
      allow(AccountsApi::Auth).to receive(:set_password).and_return(true)
    end

    it 'redirects to the success page' do
      expect(subject).to redirect_to(success_passwords_path)
    end

    it 'calls AccountsApi::Auth.set_password with right params' do
      expect(AccountsApi::Auth).to receive(:set_password).with(token: token, password: password)
      subject
    end

    it 'clears the token' do
      subject
      expect(session[:reset_password_token]).to be_nil
    end

    context 'when password confirmation is different' do
      let(:confirmation) { 'different_password' }

      it 'renders the view' do
        subject
        expect(response).to render_template(:index)
      end

      it 'does not call AccountsApi::Auth.set_password' do
        expect(AccountsApi::Auth).not_to receive(:set_password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end
    end

    context 'when password is not complex enough' do
      before do
        allow(AccountsApi::Auth).to receive(:set_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid')
        )
      end

      it 'renders the view' do
        subject
        expect(response).to render_template(:index)
      end

      it 'calls AccountsApi::Auth.set_password with right params' do
        expect(AccountsApi::Auth).to receive(:set_password).with(token: token, password: password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end

      it 'assigns a proper error message' do
        subject
        expect(assigns(:errors)[:password]).to include(
          'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number '\
          'and a special character'
        )
      end
    end

    context 'when old password is reused' do
      before do
        allow(AccountsApi::Auth).to receive(:set_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse')
        )
      end

      it 'renders the view' do
        subject
        expect(response).to render_template(:index)
      end

      it 'calls AccountsApi::Auth.set_password with right params' do
        expect(AccountsApi::Auth).to receive(:set_password).with(token: token, password: password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end

      it 'assigns a proper error message' do
        subject
        expect(assigns(:errors)[:password]).to include(I18n.t('update_password_form.errors.password_reused'))
      end
    end

    context 'when token is invalid' do
      before do
        allow(AccountsApi::Auth).to receive(:set_password).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
      end

      it 'clears the token' do
        subject
        expect(session[:reset_password_token]).to be_nil
      end

      it 'redirect to invalid page' do
        expect(subject).to redirect_to(invalid_passwords_path)
      end
    end

    context 'when api returns unknown errorCode' do
      before do
        allow(AccountsApi::Auth).to receive(:set_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => '')
        )
      end

      it 'renders the view' do
        subject
        expect(response).to render_template(:index)
      end

      it 'calls AccountsApi::Auth.set_password with right params' do
        expect(AccountsApi::Auth).to receive(:set_password).with(token: token, password: password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end

      skip it 'assigns a proper error message' do
        subject
        expect(assigns(:errors)[:password]).to include('Something went wrong')
      end
    end
  end

  context 'with a different token in the session' do
    before do
      add_to_session(reset_password_token: SecureRandom.uuid)
    end

    it 'redirect to invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end
end
