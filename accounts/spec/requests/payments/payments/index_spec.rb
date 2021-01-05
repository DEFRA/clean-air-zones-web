# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #index' do
  subject { get payments_path, headers: { 'HTTP_REFERER': referer } }

  let(:referer) { 'http://www.example.com' }

  before { sign_in user }

  let(:user) { make_payments_user }

  context 'correct permissions' do
    context 'with empty fleet' do
      before { mock_fleet(create_empty_fleet) }

      it 'redirects to the first upload page' do
        expect(subject).to redirect_to first_upload_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before do
        mock_clean_air_zones
        mock_fleet
      end

      it 'renders the view' do
        expect(subject).to render_template(:index)
      end

      describe ':back_button_url variable' do
        context 'when coming from payment success page' do
          let(:referer) { 'http://www.example.com/payments/success' }

          it 'has a correct value' do
            subject
            expect(assigns(:back_button_url)).to eq(success_payments_path)
          end
        end

        context 'when coming from debits payment success page' do
          let(:referer) { 'http://www.example.com/debits/success' }

          it 'has a correct value' do
            subject
            expect(assigns(:back_button_url)).to eq(success_debits_path)
          end
        end

        context 'when coming from in progress page' do
          let(:referer) { 'http://www.example.com/payments/in_progress' }

          it 'has a correct value' do
            subject
            expect(assigns(:back_button_url)).to eq(in_progress_payments_path)
          end
        end
      end

      context 'and with upload data in redis' do
        before do
          add_upload_job_to_redis
          allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: [])
          subject
        end

        let(:upload_job_redis_key) { "account_id_#{user.account_id}" }

        context 'and when status is SUCCESS' do
          let(:status) { 'SUCCESS' }

          it 'renders the view' do
            expect(response).to render_template(:index)
          end
        end

        context 'and when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }

          it 'redirects to the calculating chargeability page' do
            expect(response).to redirect_to(calculating_chargeability_uploads_path)
          end
        end

        context 'and when status is RUNNING' do
          let(:status) { 'RUNNING' }

          it 'redirects to the process uploading page' do
            expect(response).to redirect_to(processing_uploads_path)
          end
        end

        context 'and when status is unknown' do
          let(:status) { 'UNKNOWN' }

          it 'renders the view' do
            expect(response).to render_template(:index)
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
