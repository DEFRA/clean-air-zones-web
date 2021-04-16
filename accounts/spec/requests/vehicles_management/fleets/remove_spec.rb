# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #delete', type: :request do
  subject { get remove_fleets_path }

  before { mock_actual_account_name }

  context 'when correct permissions' do
    let(:no_vrn_path) { fleets_path }

    it_behaves_like 'a vrn required view'
  end

  it_behaves_like 'incorrect permissions'
end
