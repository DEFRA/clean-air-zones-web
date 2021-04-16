# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::AccountCancellationsController - POST #submit_account_cancellation', type: :request do
  subject { post account_cancellation_path, params: params }

  before { sign_in create_owner }

  let(:params) { { reason: reason } }
  let(:reason) { 'OTHER' }

  context 'when reason param is valid' do
    before do
      allow(AccountDetails::CloseAccount).to receive(:call).and_return({})
    end

    it 'calls AccountDetails::CloseAccount service' do
      subject
      expect(AccountDetails::CloseAccount).to have_received(:call)
    end

    it 'redirects to account_closed page' do
      expect(subject).to redirect_to(account_closed_path)
    end
  end

  context 'when reason param is invalid' do
    let(:reason) { nil }

    it 'renders the account_cancellation page' do
      expect(subject).to render_template(:account_cancellation)
    end
  end
end
