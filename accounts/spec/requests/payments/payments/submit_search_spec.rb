# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #submit_search', type: :request do
  subject { post vrn_not_found_payments_path, params: { payment: { vrn_search: vrn } } }

  let(:vrn) { 'ABC123' }
  let(:caz_id) { mocked_uuid }

  context 'when correct permissions' do
    before { sign_in create_user }

    context 'with la in the session' do
      before do
        mock_clean_air_zones
        mock_chargeable_vehicles
        add_to_session(new_payment: { caz_id: caz_id }, payment_query: { search: vrn })
        subject
      end

      context 'with valid params' do
        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the matrix page' do
          expect(response).to redirect_to(matrix_payments_path)
        end

        it 'assigns vrn to the session' do
          expect(session[:payment_query][:search]).to eq(vrn)
        end
      end

      context 'with an invalid params' do
        let(:vrn) { 'ABCDE$%' }

        it 'returns a 200 OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the view' do
          expect(response).to render_template(:vrn_not_found)
        end

        it 'assigns flash error message' do
          expect(flash[:alert]).to eq('Enter the number plate of the vehicle in a valid format')
        end
      end
    end

    context 'without la in the session' do
      it 'redirects to the index' do
        expect(subject).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
