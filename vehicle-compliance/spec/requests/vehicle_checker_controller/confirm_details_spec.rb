# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #confirm_details', type: :request do
  subject(:http_request) { get confirm_details_vehicle_checkers_path }

  let(:vehicle_details) { JSON.parse(file_fixture('vehicle_details_response.json').read) }

  before { add_vrn_to_session }

  context 'when VRN is valid' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    context 'when vehicle is exempt' do
      let(:vehicle_details) { { 'exempt' => true } }

      it 'redirects to exemption page' do
        expect(response).to redirect_to(exemption_vehicle_checkers_path)
      end
    end
  end

  context 'when vehicle is not found' do
    before do
      add_vrn_to_session(vrn: 'CU57ABD')
      allow(ComplianceCheckerApi).to receive(:vehicle_details)
        .and_raise(BaseApi::Error404Exception.new(404, '',
                                                  'registrationNumber' => 'CU57ABD'))
      http_request
    end

    it 'redirects to number not found page' do
      expect(response).to redirect_to(number_not_found_vehicle_checkers_path)
    end
  end

  context 'when API is unavailable' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(Errno::ECONNREFUSED)
      http_request
    end

    it 'redirects to server unavailable' do
      expect(response).to have_http_status(:service_unavailable)
    end
  end

  context 'when API returns 500 error' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details)
        .and_raise(BaseApi::Error500Exception.new(500, '', {}))
      subject
    end

    it 'redirects to server_unavailable' do
      expect(response).to have_http_status(:service_unavailable)
    end

    it 'renders 503 error page' do
      expect(response).to render_template(:service_unavailable)
    end
  end
end
