# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #not_found', type: :request do
  subject { get not_found_vehicles_path }

  context 'when correct permissions' do
    let(:no_vrn_path) { enter_details_vehicles_path }

    it_behaves_like 'a vrn required view'
  end

  it_behaves_like 'incorrect permissions'
end
