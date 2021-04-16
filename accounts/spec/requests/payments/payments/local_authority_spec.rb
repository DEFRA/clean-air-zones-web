# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #local_authority', type: :request do
  subject { post local_authority_payments_path, params: { caz_id: caz_id } }

  let(:caz_id) { SecureRandom.uuid }
  let(:user) { make_payments_user }

  context 'when correct permissions' do
    let(:total_vehicles_count) { 3 }
    let(:any_undetermined_vehicles) { false }

    before do
      allow(PaymentsApi).to receive(:chargeable_vehicles)
        .and_return({ 'totalVehiclesCount' => total_vehicles_count,
                      'anyUndeterminedVehicles' => any_undetermined_vehicles })
      sign_in user
    end

    context 'when user selects the LA' do
      context 'without upload data in redis' do
        before { subject }

        context 'when user has chargeable and no undetermined vehicles in the selected CAZ' do
          it 'redirects to the matrix' do
            expect(response).to redirect_to(matrix_payments_path)
          end
        end

        context 'when user has no chargeable and no undetermined vehicles in the selected CAZ' do
          let(:total_vehicles_count) { 0 }

          it 'redirects to the no chargeable vehicles page' do
            expect(response).to redirect_to(no_chargeable_vehicles_payments_path)
          end
        end

        context 'when user has no chargeable and undetermined vehicles in the selected CAZ' do
          let(:total_vehicles_count) { 0 }
          let(:any_undetermined_vehicles) { true }

          it 'redirects to the undetermined vehicles page' do
            expect(response).to redirect_to(undetermined_vehicles_payments_path)
          end
        end

        it 'saves caz_id in the session' do
          expect(session[:new_payment][:caz_id]).to eq(caz_id)
        end
      end

      context 'with upload data in redis' do
        before do
          add_upload_job_to_redis
          allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: [])
          subject
        end

        let(:upload_job_redis_key) { "account_id_#{user.account_id}" }

        context 'with when status is SUCCESS' do
          let(:status) { 'SUCCESS' }

          it 'redirects to the matrix page' do
            expect(response).to redirect_to(matrix_payments_path)
          end

          it 'saves caz_id in the session' do
            expect(session[:new_payment][:caz_id]).to eq(caz_id)
          end
        end

        context 'with when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }

          it 'redirects to the calculating chargeability page' do
            expect(response).to redirect_to(calculating_chargeability_uploads_path)
          end

          it 'not saves caz_id in the session' do
            expect(session[:new_payment]).to be_nil
          end
        end

        context 'with when status is RUNNING' do
          let(:status) { 'RUNNING' }

          it 'redirects to the process uploading page' do
            expect(response).to redirect_to(processing_uploads_path)
          end

          it 'not saves caz_id in the session' do
            expect(session[:new_payment]).to be_nil
          end
        end

        context 'with when status is unknown' do
          let(:status) { 'UNKNOWN' }

          it 'redirects to the matrix page' do
            expect(response).to redirect_to(matrix_payments_path)
          end

          it 'saves caz_id in the session' do
            expect(session[:new_payment][:caz_id]).to eq(caz_id)
          end

          it 'deletes job data from redis' do
            expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
          end
        end
      end
    end

    context 'when user does not select the LA' do
      let(:caz_id) { nil }

      before { subject }

      it 'redirects to the index' do
        expect(response).to redirect_to(payments_path)
      end

      it 'does not save caz_id in the session' do
        expect(session[:new_payment]).to be_nil
      end

      it 'returns an alert' do
        expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
      end
    end

    context 'when CAZ locked by another user' do
      before do
        add_caz_lock_to_redis(user, user_id: SecureRandom.uuid)
        add_to_session(new_payment: { caz_id: caz_id })
        subject
      end

      it 'redirects to the payment in progress page' do
        expect(response).to redirect_to(in_progress_payments_path)
      end

      it 'not removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).not_to be_nil
      end
    end

    context 'when CAZ locked by current user' do
      before do
        add_caz_lock_to_redis(user)
        add_to_session(new_payment: { caz_id: caz_id })
        subject
      end

      it 'redirects to the matrix page' do
        expect(response).to redirect_to(matrix_payments_path)
      end

      it 'not removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).not_to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
