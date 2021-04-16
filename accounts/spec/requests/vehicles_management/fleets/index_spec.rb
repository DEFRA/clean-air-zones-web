# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #index', type: :request do
  subject { get fleets_path, params: { vrn: vrn } }

  let(:vrn) { nil }

  context 'when correct permissions' do
    before { sign_in user }

    let(:user) { manage_vehicles_user }
    let(:upload_job_redis_key) { "account_id_#{user.account_id}" }

    context 'with empty fleet' do
      before { mock_fleet(create_empty_fleet) }

      it 'redirects to the #choose_method' do
        subject
        expect(response).to redirect_to choose_method_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before { mock_clean_air_zones }

      context 'with without upload data in redis' do
        before do
          mock_fleet
          subject
        end

        it 'renders manage vehicles page' do
          expect(response).to render_template(:index)
        end

        it 'sets default page value to 1' do
          expect(assigns(:pagination).page).to eq(1)
        end

        it 'sets default per_page value to 10' do
          expect(assigns(:pagination).per_page).to eq(10)
        end

        it 'not sets :success flash message' do
          expect(flash[:success]).to be_nil
        end
      end

      context 'with upload data in redis' do
        before do
          add_upload_job_to_redis
          mock_fleet
          allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: [])
          subject
        end

        context 'with when status is SUCCESS' do
          let(:status) { 'SUCCESS' }

          it 'renders manage vehicles page' do
            expect(response).to render_template(:index)
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq('You have successfully uploaded 45 vehicles to your vehicle list.')
          end
        end

        context 'with when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }

          it 'redirects to the calculating chargeability page' do
            expect(response).to redirect_to(calculating_chargeability_uploads_path)
          end

          it 'not sets :success flash message' do
            expect(flash[:success]).to be_nil
          end
        end

        context 'with when status is RUNNING' do
          let(:status) { 'RUNNING' }

          it 'redirects to the process uploading page' do
            expect(response).to redirect_to(processing_uploads_path)
          end

          it 'not sets :success flash message' do
            expect(flash[:success]).to be_nil
          end
        end

        context 'with when status is unknown' do
          let(:status) { 'UNKNOWN' }

          it 'renders manage vehicles page' do
            expect(response).to render_template(:index)
          end

          it 'not sets :success flash message' do
            expect(flash[:success]).to be_nil
          end

          it 'deletes job data from redis' do
            expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
          end
        end
      end

      context 'with when api returns 404 status' do
        before do
          add_upload_job_to_redis
          mock_fleet
          allow(FleetsApi).to receive(:job_status)
            .and_raise(BaseApi::Error404Exception.new(404, '', {}))
          subject
        end

        it 'render the view' do
          expect(response).to render_template(:index)
        end

        it 'deletes job data from redis' do
          expect(REDIS.hget(upload_job_redis_key, 'job_id')).to be_nil
        end
      end

      context 'with search vrn' do
        before { allow(FleetsApi).to receive(:vehicles).and_return(read_response('vehicles.json')['1']) }

        context 'with invalid search vrn format' do
          let(:vrn) { 'ABCDE$%' }

          it 'calls FleetsApi.vehicles with proper params' do
            subject
            expect(FleetsApi).to have_received(:vehicles).with(
              account_id: user.account_id,
              page: 1,
              per_page: 10,
              only_chargeable: nil,
              vrn: nil
            )
          end
        end

        context 'with valid search vrn format' do
          let(:vrn) { 'ABCD123' }

          it 'calls FleetsApi.vehicles with proper params' do
            subject
            expect(FleetsApi).to have_received(:vehicles).with(
              account_id: user.account_id,
              page: 1,
              per_page: 10,
              only_chargeable: nil,
              vrn: vrn
            )
          end
        end
      end
    end

    context 'with invalid page' do
      before do
        allow(FleetsApi).to receive(:vehicles).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to the fleets page' do
        expect(response).to redirect_to fleets_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
