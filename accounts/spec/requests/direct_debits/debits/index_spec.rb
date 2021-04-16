# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #index', type: :request do
  subject { get debits_path }

  before { mock_direct_debit_enabled }

  context 'when correct permissions' do
    before { sign_in manage_mandates_user }

    context 'when zones have the active mandates' do
      before { mock_debits }

      it 'returns a 200 OK status' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when zones does not have the active mandates' do
      before { mock_debits('empty_mandates') }

      it 'redirects to the create debits page' do
        subject
        expect(response).to redirect_to(set_up_debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'

  context 'when Direct Debits feature disabled' do
    before do
      sign_in manage_mandates_user
      mock_direct_debit_disabled
      mock_debits
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
