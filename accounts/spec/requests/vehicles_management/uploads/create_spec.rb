# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::UploadsController - POST #create', type: :request do
  subject { post uploads_path, params: { file: file } }

  let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.csv') }
  let(:file) { Rack::Test::UploadedFile.new(file_path) }

  context 'when correct permissions' do
    let(:user) { manage_vehicles_user }
    let(:filename) { 'filename' }
    let(:job_id) { SecureRandom.uuid }
    let(:correlation_id) { SecureRandom.uuid }
    let(:large_fleet) { false }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(correlation_id)
      stub = instance_double('VehiclesManagement::UploadFile',
                             filename: filename,
                             large_fleet?: large_fleet)
      allow(VehiclesManagement::UploadFile).to receive(:call).and_return(stub)
      allow(FleetsApi).to receive(:register_job).and_return(job_id)
      sign_in user
    end

    context 'with expects the correct behavior' do
      before { subject }

      it 'calls VehiclesManagement::UploadFile with the right params' do
        expect(VehiclesManagement::UploadFile).to have_received(:call)
          .with(file: an_instance_of(ActionDispatch::Http::UploadedFile), user: user)
      end

      it 'triggers job the right params' do
        expect(FleetsApi).to have_received(:register_job).with(
          filename: filename,
          correlation_id: correlation_id,
          large_fleet: large_fleet
        )
      end

      it 'redirects to the process uploading page' do
        expect(response).to redirect_to(processing_uploads_path)
      end

      it 'sets job id in redis' do
        expect(REDIS.hget("account_id_#{user.account_id}", 'job_id')).to eq(job_id)
      end

      it 'sets correlation_id in redis' do
        expect(REDIS.hget("account_id_#{user.account_id}", 'correlation_id'))
          .to eq(correlation_id)
      end
    end

    context 'when the upload fails' do
      before do
        allow(VehiclesManagement::UploadFile).to receive(:call).and_raise(CsvUploadException, alert)
        subject
      end

      let(:alert) { 'alert message' }

      it 'does not trigger job' do
        subject
        expect(FleetsApi).not_to have_received(:register_job)
      end

      it 'redirects to the upload page' do
        expect(response).to redirect_to(uploads_path)
      end

      it 'sets the alert' do
        expect(flash[:alert]).to eq(alert)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
