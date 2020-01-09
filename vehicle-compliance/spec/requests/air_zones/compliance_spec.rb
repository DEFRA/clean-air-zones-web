# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:http_request) { post compliance_air_zones_path, params: { caz: caz } }

  let(:caz) { ['leeds'] }

  before { add_vrn_to_session }

  context 'when api returns 200 status' do
    before do
      compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
      allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
      http_request
    end

    it 'returns an ok response' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when api returns 422 status' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_compliance)
        .and_raise(BaseApi::Error422Exception.new(422, '',
                                                  'message' => 'Something went wrong'))
      http_request
    end

    it 'redirects to unable to determine compliance page' do
      expect(response).to redirect_to(cannot_determinate_vehicle_checkers_path)
    end
  end

  context 'when form is invalid' do
    let(:caz) { [] }

    it 'redirects to caz selection page' do
      http_request
      expect(response).to redirect_to(caz_selection_air_zones_path)
    end
  end
end
