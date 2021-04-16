# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #choose_method', type: :request do
  subject { get choose_method_fleets_path }

  context 'when correct permissions' do
    before do
      mock_actual_account_name
      mock_users
      sign_in manage_vehicles_user
    end

    it 'renders the view' do
      expect(subject).to render_template(:choose_method)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
