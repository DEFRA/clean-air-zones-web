# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - GET #non_uk', type: :request do
  subject { get non_uk_vehicle_checkers_path }

  let(:register_exempt) { false }
  let(:register_compliant) { false }

  before do
    stub = instance_double('RegisterDetails', register_exempt?: register_exempt,
                                              register_compliant?: register_compliant)

    allow(RegisterDetails).to receive(:new).and_return(stub)
  end

  context 'with VRN in session' do
    before do
      add_vrn_to_session
      subject
    end

    context 'when VRN is not found in any register' do
      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'does not perform redirect' do
        expect(response).not_to be_redirect
      end
    end

    context 'when VRN is exempted' do
      let(:register_exempt) { true }

      it 'redirects to exempt page' do
        expect(response.redirect_url).to eq exemption_vehicle_checkers_url
      end
    end

    context 'when VRN is compliant' do
      let(:register_compliant) { true }

      it 'redirects to compliant page' do
        expect(response.redirect_url).to eq non_uk_compliance_air_zones_url
      end
    end
  end
end
