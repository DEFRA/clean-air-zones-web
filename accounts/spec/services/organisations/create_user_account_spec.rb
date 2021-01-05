# frozen_string_literal: true

require 'rails_helper'

describe Organisations::CreateUserAccount do
  subject do
    described_class.call(
      organisations_params: params,
      account_id: account_id,
      verification_url: verification_url
    )
  end

  let(:params) do
    strong_params(
      email: email,
      email_confirmation: email,
      password: password,
      password_confirmation: password
    )
  end

  let(:user) { create_owner(email: email) }
  let(:email) { 'email@example.com' }
  let(:password) { '8NAOTpMkx2%9' }
  let(:account_id) { @uuid }
  let(:verification_url) { 'www.example.com' }
  let(:valid) { true }

  context 'when api returns correct response' do
    context 'and form valid' do
      before do
        allow(Organisations::EmailAndPasswordForm)
          .to receive(:new)
          .and_return(instance_double(Organisations::EmailAndPasswordForm, valid?: valid))
        allow(AccountsApi::Users).to receive(:create_user).and_return(read_response('create_user.json'))
      end

      it 'returns the User class' do
        expect(subject.class).to eq(User)
      end

      it 'calls Organisations::EmailAndPasswordForm with proper params' do
        expect(Organisations::EmailAndPasswordForm).to receive(:new).with(params)
        subject
      end

      it 'calls AccountsApi.users with proper params' do
        expect(AccountsApi::Users)
          .to receive(:create_user)
          .with(
            account_id: account_id,
            email: email,
            password: password,
            verification_url: verification_url
          )
        subject
      end
    end

    context 'and form not valid' do
      before do
        allow(Organisations::EmailAndPasswordForm)
          .to receive(:new)
          .and_return(
            instance_double(
              Organisations::EmailAndPasswordForm,
              valid?: false,
              errors: instance_double('messages', messages: error_message)
            )
          )
      end

      let(:error_message) { 'Enter your email address' }

      it 'raises NewPasswordException' do
        expect { subject }.to raise_error(NewPasswordException, error_message)
      end
    end
  end

  context 'when api returns 442 status' do
    let(:error_code) { 'emailNotUnique' }

    before do
      allow(Organisations::EmailAndPasswordForm)
        .to receive(:new)
        .and_return(instance_double(Organisations::EmailAndPasswordForm, valid?: valid))

      stub_request(:post, /users/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when email is not unique' do
      it 'raises `NewPasswordException` exception with proper errors object' do
        expect { subject }.to raise_error(
          an_instance_of(NewPasswordException)
            .and(having_attributes(errors_object: { email: [I18n.t('email.errors.exists')] }))
        )
      end
    end

    context 'when password is not valid' do
      let(:error_code) { 'passwordNotValid' }

      it 'raises `NewPasswordException` exception with proper errors object' do
        expect { subject }.to raise_error(
          an_instance_of(NewPasswordException)
            .and(having_attributes(errors_object: { password: [I18n.t(
              'input_form.errors.password_complexity',
              attribute: 'Password'
            )] }))
        )
      end
    end
  end
end
