# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - POST #submit_method', type: :request do
  subject { post choose_method_fleets_path, params: params }

  let(:params) { { 'submission-method': choose_method } }
  let(:choose_method) { 'upload' }

  context 'when correct permissions' do
    before do
      mock_actual_account_name
      sign_in manage_vehicles_user
      subject
    end

    context 'with upload as method' do
      it 'redirects to the upload page' do
        expect(response).to redirect_to(uploads_path)
      end
    end

    context 'without submission method' do
      let(:choose_method) { nil }

      it 'renders the view' do
        expect(response).to render_template(:choose_method)
      end
    end

    context 'with manual as method' do
      let(:choose_method) { 'manual' }

      it 'redirects to enter details page' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
