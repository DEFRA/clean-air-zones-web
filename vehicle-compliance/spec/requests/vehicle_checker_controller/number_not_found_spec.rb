# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - GET #number_not_found', type: :request do
  subject { get number_not_found_vehicle_checkers_path }

  context 'with VRN in session' do
    before do
      add_vrn_to_session
      subject
    end

    it 'returns a not_found response' do
      expect(response).to have_http_status(:not_found)
    end

    it 'renders the view' do
      expect(response).to render_template(:number_not_found)
    end
  end
end
