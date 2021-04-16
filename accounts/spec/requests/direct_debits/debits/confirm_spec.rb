# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #confirm', type: :request do
  subject { get confirm_debits_path }

  context 'when correct permissions' do
    before do
      add_to_session(new_payment: { caz_id: SecureRandom.uuid, details: {} })
      mock_clean_air_zones
      sign_in(make_payments_user)
    end

    context 'when zone have some active mandates' do
      before { mock_caz_mandates('caz_mandates') }

      it 'returns a 200 OK status' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when zone does not have any active mandates' do
      before { allow(DebitsApi).to receive(:caz_mandates).and_return([]) }

      it 'redirects to the create a first mandate page' do
        subject
        expect(response).to redirect_to(first_mandate_debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
