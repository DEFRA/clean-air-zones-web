# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #delete' do
  subject { get delete_fleets_path }

  before { mock_actual_account_name }

  context 'correct permissions' do
    let(:no_vrn_path) { fleets_path }

    it_behaves_like 'a vrn required view'
  end

  it_behaves_like 'incorrect permissions'
end
