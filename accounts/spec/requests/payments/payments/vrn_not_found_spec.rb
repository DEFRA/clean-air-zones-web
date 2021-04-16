# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #vrn_not_found', type: :request do
  subject { get vrn_not_found_payments_path }

  let(:caz_id) { mocked_uuid }

  context 'when correct permissions' do
    before { sign_in create_user }

    context 'with la in the session' do
      before do
        mock_clean_air_zones
        mock_chargeable_vehicles
        add_to_session(new_payment: { caz_id: caz_id }, payment_query: { search: search })
        subject
      end

      let(:search) { 'ABC123' }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(response).to render_template(:vrn_not_found)
      end

      it 'assigns search value' do
        expect(assigns(:search)).to eq(search)
      end
    end

    context 'without la in the session' do
      it 'redirects to the index' do
        subject
        expect(response).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
