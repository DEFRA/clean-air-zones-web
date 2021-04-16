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

    context 'when BUILD_ID variable is defined' do
      let(:build_id) { '50.0' }

      before do
        stub_const('ENV', 'BUILD_ID' => build_id)
        subject
      end

      it 'returns BUILD_ID' do
        expect(response.body).to eq(build_id)
      end

      context 'when format is nil' do
        subject { get '/build_id' }

        it 'returns default format as JSON' do
          expect(response.header['Content-Type']).to include('application/json')
        end
      end
    end
  end
end
