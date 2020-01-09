# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #caz_selection', type: :request do
  subject(:http_request) { get caz_selection_air_zones_path }

  before { add_vrn_to_session }

  context 'when api returns 200 status' do
    before do
      caz_list = JSON.parse(file_fixture('caz_list_response.json').read)['cleanAirZones']
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when api returns 422 status' do
    before do
      allow(ComplianceCheckerApi).to receive(:clean_air_zones)
        .and_raise(BaseApi::Error422Exception.new(422, '',
                                                  'message' => 'Something went wrong'))
      http_request
    end

    it 'redirects to unable to determine compliance page' do
      expect(response).to redirect_to(cannot_determinate_vehicle_checkers_path)
    end
  end
end
