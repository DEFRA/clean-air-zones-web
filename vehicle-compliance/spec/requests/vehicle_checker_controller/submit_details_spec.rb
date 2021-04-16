# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - POST #submit_details', type: :request do
  subject { post enter_details_vehicle_checkers_path, params: { vrn: vrn, 'registration-country': country } }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }

  before do
    vehicle_details = read_response('vehicle_details_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
    subject
  end

  context 'when VRN is valid' do
    context 'with vehicle is registered in the UK' do
      it 'redirects to confirm details page' do
        expect(response).to redirect_to(confirm_details_vehicle_checkers_path)
      end

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'adds `vrn` to the session' do
        expect(session[:vrn]).to eq(vrn)
      end

      it 'clears `possible_fraud` from the session' do
        expect(session[:possible_fraud]).to be_nil
      end
    end

    context 'with vehicle is registered in the UK when user made a Non-UK selection country' do
      let(:country) { 'Non-UK' }

      it 'redirects to confirm details page' do
        expect(response).to redirect_to(confirm_uk_details_vehicle_checkers_path)
      end

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'adds `vrn` to the session' do
        expect(session[:vrn]).to eq(vrn)
      end

      it 'adds `possible_fraud` to the session' do
        expect(session[:possible_fraud]).to be_truthy
      end
    end

    context 'when VRN has spaces and small letters' do
      let(:vrn) { 'cu57 aBC' }

      it 'adds VRN with spaces and capitalized to the session' do
        expect(session[:vrn]).to eq('CU57ABC')
      end
    end
  end

  context 'when VRN is not valid' do
    context 'with it is empty' do
      let(:vrn) { '' }

      it 'redirects to enter details page' do
        expect(response).to render_template(:enter_details)
      end
    end

    context 'with it is has spaces' do
      let(:vrn) { '  ' }

      it 'redirects to enter details page' do
        expect(response).to render_template(:enter_details)
      end
    end
  end

  context 'when registration country is not valid' do
    let(:country) { '' }

    it 'redirects to enter details page' do
      expect(response).to render_template(:enter_details)
    end
  end
end
