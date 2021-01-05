# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #details' do
  subject { get details_vehicles_path }

  context 'correct permissions' do
    context 'vrn in session is required' do
      before do
        vehicle_details = read_response('vehicle_details.json')
        allow(ComplianceCheckerApi).to receive(:vehicle_details).with(@vrn).and_return(vehicle_details)
      end

      let(:no_vrn_path) { enter_details_vehicles_path }

      it_behaves_like 'a vrn required view'
    end

    context 'when user is signed in' do
      before do
        add_to_session(vrn: @vrn)
        sign_in manage_vehicles_user
      end

      context 'when vehicle is not found' do
        before do
          allow(ComplianceCheckerApi).to receive(:vehicle_details)
            .and_raise(BaseApi::Error404Exception.new(404, '', {}))
          subject
        end

        it 'redirects to the vehicles not found page' do
          expect(response).to redirect_to not_found_vehicles_path
        end
      end

      context 'when api returns 400 status' do
        before do
          allow(ComplianceCheckerApi).to receive(:vehicle_details)
            .and_raise(BaseApi::Error400Exception.new(400, '', 'message' => error))
          subject
        end

        let(:error) { 'Validation error' }

        it 'assigns errors variable' do
          expect(assigns(:errors)).to eq({ vrn: [error] })
        end

        it 'renders the :enter_details view' do
          expect(response).to render_template(:enter_details)
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
