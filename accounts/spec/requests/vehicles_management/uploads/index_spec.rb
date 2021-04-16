# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::UploadsController - GET #index', type: :request do
  subject { get uploads_path }

  context 'when correct permissions' do
    before do
      sign_in manage_vehicles_user
      mock_actual_account_name
      mock_fleet
    end

    it 'renders the view' do
      expect(subject).to render_template(:index)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
