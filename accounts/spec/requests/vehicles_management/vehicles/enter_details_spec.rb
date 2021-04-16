# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #enter_details', type: :request do
  subject { get enter_details_vehicles_path }

  context 'when correct permissions' do
    before { sign_in manage_vehicles_user }

    it 'renders the view' do
      expect(subject).to render_template(:enter_details)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
