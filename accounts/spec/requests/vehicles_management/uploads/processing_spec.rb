# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::UploadsController - GET #processing', type: :request do
  subject { get processing_uploads_path }

  context 'when correct permissions' do
    before { sign_in user }

    let(:user) { manage_vehicles_user }

    it 'redirects to the upload page' do
      subject
      expect(response).to redirect_to(uploads_path)
    end

    context 'with filename in the session' do
      let(:filename) { 'filename' }
      let(:upload_job_redis_key) { "account_id_#{user.account_id}" }
      let(:job_id) { SecureRandom.uuid }
      let(:correlation_id) { SecureRandom.uuid }
      let(:large_fleet) { true }
      let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }
      let(:errors) { [] }

      before do
        add_upload_job_to_redis(job_id: job_id, correlation_id: correlation_id, large_fleet: large_fleet)
        allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: errors)
        mock_actual_account_name
        mock_fleet(create_empty_fleet)
      end

      it 'calls FleetsApi.job_status with proper params' do
        subject
        expect(FleetsApi).to have_received(:job_status).with(job_id: job_id, correlation_id: correlation_id)
      end

      describe 'job status' do
        before do
          mock_fleet(create_fleet)
          subject
        end

        context 'when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          context 'with large_fleet is true' do
            it 'redirects to the local exemptions page' do
              expect(response).to redirect_to(local_exemptions_vehicles_path)
            end

            it 'not sets :success flash message' do
              expect(flash[:success]).to be_nil
            end
          end

          context 'with large_fleet is false' do
            let(:large_fleet) { false }

            it 'renders the processing page' do
              expect(response).to render_template(:processing)
            end

            it 'not sets :success flash message' do
              expect(flash[:success]).to be_nil
            end
          end
        end

        context 'when status is SUCCESS' do
          let(:status) { 'SUCCESS' }

          it 'redirects to the local exemptions page' do
            expect(response).to redirect_to(local_exemptions_vehicles_path)
          end
        end

        describe 'when status is RUNNING' do
          let(:status) { 'RUNNING' }

          it 'returns a 200 OK status' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders the processing view' do
            expect(response).to render_template(:processing)
          end
        end

        describe 'FAILURE' do
          let(:status) { 'FAILURE' }
          let(:errors) { ['Some error'] }

          it 'renders the upload page' do
            expect(response).to render_template(:index)
          end

          it 'assigns errors' do
            expect(assigns[:job_errors]).to eq(errors)
          end

          it 'deletes job data from redis' do
            expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
          end
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
