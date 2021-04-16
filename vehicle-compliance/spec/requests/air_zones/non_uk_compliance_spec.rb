# frozen_string_literal: true

require 'rails_helper'

describe 'AirZonesController - GET #non_uk_compliance', type: :request do
  subject { get non_uk_compliance_air_zones_path }

  let(:caz) { ['a49afb83-d1b3-48b6-b08b-5db8142045dc'] }

  before { add_vrn_to_session(vrn: 'CU57ABC', checked_zones: caz) }

  context 'when api returns 200 status' do
    before do
      stub_request(:get, /clean-air-zones/).to_return(
        status: 200,
        body: file_fixture('caz_list_response.json').read
      )
      subject
    end

    it 'returns an ok response' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the compliance view' do
      expect(response).to render_template('air_zones/compliance')
    end
  end

  context 'when api returns 422 status' do
    before do
      allow(ComplianceCheckerApi).to receive(:clean_air_zones)
        .and_raise(BaseApi::Error422Exception.new(422, '',
                                                  'message' => 'Something went wrong'))
      subject
    end

    it 'redirects to unable to determine compliance page' do
      expect(response).to redirect_to(cannot_determine_vehicle_checkers_path)
    end
  end
end
