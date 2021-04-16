# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - GET #set_up', type: :request do
  subject { get set_up_users_path(token: token, account: account) }

  let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:account) { '546badb2-7ad8-43ab-a8de-da41a74a5744' }

  context 'when company uuid is provided and is correct' do
    before do
      allow(AccountsApi::Accounts).to receive(:account).and_return({ accountName: 'Company name' })
      subject
    end

    it 'does not require login' do
      expect(response).not_to redirect_to(new_user_session_path)
    end

    it 'makes an api call to get company name' do
      expect(AccountsApi::Accounts).to have_received(:account)
    end

    it 'shows no errors' do
      expect(flash[:errors]).to eq(nil)
    end
  end

  context 'when company uuid is provided but not found' do
    before do
      allow(AccountsApi::Accounts).to receive(:account).and_raise(
        BaseApi::Error404Exception.new(404, '', {})
      )
      subject
    end

    it 'makes an api call' do
      expect(AccountsApi::Accounts).to have_received(:account)
    end

    it 'shows correct error' do
      expect(flash[:errors]).to eq({ token: I18n.t('token_form.token_invalid') })
    end
  end

  context 'when company uuid is not provided' do
    let(:account) { nil }

    it 'shows correct error' do
      subject
      expect(flash[:errors]).to eq({ token: I18n.t('token_form.token_invalid') })
    end
  end
end
