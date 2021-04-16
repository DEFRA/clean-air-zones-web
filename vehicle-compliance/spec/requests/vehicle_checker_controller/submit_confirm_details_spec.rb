# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - POST #submit_confirm_details', type: :request do
  subject do
    post confirm_details_vehicle_checkers_path, params: {
      confirm_details_form:
        {
          'confirm_details' => confirmation,
          'undetermined' => undetermined
        }
    }
  end

  let(:confirmation) { 'yes' }
  let(:undetermined) { 'false' }

  before do
    vehicle_details = read_response('vehicle_details_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
    add_vrn_to_session
    subject
  end

  context 'when user confirms details and what his vehicle not a taxi or PHV' do
    it 'redirects to compliance page' do
      expect(response).to redirect_to(compliance_air_zones_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to incorrect details page' do
      expect(response).to redirect_to(incorrect_details_vehicle_checkers_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'renders to confirm details page' do
      expect(response).to render_template(:confirm_details)
    end
  end

  context 'when vehicle type is undetermined' do
    let(:undetermined) { 'true' }

    it 'redirects to the cannot determine vehicle page' do
      expect(response).to redirect_to(cannot_determine_vehicle_checkers_path)
    end
  end
end
