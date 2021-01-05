# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #index' do
  subject { get debits_path }

  before { mock_direct_debit_enabled }

  context 'correct permissions' do
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
        expect(response).to redirect_to(new_debit_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'

  context 'when Direct Debits feature disabled' do
    before do
      sign_in manage_mandates_user
      mock_direct_debit_disabled
      subject
    end

    it 'redirects to the not found page' do
      expect(response).to redirect_to(not_found_path)
    end
  end
end
