# frozen_string_literal: true

require 'rails_helper'

describe 'UploadController - GET #index', type: :request do
  subject { get authenticated_root_path }

  let(:file_path) do
    File.join(
      'spec',
      'fixtures', 'files', 'csv', 'Whitelist-27-01-2020.csv'
    )
  end
  let(:user) { new_user }

  before { sign_in user }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end

  context 'when user login IP does not match request IP' do
    let(:user) { new_user(login_ip: '0.0.0.0') }

    it 'returns a redirect to login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'logs out the user' do
      subject
      expect(controller.current_user).to be_nil
    end
  end

  context 'when session[:job] is set' do
    let(:correlation_id) { '2458c8d6-9553-4687-9e13-cad47e7e458d' }
    let(:job_name) { '20200124_154821_CSV_FROM_S3_FILENAME' }

    before do
      inject_session(job: { name: job_name, correlation_id: correlation_id })
      allow(RegisterCheckerApi).to receive(:job_errors).and_return(%w[error])
    end

    it 'calls RegisterCheckerApi.job_errors' do
      expect(RegisterCheckerApi).to receive(:job_errors).with(job_name, correlation_id)
      subject
    end

    it 'clears job from session' do
      subject
      expect(session[:job]).to be_nil
    end
  end
end
