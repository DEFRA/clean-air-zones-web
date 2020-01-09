# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #submit_details', type: :request do
  subject(:http_request) do
    post enter_details_vehicle_checkers_path, params: { vrn: vrn, 'registration-country': country }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:vehicle_details) { JSON.parse(file_fixture('vehicle_details_response.json').read) }

  before { http_request }

  context 'when VRN is valid' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'adds VRN to the session' do
      expect(session[:vrn]).to eq(vrn)
    end

    context 'when VRN has spaces and small letters' do
      let(:vrn) { 'cu57 aBC' }

      it 'adds VRN with spaces and capitalized to the session' do
        expect(session[:vrn]).to eq('CU57ABC')
      end
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'redirects to enter details page' do
      expect(response).to render_template(:enter_details)
    end
  end

  context 'when registration country is not valid' do
    let(:country) { '' }

    it 'redirects to enter details page' do
      expect(response).to render_template(:enter_details)
    end
  end
end
