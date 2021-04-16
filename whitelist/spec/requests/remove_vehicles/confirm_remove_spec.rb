# frozen_string_literal: true

require 'rails_helper'

describe 'RemoveVehiclesController - GET #confirm_remove', type: :request do
  subject { get confirm_remove_vehicles_path }

  before { sign_in new_user }

  context 'with `remove_vrn` in session' do
    before do
      add_to_session(remove_vrn: vrn)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'with no `remove_vrn` in session' do
    before do
      subject
    end

    it 'redirects to remove vehicle page' do
      subject
      expect(response).to redirect_to(remove_vehicles_path)
    end
  end
end
