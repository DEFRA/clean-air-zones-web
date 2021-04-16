# frozen_string_literal: true

require 'rails_helper'

describe 'RemoveVehiclesController - POST #submit_remove', type: :request do
  subject { post remove_vehicles_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  before do
    sign_in new_user
    subject
  end

  context 'when VRN is valid' do
    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to search results page' do
      expect(response).to redirect_to(confirm_remove_vehicles_path)
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'renders search page' do
      expect(response).to render_template(:remove)
    end
  end

  context 'when VRN has whitespaces' do
    let(:vrn) { ' A B C ' }

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to search results page' do
      expect(response).to redirect_to(confirm_remove_vehicles_path)
    end
  end
end
