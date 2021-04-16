# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - GET #vrn_not_found', type: :request do
  subject { get vrn_not_found_fleets_path, params: { vrn: vrn } }

  let(:vrn) { 'ABC123' }

  context 'when correct permissions' do
    before do
      sign_in manage_vehicles_user
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:vrn_not_found)
    end

    it 'assigns search value' do
      expect(assigns(:search)).to eq(vrn)
    end
  end

  it_behaves_like 'incorrect permissions'
end
