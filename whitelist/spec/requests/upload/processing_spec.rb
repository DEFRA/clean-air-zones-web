# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #processing', type: :request do
  subject { get processing_upload_index_path }

  let(:job_status) { 'SUCCESS' }
  let(:job_name) { '20200124_154821_CSV_FROM_S3_FILENAME' }
  let(:correlation_id) { '2458c8d6-9553-4687-9e13-cad47e7e458d' }
  let(:job_data) { { name: job_name, correlation_id: correlation_id } }

  before { sign_in new_user }

  context 'with valid job data' do
    before do
      inject_session(job: job_data)
      allow(RegisterCheckerApi).to receive(:job_status).and_return(job_status)
      subject
    end

    context 'when job status is SUCCESS' do
      it 'returns a redirect to upload page' do
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    context 'when job status is RUNNING' do
      let(:job_status) { 'RUNNING' }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'does not clear job from session' do
        subject
        expect(session[:job]).to eq(job_data)
      end
    end

    context 'when job status is FAILURE' do
      let(:job_status) { 'FAILURE' }

      it 'returns a redirect to upload page' do
        expect(response).to redirect_to(authenticated_root_path)
      end

      it 'does not clear job from session' do
        subject
        expect(session[:job]).to eq(job_data)
      end
    end
  end

  context 'with missing job data' do
    it 'returns a redirect to root page' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
