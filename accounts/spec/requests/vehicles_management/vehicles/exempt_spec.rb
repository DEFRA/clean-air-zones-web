# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #exempt' do
  subject { get exempt_vehicles_path }

  context 'correct permissions' do
    let(:no_vrn_path) { enter_details_vehicles_path }

    it_behaves_like 'a vrn required view'
  end

  it_behaves_like 'incorrect permissions'
end
