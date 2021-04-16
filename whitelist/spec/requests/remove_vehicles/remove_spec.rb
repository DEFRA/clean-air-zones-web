# frozen_string_literal: true

require 'rails_helper'

describe 'RemoveVehiclesController - GET #remove', type: :request do
  subject { get remove_vehicles_path }

  before do
    sign_in new_user
    subject
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end
end
