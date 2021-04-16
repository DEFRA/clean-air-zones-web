# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #set_up', type: :request do
  subject { get set_up_debits_path }

  before { mock_direct_debit_enabled }

  context 'when correct permissions' do
    before { sign_in manage_mandates_user }

    context 'with available zones to add a new mandate' do
      before { mock_debits }

      it 'returns a 200 OK status' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when all zones have the active mandates' do
      before { mock_debits('active_mandates') }

      it 'redirects to the list of Direct Debits' do
        subject
        expect(response).to redirect_to(debits_path)
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

    it 'redirects to the not found page' do
      expect(response).to have_http_status(:ok)
    end
  end
end
