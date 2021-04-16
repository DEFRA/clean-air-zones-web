# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :request do
  describe 'health' do
    subject { get health_path }

    it 'returns a ok response' do
      subject
      expect(response).to be_successful
    end
  end

  describe 'build_id' do
    subject { get build_id_path }

    context 'when BUILD_ID is not defined' do
      before { subject }

      it 'returns a ok response' do
        expect(response).to be_successful
      end

      it 'returns undefined body response' do
        expect(response.body).to eq('undefined')
      end
    end

    context 'when BUILD_ID is defined' do
      let(:build_id) { '50.0' }

      before do
        allow(ENV).to receive(:fetch).with('BUILD_ID', 'undefined').and_return(build_id)
        subject
      end

      it 'returns BUILD_ID' do
        expect(response.body).to eq(build_id)
      end

      context 'when format is HTML' do
        subject { get '/build_id.html' }

        it 'renders 404 error page' do
          expect(response).to render_template(:not_found)
        end
      end

      context 'when format is nil' do
        subject { get '/build_id' }

        it 'returns default format as JSON' do
          expect(response.header['Content-Type']).to include('application/json')
        end
      end
    end
  end

  describe 'check_vrn' do
    subject { get confirm_details_vehicle_checkers_path }

    context 'when no VRN in session' do
      it 'redirects to enter details page' do
        subject
        expect(response).to redirect_to(enter_details_vehicle_checkers_path)
      end
    end
  end
end
