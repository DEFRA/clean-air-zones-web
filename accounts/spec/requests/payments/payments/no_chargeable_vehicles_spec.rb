# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #no_chargeable_vehicles' do
  subject { get no_chargeable_vehicles_payments_path }

  context 'correct permissions' do
    before do
      mock_clean_air_zones
      mock_fleet(create_chargeable_vehicles)
      sign_in create_user
      add_to_session(new_payment: { caz_id: @uuid })
    end

    it 'calls ComplianceCheckerApi for CAZ name' do
      expect(ComplianceCheckerApi).to receive(:clean_air_zones)
      subject
    end

    it 'assigns :clean_air_zone_name variable' do
      subject
      expect(assigns(:clean_air_zone_name)).to eq('Birmingham')
    end
  end

  it_behaves_like 'incorrect permissions'
end
