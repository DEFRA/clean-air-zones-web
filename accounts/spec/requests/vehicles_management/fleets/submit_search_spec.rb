# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - POST #submit_details' do
  subject { post fleets_path, params: { vrn: vrn } }

  let(:vrn) { 'ABC123' }

  context 'correct permissions' do
    before do
      mock_clean_air_zones
      sign_in manage_vehicles_user
    end

    context 'with valid params' do
      context 'and vrn found' do
        before do
          mock_fleet
          subject
        end

        it 'returns a 200 OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the view' do
          expect(response).to render_template(:index)
        end
      end

      context 'and vrn not found' do
        before do
          mock_fleet(create_empty_fleet)
          subject
        end

        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the vrn not found page' do
          expect(response).to redirect_to(vrn_not_found_fleets_path(vrn: vrn))
        end
      end
    end

    context 'with an invalid params' do
      before do
        mock_fleet
        subject
      end

      let(:vrn) { '' }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(response).to render_template(:index)
      end

      it 'assigns flash error message' do
        expect(flash[:alert]).to eq('Enter the number plate of the vehicle')
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
