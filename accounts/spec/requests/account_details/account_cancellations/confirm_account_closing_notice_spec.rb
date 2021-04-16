# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::AccountCancellationsController - POST #account_closing_notice', type: :request do
  subject { post account_closing_notice_path, params: params }

  before { sign_in create_owner }

  let(:params) { { 'confirm-close-account': confirm_close_account } }
  let(:confirm_close_account) { 'yes' }

  context 'when confirm_close_account param is valid' do
    context 'when confirm_close_account = `yes`' do
      it 'redirects to account_cancellation_path' do
        expect(subject).to redirect_to(account_cancellation_path)
      end
    end

    context 'when confirm_close_account = `no`' do
      let(:confirm_close_account) { 'no' }

      it 'redirects back to primary account details page' do
        expect(subject).to redirect_to(primary_users_account_details_path)
      end
    end
  end

  context 'when confirm_close_account param is not valid' do
    let(:confirm_close_account) { nil }

    it 'renders account_closing_notice template' do
      expect(subject).to render_template(:account_closing_notice)
    end
  end
end
