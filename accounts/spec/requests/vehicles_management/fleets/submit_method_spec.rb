# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - POST #submit_method' do
  subject { post submission_method_fleets_path, params: params }

  let(:params) { { 'submission-method': submission_method } }
  let(:submission_method) { 'upload' }

  context 'correct permissions' do
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
      let(:submission_method) { nil }

      it 'renders the submission_method view' do
        expect(response).to render_template(:submission_method)
      end
    end

    context 'with manual as method' do
      let(:submission_method) { 'manual' }

      it 'redirects to enter details page' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
