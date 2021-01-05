# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - POST #add_to_fleet' do
  subject { post add_to_fleet_vehicles_path }

  context 'correct permissions' do
    context 'when user is not signed in' do
      it 'redirects to the login page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      let(:account_id) { @uuid }
      let(:user) { manage_vehicles_user(account_id: account_id) }
      let(:vehicle_type) { 'Car' }

      before { sign_in user }

      context 'without VRN previously added' do
        before do
          allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
          add_to_session(vrn: @vrn, vehicle_type: vehicle_type)
        end

        it 'adds the vehicle to the fleet' do
          expect(FleetsApi).to receive(:add_vehicle_to_fleet)
            .with(vrn: @vrn, vehicle_type: vehicle_type, account_id: account_id)
          subject
        end

        context do
          before { subject }

          it 'removes vrn from session' do
            expect(session[:vrn]).to be_nil
          end

          it 'removes show_continue_button from session' do
            expect(session[:show_continue_button]).to be_nil
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq("You have successfully added #{@vrn} to your vehicle list.")
          end
        end
      end

      context 'with VRN previously added' do
        let(:message) { 'AccountVehicle already exists' }

        before do
          allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_raise(
            BaseApi::Error422Exception.new(422, '', message: message)
          )
          add_to_session(vrn: @vrn, vehicle_type: vehicle_type)
          user.add_vehicle(@vrn, vehicle_type)
          subject
        end

        it 'removes vrn from session' do
          expect(session[:vrn]).to be_nil
        end

        it 'removes vehicle_type from session' do
          expect(session[:vehicle_type]).to be_nil
        end

        it 'removes show_continue_button from session' do
          expect(session[:show_continue_button]).to be_nil
        end

        it 'sets :warning flash message' do
          expect(flash[:warning]).to eq("#{@vrn} already exists in your vehicle list.")
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
