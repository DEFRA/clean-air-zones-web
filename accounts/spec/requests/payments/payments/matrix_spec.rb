# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #matrix', type: :request do
  subject { get matrix_payments_path, params: { page: page } }

  let(:caz_id) { mocked_uuid }
  let(:account_id) { SecureRandom.uuid }
  let(:user) { create_user(account_id: account_id) }
  let(:page) { 1 }

  context 'when correct permissions' do
    before { sign_in user }

    context 'with la in the session' do
      before do
        mock_clean_air_zones
        add_to_session(new_payment: { caz_id: caz_id })
      end

      context 'with api returns 200 status' do
        before { mock_chargeable_vehicles }

        it 'returns a 200 OK status' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'assigns the @d_day_notice' do
          subject
          expect(assigns(:d_day_notice)).to eq(false)
        end

        context 'with search data' do
          before { add_to_session(payment_query: { search: search }) }

          context 'with a valid search value' do
            let(:search) { 'ABC123' }

            it 'returns a 200 OK status' do
              subject
              expect(response).to have_http_status(:ok)
            end

            it 'assigns search value' do
              subject
              expect(assigns(:search)).to eq(search)
            end
          end

          context 'with an invalid search value' do
            let(:search) { 'ABCDE$%' }

            before { subject }

            it 'assigns search value' do
              expect(assigns(:search)).to eq(search)
            end

            it 'assigns flash error message' do
              expect(flash[:alert]).to eq('Enter the number plate of the vehicle in a valid format')
            end
          end
        end

        context 'with CAZ payment locked by another user' do
          before do
            add_caz_lock_to_redis(create_user(account_id: account_id, user_id: SecureRandom.uuid))
            subject
          end

          it 'redirects to :in_progress page' do
            expect(response).to redirect_to(in_progress_payments_path)
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

            it 'renders the view' do
              expect(response).to render_template(:matrix)
            end

            it 'deletes job data from redis' do
              expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
            end
          end

          context 'with when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
            let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }

            it 'redirects to the calculating chargeability page' do
              expect(response).to redirect_to(calculating_chargeability_uploads_path)
            end
          end

          context 'with when status is RUNNING' do
            let(:status) { 'RUNNING' }

            it 'redirects to the process uploading page' do
              expect(response).to redirect_to(processing_uploads_path)
            end
          end

          context 'with when status is unknown' do
            let(:status) { 'UNKNOWN' }

            it 'renders the view' do
              expect(response).to render_template(:matrix)
            end

            it 'deletes job data from redis' do
              expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
            end
          end
        end
      end

      context 'with api returns 400 status' do
        before do
          allow(PaymentsApi).to receive(:chargeable_vehicles).and_raise(
            BaseApi::Error400Exception.new(400, '', {})
          )
          subject
        end

        let(:page) { 999 }

        it 'redirects to the matrix page' do
          expect(response).to redirect_to matrix_payments_path
        end
      end
    end

    context 'without la in the session' do
      it 'redirects to the index' do
        subject
        expect(response).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
